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
const Solutions_1 = require("../model/Solutions");
const Projects_1 = require("../model/Projects");
const TreeItemContext_1 = require("./TreeItemContext");
const SolutionFolderTreeItem_1 = require("./items/SolutionFolderTreeItem");
const UnknownProjectTreeItem_1 = require("./items/UnknownProjectTreeItem");
const ProjectTreeItem_1 = require("./items/ProjectTreeItem");
const SolutionTreeItem_1 = require("./items/SolutionTreeItem");
const ProjectFolderTreeItem_1 = require("./items/ProjectFolderTreeItem");
const ProjectFileTreeItem_1 = require("./items/ProjectFileTreeItem");
const CpsProjectTreeItem_1 = require("./items/cps/CpsProjectTreeItem");
const StandardProjectTreeItem_1 = require("./items/standard/StandardProjectTreeItem");
const WebSiteProjectTreeItem_1 = require("./items/website/WebSiteProjectTreeItem");
const NoSolutionTreeItem_1 = require("./items/NoSolutionTreeItem");
function CreateNoSolution(provider, rootPath) {
    let context = new TreeItemContext_1.TreeItemContext(provider, null);
    return Promise.resolve(new NoSolutionTreeItem_1.NoSolutionTreeItem(context, rootPath));
}
exports.CreateNoSolution = CreateNoSolution;
function CreateFromSolution(provider, solution) {
    let context = new TreeItemContext_1.TreeItemContext(provider, solution);
    return Promise.resolve(new SolutionTreeItem_1.SolutionTreeItem(context));
}
exports.CreateFromSolution = CreateFromSolution;
function CreateItemsFromSolution(context, solution, parentGuid) {
    return __awaiter(this, void 0, void 0, function* () {
        let result = [];
        let folders = [];
        let projects = [];
        solution.Projects.forEach(project => {
            if (project.parentProjectGuid != parentGuid)
                return false;
            if (project.projectType == Solutions_1.SolutionProjectType.SolutionFolder)
                folders.push(project);
            else
                projects.push(project);
        });
        folders.sort((a, b) => {
            let x = a.projectName.toLowerCase();
            let y = b.projectName.toLowerCase();
            return x < y ? -1 : x > y ? 1 : 0;
        });
        projects.sort((a, b) => {
            let x = a.projectName.toLowerCase();
            let y = b.projectName.toLowerCase();
            return x < y ? -1 : x > y ? 1 : 0;
        });
        for (let i = 0; i < folders.length; i++) {
            result.push(yield CreateFromProject(context, folders[i]));
        }
        for (let i = 0; i < projects.length; i++) {
            result.push(yield CreateFromProject(context, projects[i]));
        }
        return result;
    });
}
exports.CreateItemsFromSolution = CreateItemsFromSolution;
function CreateFromProject(context, project) {
    return __awaiter(this, void 0, void 0, function* () {
        if (project.projectType == Solutions_1.SolutionProjectType.SolutionFolder) {
            return new SolutionFolderTreeItem_1.SolutionFolderTreeItem(context, project);
        }
        let p = yield Projects_1.ProjectFactory.parse(project);
        let projectContext = context.copy(p);
        if (p) {
            if (p.type == 'cps')
                return new CpsProjectTreeItem_1.CpsProjectTreeItem(projectContext, project);
            if (p.type == 'standard')
                return new StandardProjectTreeItem_1.StandardProjectTreeItem(projectContext, project);
            if (p.type == 'website')
                return new WebSiteProjectTreeItem_1.WebSiteProjectTreeItem(projectContext, project);
            return new ProjectTreeItem_1.ProjectTreeItem(projectContext, project);
        }
        return new UnknownProjectTreeItem_1.UnknownProjectTreeItem(projectContext, project);
    });
}
function CreateItemsFromProject(context, project, virtualPath) {
    return __awaiter(this, void 0, void 0, function* () {
        let items = yield project.getProjectFilesAndFolders(virtualPath);
        let result = [];
        items.folders.forEach(folder => {
            result.push(new ProjectFolderTreeItem_1.ProjectFolderTreeItem(context, folder));
        });
        items.files.forEach(file => {
            result.push(new ProjectFileTreeItem_1.ProjectFileTreeItem(context, file));
        });
        return result;
    });
}
exports.CreateItemsFromProject = CreateItemsFromProject;
//# sourceMappingURL=TreeItemFactory.js.map