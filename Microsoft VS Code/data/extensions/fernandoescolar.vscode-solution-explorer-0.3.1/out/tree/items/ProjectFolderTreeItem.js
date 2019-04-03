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
const path = require("path");
const __1 = require("../");
const ContextValues_1 = require("../ContextValues");
const TreeItemFactory = require("../TreeItemFactory");
class ProjectFolderTreeItem extends __1.TreeItem {
    constructor(context, projectFolder) {
        super(context, projectFolder.name, __1.TreeItemCollapsibleState.Collapsed, ContextValues_1.ContextValues.ProjectFolder, projectFolder.fullPath);
        this.projectFolder = projectFolder;
    }
    createChildren(childContext) {
        return __awaiter(this, void 0, void 0, function* () {
            let virtualPath = this.projectFolder.fullPath.replace(path.dirname(this.project.fullPath), '');
            if (virtualPath.startsWith(path.sep))
                virtualPath = virtualPath.substring(1);
            let result = [];
            let items = yield TreeItemFactory.CreateItemsFromProject(childContext, this.project, virtualPath);
            items.forEach(item => result.push(item));
            return result;
        });
    }
}
exports.ProjectFolderTreeItem = ProjectFolderTreeItem;
//# sourceMappingURL=ProjectFolderTreeItem.js.map