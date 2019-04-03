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
const ProjectFile_1 = require("../ProjectFile");
const ProjectFolder_1 = require("../ProjectFolder");
const PackageReference_1 = require("../PackageReference");
const ProjectReference_1 = require("../ProjectReference");
const FileSystemBasedProject_1 = require("./FileSystemBasedProject");
class StandardProject extends FileSystemBasedProject_1.FileSystemBasedProject {
    constructor(projectInSolution, document) {
        super(projectInSolution, 'standard');
        this.loaded = false;
        this.loadedPackages = false;
        this.references = [];
        this.packages = [];
        this.document = null;
        this.folders = [];
        this.filesTree = null;
        this.currentItemGroup = null;
        this.shouldReload = true;
        if (document) {
            this.parseDocument(document);
            this.loaded = true;
        }
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
        return __awaiter(this, void 0, void 0, function* () {
            yield this.checkProjectLoaded();
            let currentLevel = this.filesTree;
            if (virtualPath) {
                let pathParts = virtualPath.split(path.sep);
                pathParts.forEach(part => {
                    let existingPathIndex = currentLevel.findIndex(i => i.name == part);
                    if (existingPathIndex >= 0) {
                        currentLevel = currentLevel[existingPathIndex].children;
                    }
                });
            }
            let folders = [];
            let files = [];
            for (let i = 0; i < currentLevel.length; i++) {
                let item = currentLevel[i];
                let stat = yield fs.lstat(item.fullpath);
                if (stat.isDirectory()) {
                    folders.push(new ProjectFolder_1.ProjectFolder(item.fullpath));
                }
                else {
                    let projectFile = new ProjectFile_1.ProjectFile(item.fullpath);
                    if (this.dependents[item.virtualpath]) {
                        projectFile.hasDependents = true;
                        this.dependents[item.virtualpath].forEach(d => {
                            let dependentFullPath = path.join(path.dirname(this.fullPath), d);
                            projectFile.dependents.push(new ProjectFile_1.ProjectFile(dependentFullPath));
                        });
                    }
                    files.push(projectFile);
                }
            }
            folders.sort((a, b) => {
                let x = a.name.toLowerCase();
                let y = b.name.toLowerCase();
                return x < y ? -1 : x > y ? 1 : 0;
            });
            files.sort((a, b) => {
                let x = a.name.toLowerCase();
                let y = b.name.toLowerCase();
                return x < y ? -1 : x > y ? 1 : 0;
            });
            return { files, folders };
        });
    }
    renameFile(filepath, name) {
        const _super = name => super[name];
        return __awaiter(this, void 0, void 0, function* () {
            yield this.checkProjectLoaded();
            let relativePath = this.getRelativePath(filepath);
            let newRelativePath = path.join(path.dirname(relativePath), name);
            this.renameInNodes(relativePath, newRelativePath);
            let newFilepath = yield _super("renameFile").call(this, filepath, name);
            yield this.saveProject();
            return newFilepath;
        });
    }
    deleteFile(filepath) {
        const _super = name => super[name];
        return __awaiter(this, void 0, void 0, function* () {
            yield this.checkProjectLoaded();
            let relativePath = this.getRelativePath(filepath);
            let folderRelativePath = path.dirname(relativePath);
            this.removeInNodes(relativePath);
            if (this.countInNodes(folderRelativePath, true) == 0) {
                this.currentItemGroupAdd('Folder', folderRelativePath, true);
            }
            yield _super("deleteFile").call(this, filepath);
            yield this.saveProject();
        });
    }
    createFile(folderpath, filename, content) {
        const _super = name => super[name];
        return __awaiter(this, void 0, void 0, function* () {
            yield this.checkProjectLoaded();
            let folderRelativePath = this.getRelativePath(folderpath);
            let relativePath = path.join(folderRelativePath, filename);
            let extension = relativePath.split('.').pop().toLocaleLowerCase();
            let type = 'None';
            let itemTypes = SolutionExplorerConfiguration.getItemTypes();
            if (itemTypes[extension]) {
                type = itemTypes[extension];
            }
            else {
                type = itemTypes['*'];
            }
            if (!type)
                type = 'None';
            if (folderRelativePath) {
                // maybe the folder was empty
                this.removeInNodes(folderRelativePath, true, ['Folder']);
            }
            this.currentItemGroupAdd(type, relativePath);
            yield this.saveProject();
            return yield _super("createFile").call(this, folderpath, filename, content);
        });
    }
    renameFolder(folderpath, name) {
        const _super = name => super[name];
        return __awaiter(this, void 0, void 0, function* () {
            yield this.checkProjectLoaded();
            let relativePath = this.getRelativePath(folderpath);
            let newRelativePath = path.join(path.dirname(relativePath), name);
            this.renameInNodes(relativePath, newRelativePath, true);
            let newFolderpath = yield _super("renameFolder").call(this, folderpath, name);
            yield this.saveProject();
            return newFolderpath;
        });
    }
    deleteFolder(folderpath) {
        const _super = name => super[name];
        return __awaiter(this, void 0, void 0, function* () {
            yield this.checkProjectLoaded();
            let folderRelativePath = this.getRelativePath(folderpath);
            this.removeInNodes(folderRelativePath, true, ['Folder']);
            yield _super("deleteFolder").call(this, folderpath);
            yield this.saveProject();
        });
    }
    createFolder(folderpath) {
        const _super = name => super[name];
        return __awaiter(this, void 0, void 0, function* () {
            yield this.checkProjectLoaded();
            let folderRelativePath = this.getRelativePath(folderpath);
            let parentRelativePath = path.dirname(folderRelativePath);
            if (parentRelativePath) {
                // maybe the container folder was empty
                this.removeInNodes(parentRelativePath, true, ['Folder']);
            }
            this.currentItemGroupAdd('Folder', folderRelativePath, true);
            let newFolderpath = yield _super("createFolder").call(this, folderpath);
            yield this.saveProject();
            return newFolderpath;
        });
    }
    getFolderList() {
        return __awaiter(this, void 0, void 0, function* () {
            let folderPath = path.dirname(this.projectInSolution.fullPath);
            let directories = yield this.getFoldersFromTree(this.filesTree);
            directories.sort((a, b) => {
                let x = a.toLowerCase();
                let y = b.toLowerCase();
                return x < y ? -1 : x > y ? 1 : 0;
            });
            let result = ['.' + path.sep];
            directories.forEach(dirPath => result.push('.' + dirPath.replace(folderPath, '')));
            return result;
        });
    }
    moveFile(filepath, newfolderPath) {
        const _super = name => super[name];
        return __awaiter(this, void 0, void 0, function* () {
            yield this.checkProjectLoaded();
            let newFilepath = yield _super("moveFile").call(this, filepath, newfolderPath);
            let relativePath = this.getRelativePath(filepath);
            let newRelativePath = this.getRelativePath(newFilepath);
            this.renameInNodes(relativePath, newRelativePath);
            yield this.saveProject();
            return newFilepath;
        });
    }
    moveFolder(folderpath, newfolderPath) {
        const _super = name => super[name];
        return __awaiter(this, void 0, void 0, function* () {
            yield this.checkProjectLoaded();
            let newFolderPath = yield _super("moveFile").call(this, folderpath, newfolderPath);
            let relativePath = this.getRelativePath(folderpath);
            let newRelativePath = this.getRelativePath(newFolderPath);
            this.renameInNodes(relativePath, newRelativePath, true);
            yield this.saveProject();
            return newFolderPath;
        });
    }
    refresh() {
        return __awaiter(this, void 0, void 0, function* () {
            if (!this.shouldReload) {
                this.shouldReload = true;
                return;
            }
            this.loaded = false;
            this.loadedPackages = false;
            this.references = [];
            yield this.checkProjectLoaded();
        });
    }
    checkProjectLoaded() {
        return __awaiter(this, void 0, void 0, function* () {
            if (!this.loaded) {
                let content = yield fs.readFile(this.fullPath, 'utf8');
                yield this.parseProject(content);
                this.loaded = true;
            }
            if (!this.loadedPackages) {
                yield this.parsePackages();
                this.loadedPackages = true;
            }
        });
    }
    saveProject() {
        return __awaiter(this, void 0, void 0, function* () {
            this.shouldReload = false;
            let content = yield xml.ParseToXml(this.document);
            yield fs.writeFile(this.fullPath, content);
            yield this.parseProject(content);
        });
    }
    parseProject(content) {
        return __awaiter(this, void 0, void 0, function* () {
            let document = yield xml.ParseToJson(content);
            this.parseDocument(document);
        });
    }
    parseDocument(document) {
        this.loaded = true;
        this.document = document;
        let files = [];
        let folders = [];
        let dependents = {};
        let addFile = ref => {
            if (ref.DependentUpon) {
                let parent = ref.DependentUpon[0];
                if (!dependents[parent])
                    dependents[parent] = [];
                dependents[parent].push(ref.$.Include);
            }
            else {
                files.push(ref.$.Include);
            }
        };
        if (this.document.Project && this.document.Project.ItemGroup) {
            this.document.Project.ItemGroup.forEach(element => {
                if (element.Reference) {
                    element.Reference.forEach(ref => {
                        this.references.push(new ProjectReference_1.ProjectReference(ref.$.Include, ref.$.Include));
                    });
                }
                if (element.Compile) {
                    element.Compile.forEach(addFile);
                }
                if (element.Content) {
                    element.Content.forEach(addFile);
                }
                if (element.TypeScriptCompile) {
                    element.TypeScriptCompile.forEach(addFile);
                }
                if (element.None) {
                    element.None.forEach(addFile);
                }
                if (element.Folder) {
                    element.Folder.forEach(ref => {
                        addFile(ref);
                        let folder = ref.$.Include.replace(/\\/g, path.sep);
                        if (folder.endsWith(path.sep))
                            folder = folder.substring(0, folder.length - 1);
                        folders.push(folder);
                    });
                }
            });
        }
        this.filesTree = this.parseToTree(files);
        this.folders = folders;
        this.dependents = dependents;
    }
    parsePackages() {
        return __awaiter(this, void 0, void 0, function* () {
            this.packages = [];
            let packagesPath = path.join(path.dirname(this.fullPath), 'packages.config');
            if (!(yield fs.exists(packagesPath)))
                return;
            let content = yield fs.readFile(packagesPath, 'utf8');
            let packageRegEx = /<package\s+id=\"(.*)\"\s+version=\"(.*)\"\s+targetFramework=\"(.*)\"/g;
            let m;
            while ((m = packageRegEx.exec(content)) !== null) {
                this.packages.push(new PackageReference_1.PackageReference(m[1].trim(), m[2].trim()));
            }
        });
    }
    parseToTree(files) {
        let tree = [];
        files.forEach(filepath => {
            filepath = filepath.replace(/\\/g, path.sep);
            let pathParts = filepath.split(path.sep);
            let currentLevel = tree;
            let currentFullPath = path.dirname(this.fullPath);
            pathParts.forEach(part => {
                if (!part)
                    return;
                currentFullPath = path.join(currentFullPath, part);
                let existingPathIndex = currentLevel.findIndex(i => i.name == part);
                if (existingPathIndex >= 0) {
                    currentLevel = currentLevel[existingPathIndex].children;
                }
                else {
                    let newPart = {
                        name: part,
                        virtualpath: filepath,
                        fullpath: currentFullPath,
                        children: [],
                    };
                    currentLevel.push(newPart);
                    currentLevel = newPart.children;
                }
            });
        });
        return tree;
    }
    countInNodes(pattern, isFolder = false) {
        pattern = pattern.replace(/\//g, '\\') + (isFolder ? '\\' : '');
        let counter = 0;
        let findPattern = ref => {
            if (ref.$.Include.startsWith(pattern)) {
                counter++;
            }
        };
        this.document.Project.ItemGroup.forEach(element => {
            if (element.Compile) {
                element.Compile.forEach(findPattern);
            }
            if (element.Content) {
                element.Content.forEach(findPattern);
            }
            if (element.TypeScriptCompile) {
                element.TypeScriptCompile.forEach(findPattern);
            }
            if (element.None) {
                element.None.forEach(findPattern);
            }
            if (element.Folder) {
                element.Folder.forEach(findPattern);
            }
        });
        return counter;
    }
    renameInNodes(pattern, newPattern, isFolder = false) {
        pattern = pattern.replace(/\//g, '\\') + (isFolder ? '\\' : '');
        newPattern = newPattern.replace(/\//g, '\\') + (isFolder ? '\\' : '');
        let findPattern = ref => {
            if (ref.DependentUpon && ref.DependentUpon[0].startsWith(pattern)) {
                ref.DependentUpon[0] = ref.DependentUpon[0].replace(pattern, newPattern);
            }
            if (ref.$.Include.startsWith(pattern)) {
                ref.$.Include = ref.$.Include.replace(pattern, newPattern);
            }
        };
        this.document.Project.ItemGroup.forEach(element => {
            if (element.Compile) {
                element.Compile.forEach(findPattern);
            }
            if (element.Content) {
                element.Content.forEach(findPattern);
            }
            if (element.TypeScriptCompile) {
                element.TypeScriptCompile.forEach(findPattern);
            }
            if (element.None) {
                element.None.forEach(findPattern);
            }
            if (element.Folder) {
                element.Folder.forEach(findPattern);
            }
        });
    }
    removeInNodes(pattern, isFolder = false, types = ['Compile', 'Content', 'TypeScriptCompile', 'None', 'Folder']) {
        pattern = pattern.replace(/\//g, '\\') + (isFolder ? '\\' : '');
        this.document.Project.ItemGroup.forEach(element => {
            types.forEach(type => {
                if (!element[type])
                    return;
                element[type].forEach(node => {
                    if (node.DependentUpon && node.DependentUpon[0].startsWith(pattern)) {
                        delete node.DependentUpon;
                    }
                    if (node.$.Include.startsWith(pattern)) {
                        element[type].splice(element[type].indexOf(node), 1);
                    }
                });
                if (element[type].length == 0)
                    delete element[type];
            });
            if (Object.keys(element).length == 0) {
                this.document.Project.ItemGroup.splice(this.document.Project.ItemGroup.indexOf(element), 1);
            }
        });
    }
    currentItemGroupAdd(type, include, isFolder = false) {
        this.checkCurrentItemGroup();
        include = include.replace(/\//g, '\\') + (isFolder ? '\\' : '');
        if (!this.currentItemGroup[type])
            this.currentItemGroup[type] = [];
        this.currentItemGroup[type].push({
            $: {
                Include: include
            }
        });
    }
    checkCurrentItemGroup() {
        if (this.currentItemGroup && this.document.Project.ItemGroup.indexOf(this.currentItemGroup) >= 0)
            return;
        if (this.document.Project.ItemGroup.length > 0) {
            this.currentItemGroup = this.document.Project.ItemGroup[this.document.Project.ItemGroup.length - 1];
        }
        else {
            this.currentItemGroup = {};
            this.document.Project.ItemGroup.push(this.currentItemGroup);
        }
    }
    getRelativePath(fullpath) {
        let relativePath = fullpath.replace(path.dirname(this.fullPath), '');
        if (relativePath.startsWith(path.sep))
            relativePath = relativePath.substring(1);
        return relativePath;
    }
    getFoldersFromTree(items) {
        return __awaiter(this, void 0, void 0, function* () {
            if (!Array.isArray(items))
                return [];
            let result = [];
            for (let i = 0; i < items.length; i++) {
                let item = items[i];
                let stat = yield fs.lstat(item.fullpath);
                if (stat.isDirectory()) {
                    result.push(item.fullpath);
                    let subItems = yield this.getFoldersFromTree(item.children);
                    subItems.forEach(si => result.push(si));
                }
            }
            return result;
        });
    }
}
exports.StandardProject = StandardProject;
//# sourceMappingURL=StandardProject.js.map