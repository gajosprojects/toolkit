"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const TreeItem_1 = require("../TreeItem");
const ContextValues_1 = require("../ContextValues");
class NoSolutionTreeItem extends TreeItem_1.TreeItem {
    constructor(context, rootPath) {
        super(context, 'No solution found (right click to create a new one)', TreeItem_1.TreeItemCollapsibleState.None, ContextValues_1.ContextValues.NoSolution, rootPath);
        this.iconPath = null;
    }
}
exports.NoSolutionTreeItem = NoSolutionTreeItem;
//# sourceMappingURL=NoSolutionTreeItem.js.map