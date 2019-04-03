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
const __1 = require("../");
const ContextValues_1 = require("../ContextValues");
const ProjectReferencedPackageTreeItem_1 = require("./ProjectReferencedPackageTreeItem");
class ProjectReferencedPackagesTreeItem extends __1.TreeItem {
    constructor(context) {
        super(context, "packages", __1.TreeItemCollapsibleState.Collapsed, ContextValues_1.ContextValues.ProjectReferencedPackages);
        this.allowIconTheme = false;
        this.addContextValueSuffix();
    }
    createChildren(childContext) {
        return __awaiter(this, void 0, void 0, function* () {
            var refs = yield this.getReferences();
            let result = [];
            refs.forEach(ref => {
                result.push(this.createReferencePackageItem(childContext, ref));
            });
            return result;
        });
    }
    getReferences() {
        return __awaiter(this, void 0, void 0, function* () {
            var refs = yield this.project.getPackageReferences();
            refs.sort((a, b) => {
                var x = a.name.toLowerCase();
                var y = b.name.toLowerCase();
                return x < y ? -1 : x > y ? 1 : 0;
            });
            return refs;
        });
    }
    createReferencePackageItem(childContext, ref) {
        return new ProjectReferencedPackageTreeItem_1.ProjectReferencedPackageTreeItem(childContext, ref);
    }
    loadThemeIcon(fullpath) {
        super.loadThemeIcon(fullpath + ".pkg");
    }
}
exports.ProjectReferencedPackagesTreeItem = ProjectReferencedPackagesTreeItem;
//# sourceMappingURL=ProjectReferencedPackagesTreeItem.js.map