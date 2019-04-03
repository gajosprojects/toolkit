"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const TreeItem_1 = require("../TreeItem");
const ContextValues_1 = require("../ContextValues");
class ProjectReferencedProjectTreeItem extends TreeItem_1.TreeItem {
    constructor(context, projectReference) {
        super(context, projectReference.name, TreeItem_1.TreeItemCollapsibleState.None, ContextValues_1.ContextValues.ProjectReferencedProject, projectReference.path);
        this.allowIconTheme = false;
        this.addContextValueSuffix();
    }
}
exports.ProjectReferencedProjectTreeItem = ProjectReferencedProjectTreeItem;
//# sourceMappingURL=ProjectReferencedProjectTreeItem.js.map