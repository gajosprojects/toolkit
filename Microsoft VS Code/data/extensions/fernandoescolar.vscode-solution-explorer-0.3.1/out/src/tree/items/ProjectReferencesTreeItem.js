"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const TreeItem_1 = require("../TreeItem");
const ContextValues_1 = require("../ContextValues");
const ProjectReferencedProjectsTreeItem_1 = require("./ProjectReferencedProjectsTreeItem");
const ProjectReferencedPackagesTreeItem_1 = require("./ProjectReferencedPackagesTreeItem");
class ProjectReferencesTreeItem extends TreeItem_1.TreeItem {
    constructor(context) {
        super(context, "references", TreeItem_1.TreeItemCollapsibleState.Collapsed, ContextValues_1.ContextValues.ProjectReferences);
        this.allowIconTheme = false;
    }
    createChildren(childContext) {
        let result = [];
        result.push(new ProjectReferencedProjectsTreeItem_1.ProjectReferencedProjectsTreeItem(childContext));
        result.push(new ProjectReferencedPackagesTreeItem_1.ProjectReferencedPackagesTreeItem(childContext));
        return Promise.resolve(result);
    }
}
exports.ProjectReferencesTreeItem = ProjectReferencesTreeItem;
//# sourceMappingURL=ProjectReferencesTreeItem.js.map