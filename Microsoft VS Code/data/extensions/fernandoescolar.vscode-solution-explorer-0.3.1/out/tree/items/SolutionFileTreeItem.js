"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const TreeItem_1 = require("../TreeItem");
const ContextValues_1 = require("../ContextValues");
class SolutionFileTreeItem extends TreeItem_1.TreeItem {
    constructor(context, name, filepath, projectInSolution) {
        super(context, name, TreeItem_1.TreeItemCollapsibleState.None, ContextValues_1.ContextValues.SolutionFile, filepath);
        this.projectInSolution = projectInSolution;
        this.command = {
            command: 'solutionExplorer.openFile',
            arguments: [this],
            title: 'Open File'
        };
    }
    createChildren(childContext) {
        return Promise.resolve([]);
    }
}
exports.SolutionFileTreeItem = SolutionFileTreeItem;
//# sourceMappingURL=SolutionFileTreeItem.js.map