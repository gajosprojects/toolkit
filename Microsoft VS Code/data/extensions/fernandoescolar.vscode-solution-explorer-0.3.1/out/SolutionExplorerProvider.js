"use strict";
var __awaiter = (this && this.__awaiter) || function (thisArg, _arguments, P, generator) {
    return new (P || (P = Promise))(function (resolve, reject) {
        function fulfilled(value) { try { step(generator.next(value)); } catch (e) { reject(e); } }
        function rejected(value) { try { step(generator["throw"](value)); } catch (e) { reject(e); } }
        function step(result) { result.done ? resolve(result.value) : new P(function (resolve) { resolve(result.value); }).then(fulfilled, rejected); }
        step((generator = generator.apply(thisArg, _arguments || [])).next());
    });
};
Object.defineProperty(exports, "__esModule", { value: true });
const vscode = require("vscode");
const path = require("path");
const sln = require("./tree");
const SolutionExplorerConfiguration = require("./SolutionExplorerConfiguration");
const Utilities = require("./model/Utilities");
const Solutions_1 = require("./model/Solutions");
const events_1 = require("./events");
const log_1 = require("./log");
const templates_1 = require("./templates");
class SolutionExplorerProvider {
    //onDidChangeActiveTextEditor
    constructor(workspaceRoot, eventAggregator) {
        this.workspaceRoot = workspaceRoot;
        this.eventAggregator = eventAggregator;
        this.subscription = null;
        this.children = null;
        this.treeView = null;
        this._onDidChangeTreeData = new vscode.EventEmitter();
        this.onDidChangeTreeData = this._onDidChangeTreeData.event;
        this._logger = new log_1.Logger(this.eventAggregator);
        this._templateEngine = new templates_1.TemplateEngine(workspaceRoot);
        vscode.window.onDidChangeActiveTextEditor(() => this.onActiveEditorChanged());
        vscode.window.onDidChangeVisibleTextEditors(data => this.onVisibleEditorsChanged(data));
    }
    get logger() {
        return this._logger;
    }
    get templateEngine() {
        return this._templateEngine;
    }
    register() {
        let showMode = SolutionExplorerConfiguration.getShowMode();
        vscode.commands.executeCommand('setContext', 'solutionExplorer.loadedFlag', !false);
        vscode.commands.executeCommand('setContext', 'solutionExplorer.viewInActivityBar', showMode === SolutionExplorerConfiguration.SHOW_MODE_ACTIVITYBAR);
        vscode.commands.executeCommand('setContext', 'solutionExplorer.viewInExplorer', showMode === SolutionExplorerConfiguration.SHOW_MODE_EXPLORER);
        vscode.commands.executeCommand('setContext', 'solutionExplorer.viewInNone', showMode === SolutionExplorerConfiguration.SHOW_MODE_NONE);
        if (showMode !== SolutionExplorerConfiguration.SHOW_MODE_NONE) {
            this.subscription = this.eventAggregator.subscribe(events_1.EventTypes.File, evt => this.onFileEvent(evt));
            this.treeView = vscode.window.createTreeView('solutionExplorer', { treeDataProvider: this });
        }
    }
    unregister() {
        if (SolutionExplorerConfiguration.getShowMode() !== SolutionExplorerConfiguration.SHOW_MODE_NONE) {
            this.subscription.dispose();
            this.subscription = null;
            this.treeView.dispose();
            this.treeView = null;
        }
    }
    refresh(item) {
        if (item) {
            this._onDidChangeTreeData.fire(item);
        }
        else {
            this.children = null;
            this._onDidChangeTreeData.fire();
        }
    }
    getTreeItem(element) {
        return element;
    }
    getChildren(element) {
        if (!this.workspaceRoot) {
            this.logger.log('No .sln found in workspace');
            return Promise.resolve([]);
        }
        if (element)
            return element.getChildren();
        if (!element && this.children)
            return Promise.resolve(this.children);
        if (!element && !this.children) {
            return this.createSolutionItems();
        }
        return null;
    }
    getParent(element) {
        return element.parent;
    }
    selectFile(filepath) {
        return __awaiter(this, void 0, void 0, function* () {
            if (!this.children)
                return;
            for (let i = 0; i < this.children.length; i++) {
                let result = yield this.children[i].search(filepath);
                if (result) {
                    this.selectTreeItem(result);
                    return;
                }
            }
        });
    }
    selectTreeItem(element) {
        if (this.treeView) {
            this.treeView.reveal(element, { select: true, focus: true });
        }
    }
    createSolutionItems() {
        return __awaiter(this, void 0, void 0, function* () {
            this.children = [];
            let solutionPaths = yield Utilities.searchFilesInDir(this.workspaceRoot, '.sln');
            if (solutionPaths.length <= 0) {
                let altFolders = SolutionExplorerConfiguration.getAlternativeSolutionFolders();
                for (let i = 0; i < altFolders.length; i++) {
                    let altSolutionPaths = yield Utilities.searchFilesInDir(path.join(this.workspaceRoot, altFolders[i]), '.sln');
                    solutionPaths = [...solutionPaths, ...altSolutionPaths];
                }
                if (solutionPaths.length <= 0) {
                    this.children.push(yield sln.CreateNoSolution(this, this.workspaceRoot));
                    return this.children;
                }
            }
            for (let i = 0; i < solutionPaths.length; i++) {
                let s = solutionPaths[i];
                let solution = yield Solutions_1.SolutionFile.Parse(s);
                let item = yield sln.CreateFromSolution(this, solution);
                this.children.push(item);
            }
            if (this.children.length > 0)
                this.checkTemplatesToInstall();
            return this.children;
        });
    }
    onFileEvent(event) {
        let fileEvent = event;
        if (path.dirname(fileEvent.path) == this.workspaceRoot
            && fileEvent.path.endsWith('.sln')) {
            this.children = null;
            this.refresh();
        }
    }
    checkTemplatesToInstall() {
        return __awaiter(this, void 0, void 0, function* () {
            if (SolutionExplorerConfiguration.getCreateTemplateFolderQuestion() && !(yield this.templateEngine.existsTemplates())) {
                let option = yield vscode.window.showWarningMessage("Would you like to create the vscode-solution-explorer templates folder?", 'Yes', 'No');
                if (option !== null && option !== undefined && option == 'Yes') {
                    yield this.templateEngine.creteTemplates();
                }
            }
        });
    }
    onActiveEditorChanged() {
        let shouldExecute = SolutionExplorerConfiguration.getTrackActiveItem();
        if (!shouldExecute)
            return;
        if (!vscode.window.activeTextEditor)
            return;
        if (vscode.window.activeTextEditor.document.uri.scheme !== 'file')
            return;
        this.selectFile(vscode.window.activeTextEditor.document.uri.fsPath);
    }
    onVisibleEditorsChanged(editors) {
    }
}
exports.SolutionExplorerProvider = SolutionExplorerProvider;
//# sourceMappingURL=SolutionExplorerProvider.js.map