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
const TreeItem_1 = require("../TreeItem");
const TreeItemFactory = require("../TreeItemFactory");
const ContextValues_1 = require("../ContextValues");
class SolutionFolderTreeItem extends TreeItem_1.TreeItem {
    constructor(context, projectInSolution) {
        super(context, projectInSolution.projectName, TreeItem_1.TreeItemCollapsibleState.Expanded, ContextValues_1.ContextValues.SolutionFolder);
        this.projectInSolution = projectInSolution;
    }
    createChildren(childContext) {
        return TreeItemFactory.CreateItemsFromSolution(childContext, this.solution, this.projectInSolution);
    }
    search(filepath) {
        return __awaiter(this, void 0, void 0, function* () {
            yield this.getChildren();
            for (let i = 0; i < this.children.length; i++) {
                let result = yield this.children[i].search(filepath);
                if (result)
                    return result;
            }
            return null;
        });
    }
}
exports.SolutionFolderTreeItem = SolutionFolderTreeItem;
//# sourceMappingURL=SolutionFolderTreeItem.js.map