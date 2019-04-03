"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const TreeItem_1 = require("../TreeItem");
const ContextValues_1 = require("../ContextValues");
const ErrorTreeItem_1 = require("./ErrorTreeItem");
class UnknownProjectTreeItem extends TreeItem_1.TreeItem {
    constructor(context, projectInSolution) {
        super(context, projectInSolution.projectName, TreeItem_1.TreeItemCollapsibleState.Collapsed, ContextValues_1.ContextValues.Project, projectInSolution.fullPath);
        this.projectInSolution = projectInSolution;
        this.allowIconTheme = false;
    }
    createChildren(childContext) {
        return Promise.resolve([new ErrorTreeItem_1.ErrorTreeItem(childContext, 'Unknown project type')]);
    }
}
exports.UnknownProjectTreeItem = UnknownProjectTreeItem;
//# sourceMappingURL=UnknownProjectTreeItem.js.map