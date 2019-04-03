"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const TreeItem_1 = require("../TreeItem");
const ContextValues_1 = require("../ContextValues");
class ProjectReferencedPackageTreeItem extends TreeItem_1.TreeItem {
    constructor(context, pkgRef) {
        super(context, pkgRef.name + ' (' + pkgRef.version + ')', TreeItem_1.TreeItemCollapsibleState.None, ContextValues_1.ContextValues.ProjectReferencedPackage, pkgRef.name);
        this.allowIconTheme = false;
        this.addContextValueSuffix();
    }
}
exports.ProjectReferencedPackageTreeItem = ProjectReferencedPackageTreeItem;
//# sourceMappingURL=ProjectReferencedPackageTreeItem.js.map