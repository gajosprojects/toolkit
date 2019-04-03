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
const fs = require("../../../async/fs");
const xml = require("../../../async/xml");
const SolutionExplorerConfiguration = require("../../../SolutionExplorerConfiguration");
const Utilities = require("../../Utilities");
const PackageReference_1 = require("../PackageReference");
const ProjectReference_1 = require("../ProjectReference");
const FileSystemBasedProject_1 = require("./FileSystemBasedProject");
class CpsProject extends FileSystemBasedProject_1.FileSystemBasedProject {
    constructor(projectInSolution, document) {
        super(projectInSolution, 'cps');
        this.references = [];
        this.packages = [];
        this.document = null;
        this.loaded = false;
        if (document) {
            this.parseDocument(document);
            this.loaded = true;
        }
    }
    refresh() {
        return __awaiter(this, void 0, void 0, function* () {
            this.loaded = false;
            this.references = [];
            this.packages = [];
            yield this.checkProjectLoaded();
        });
    }
    getProjectReferences() {
        return __awaiter(this, void 0, void 0, function* () {
            yield this.checkProjectLoaded();
            return this.references;
        });
    }
    getPackageReferences() {
        return __awaiter(this, void 0, void 0, function* () {
            yield this.checkProjectLoaded();
            return this.packages;
        });
    }
    getProjectFilesAndFolders(virtualPath) {
        const _super = name => super[name];
        return __awaiter(this, void 0, void 0, function* () {
            let result = yield _super("getProjectFilesAndFolders").call(this, virtualPath);
            let files = [];
            let folders = [];
            let ignore = SolutionExplorerConfiguration.getNetCoreIgnore();
            result.files.forEach(file => {
                if (!this.fullPath.endsWith(file.fullPath) && ignore.indexOf(file.name.toLocaleLowerCase()) < 0)
                    files.push(file);
            });
            result.folders.forEach(folder => {
                if (ignore.indexOf(folder.name.toLocaleLowerCase()) < 0)
                    folders.push(folder);
            });
            return { files, folders };
        });
    }
    getFolderList() {
        return __awaiter(this, void 0, void 0, function* () {
            let ignore = SolutionExplorerConfiguration.getNetCoreIgnore();
            let folderPath = path.dirname(this.projectInSolution.fullPath);
            let directories = yield Utilities.getAllDirectoriesRecursive(folderPath, ignore);
            let result = ['.' + path.sep];
            directories.forEach(dirPath => result.push('.' + dirPath.replace(folderPath, '')));
            return result;
        });
    }
    checkProjectLoaded() {
        return __awaiter(this, void 0, void 0, function* () {
            if (this.loaded)
                return;
            yield this.parseProject(this.fullPath);
            this.loaded = true;
        });
    }
    parseProject(projectPath) {
        return __awaiter(this, void 0, void 0, function* () {
            let content = yield fs.readFile(projectPath, 'utf8');
            let document = yield xml.ParseToJson(content);
            this.parseDocument(document);
        });
    }
    parseDocument(document) {
        this.document = document;
        let project = CpsProject.getProjectElement(this.document);
        project.elements.forEach(element => {
            if (element.name === 'ItemGroup') {
                element.elements.forEach(e => {
                    if (e.name === 'PackageReference') {
                        this.packages.push(new PackageReference_1.PackageReference(e.attributes.Include, e.attributes.Include));
                    }
                    if (e.name === 'ProjectReference') {
                        let ref = e.attributes.Include.replace(/\\/g, path.sep).trim();
                        ref = ref.split(path.sep).pop();
                        let extension = ref.split('.').pop();
                        ref = ref.substring(0, ref.length - extension.length - 1);
                        this.references.push(new ProjectReference_1.ProjectReference(ref, e.attributes.Include));
                    }
                });
            }
        });
    }
}
exports.CpsProject = CpsProject;
//# sourceMappingURL=CpsProject.js.map