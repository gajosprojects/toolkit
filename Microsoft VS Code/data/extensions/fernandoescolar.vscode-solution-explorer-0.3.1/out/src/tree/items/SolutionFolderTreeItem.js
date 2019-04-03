"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const TreeItem_1 = require("../TreeItem");
const TreeItemFactory = require("../TreeItemFactory");
const ContextValues_1 = require("../ContextValues");
class SolutionFolderTreeItem extends TreeItem_1.TreeItem {
    constructor(context, projectInSolution) {
        super(context, projectInSolution.projectName, TreeItem_1.TreeItemCollapsibleState.Expanded, ContextValues_1.ContextValues.SolutionFolder);
        this.projectInSolution = projectInSolution;
    }
    createChildren(childContext) {
        return TreeItemFactory.CreateItemsFromSolution(childContext, this.solution, this.projectInSolution.projectGuid);
    }
}
exports.SolutionFolderTreeItem = SolutionFolderTreeItem;
//# sourceMappingURL=SolutionFolderTreeItem.js.map