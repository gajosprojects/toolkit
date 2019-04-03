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
class SolutionExplorerProvider {
    //onDidChangeActiveTextEditor
    constructor(workspaceRoot, eventAggregator) {
        this.workspaceRoot = workspaceRoot;
        this.eventAggregator = eventAggregator;
        this.subscription = null;
        this.children = null;
        this._onDidChangeTreeData = new vscode.EventEmitter();
        this.onDidChangeTreeData = this._onDidChangeTreeData.event;
        this._logger = new log_1.Logger(this.eventAggregator);
    }
    get logger() {
        return this._logger;
    }
    register() {
        if (SolutionExplorerConfiguration.getShowInExplorer()) {
            this.subscription = this.eventAggregator.subscribe(events_1.EventTypes.File, evt => this.onFileEvent(evt));
            vscode.window.registerTreeDataProvider('solutionExplorer', this);
        }
    }
    unregister() {
        if (SolutionExplorerConfiguration.getShowInExplorer()) {
            this.subscription.dispose();
            this.subscription = null;
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
        if (!element && !this.children)
            return this.createSolutionItems();
        return null;
    }
    createSolutionItems() {
        return __awaiter(this, void 0, void 0, function* () {
            this.children = [];
            let solutionPaths = yield Utilities.searchFilesInDir(this.workspaceRoot, '.sln');
            if (solutionPaths.length <= 0) {
                this.children.push(yield sln.CreateNoSolution(this, this.workspaceRoot));
                return this.children;
            }
            for (let i = 0; i < solutionPaths.length; i++) {
                let s = solutionPaths[i];
                let solution = yield Solutions_1.SolutionFile.Parse(s);
                let item = yield sln.CreateFromSolution(this, solution);
                this.children.push(item);
            }
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
}
exports.SolutionExplorerProvider = SolutionExplorerProvider;
//# sourceMappingURL=SolutionExplorerProvider.js.map