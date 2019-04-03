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
const TreeItemIconProvider = require("./TreeItemIconProvider");
const SolutionExplorerConfiguration = require("../SolutionExplorerConfiguration");
var vscode_1 = require("vscode");
exports.TreeItemCollapsibleState = vscode_1.TreeItemCollapsibleState;
class TreeItem extends vscode.TreeItem {
    constructor(context, label, collapsibleState, contextValue, path, command) {
        super(label, collapsibleState);
        this.context = context;
        this.label = label;
        this.collapsibleState = collapsibleState;
        this.contextValue = contextValue;
        this.path = path;
        this.command = command;
        this._allowIconTheme = true;
        this.children = null;
        this.createId();
        this.loadIcon();
    }
    get parent() {
        return this.context.parent;
    }
    get solution() {
        return this.context.solution;
    }
    get project() {
        return this.context.project;
    }
    get allowIconTheme() {
        return this._allowIconTheme;
    }
    set allowIconTheme(val) {
        this._allowIconTheme = val;
        this.loadIcon();
    }
    getChildren() {
        return __awaiter(this, void 0, void 0, function* () {
            if (!this.children) {
                let childContext = this.context.copy(null, this);
                this.children = yield this.createChildren(childContext);
            }
            return this.children;
        });
    }
    collapse() {
        if (this.collapsibleState == vscode.TreeItemCollapsibleState.None)
            return;
        if (this.children)
            this.children.forEach(c => c.collapse());
        this.collapsibleState = vscode.TreeItemCollapsibleState.Collapsed;
        this.context.provider.refresh(this);
    }
    refresh() {
        if (this.children)
            this.children.forEach(c => c.dispose());
        this.children = null;
        this.context.provider.refresh(this);
    }
    dispose() {
        if (this.children)
            this.children.forEach(c => c.dispose());
        this.children = null;
    }
    createChildren(childContext) {
        return Promise.resolve([]);
    }
    addContextValueSuffix() {
        this.contextValue += this.project && this.project.type ? '-' + this.project.type : '';
    }
    createId() {
        let id;
        if (this.parent)
            id = this.parent.id + '-' + this.label + '[' + this.contextValue + ']';
        else if (this.solution)
            id = this.solution.FullPath + '[' + this.contextValue + ']';
        else
            id = this.label + '[' + this.contextValue + ']';
        this.id = id;
    }
    loadIcon() {
        let iconType = SolutionExplorerConfiguration.getSolutionExplorerIcons();
        if (iconType == SolutionExplorerConfiguration.ICONS_CUSTOM
            || (iconType == SolutionExplorerConfiguration.ICONS_MIXED && !this._allowIconTheme)) {
            this.iconPath = TreeItemIconProvider.findIconPath(this.label, this.path, this.contextValue);
        }
        else {
            let fullpath = this.path;
            if (!fullpath)
                fullpath = path.dirname(this.solution.FullPath);
            this.iconPath = null;
            this.resourceUri = vscode.Uri.parse(fullpath);
        }
    }
}
exports.TreeItem = TreeItem;
//# sourceMappingURL=TreeItem.js.map