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
const index_1 = require("../index");
const ContextValues_1 = require("../ContextValues");
const ProjectReferencedProjectTreeItem_1 = require("./ProjectReferencedProjectTreeItem");
class ProjectReferencedProjectsTreeItem extends index_1.TreeItem {
    constructor(context) {
        super(context, "projects", index_1.TreeItemCollapsibleState.Collapsed, ContextValues_1.ContextValues.ProjectReferencedProjects);
        this.allowIconTheme = false;
        this.addContextValueSuffix();
    }
    createChildren(childContext) {
        return __awaiter(this, void 0, void 0, function* () {
            var refs = yield this.getProjectReferences();
            let result = [];
            refs.forEach(ref => {
                result.push(this.createProjectReferenceItem(childContext, ref));
            });
            return result;
        });
    }
    getProjectReferences() {
        return __awaiter(this, void 0, void 0, function* () {
            var refs = yield this.project.getProjectReferences();
            refs.sort((a, b) => {
                var x = a.name.toLowerCase();
                var y = b.name.toLowerCase();
                return x < y ? -1 : x > y ? 1 : 0;
            });
            return refs;
        });
    }
    createProjectReferenceItem(childContext, ref) {
        return new ProjectReferencedProjectTreeItem_1.ProjectReferencedProjectTreeItem(childContext, ref);
    }
    loadThemeIcon(fullpath) {
        super.loadThemeIcon(fullpath + ".vsix");
    }
}
exports.ProjectReferencedProjectsTreeItem = ProjectReferencedProjectsTreeItem;
//# sourceMappingURL=ProjectReferencedProjectsTreeItem.js.map