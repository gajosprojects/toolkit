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
const _1 = require("../");
const ContextValues_1 = require("../ContextValues");
const ProjectReferencesTreeItem_1 = require("./ProjectReferencesTreeItem");
const TreeItemFactory = require("../TreeItemFactory");
class ProjectTreeItem extends _1.TreeItem {
    constructor(context, projectInSolution) {
        super(context, projectInSolution.projectName, _1.TreeItemCollapsibleState.Collapsed, ContextValues_1.ContextValues.Project, projectInSolution.fullPath);
        this.projectInSolution = projectInSolution;
        this.allowIconTheme = false;
        this.addContextValueSuffix();
    }
    createChildren(childContext) {
        return __awaiter(this, void 0, void 0, function* () {
            let result = [];
            if (this.project.hasReferences) {
                let references = yield this.createReferenceItems(childContext);
                references.forEach(i => result.push(i));
            }
            let items = yield TreeItemFactory.CreateItemsFromProject(childContext, this.project);
            items.forEach(item => result.push(item));
            return result;
        });
    }
    createReferenceItems(childContext) {
        return Promise.resolve([new ProjectReferencesTreeItem_1.ProjectReferencesTreeItem(childContext)]);
    }
}
exports.ProjectTreeItem = ProjectTreeItem;
//# sourceMappingURL=ProjectTreeItem.js.map