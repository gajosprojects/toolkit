"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const __1 = require("../");
const ContextValues_1 = require("../ContextValues");
class ProjectFileTreeItem extends __1.TreeItem {
    constructor(context, projectFile) {
        super(context, projectFile.name, projectFile.hasDependents ? __1.TreeItemCollapsibleState.Collapsed : __1.TreeItemCollapsibleState.None, ContextValues_1.ContextValues.ProjectFile, projectFile.fullPath);
        this.projectFile = projectFile;
        this.command = {
            command: 'solutionExplorer.openFile',
            arguments: [this],
            title: 'Open File'
        };
    }
    createChildren(childContext) {
        let result = [];
        if (this.projectFile.dependents) {
            this.projectFile.dependents.forEach(d => {
                result.push(new ProjectFileTreeItem(childContext, d));
            });
        }
        return Promise.resolve(result);
    }
}
exports.ProjectFileTreeItem = ProjectFileTreeItem;
//# sourceMappingURL=ProjectFileTreeItem.js.map