"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const TreeItem_1 = require("../TreeItem");
const ContextValues_1 = require("../ContextValues");
class ErrorTreeItem extends TreeItem_1.TreeItem {
    constructor(context, text) {
        super(context, text, TreeItem_1.TreeItemCollapsibleState.None, ContextValues_1.ContextValues.Error);
        this.allowIconTheme = false;
    }
}
exports.ErrorTreeItem = ErrorTreeItem;
//# sourceMappingURL=ErrorTreeItem.js.map