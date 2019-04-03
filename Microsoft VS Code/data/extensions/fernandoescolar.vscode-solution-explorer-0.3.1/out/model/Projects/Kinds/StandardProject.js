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
function commonPrefix(x, y) {
    if (x > y) {
        [x, y] = [y, x];
    }
    let i = 0;
    for (; i < x.length; i++) {
        if (x[i] != y[i]) {
            break;
        }
    }
    return x.substr(0, i);
}
class StandardProject extends FileSystemBasedProject_1.FileSystemBasedProject {
    constructor(projectInSolution, document, type) {
        super(projectInSolution, type ? type : 'standard');
        this.loaded = false;
        this.loadedPackages = false;
        this.references = [];
        this.packages = [];
        this.document = null;
        this.folders = [];
        this.filesTree = null;
        this.currentItemGroup = null;
        this.shouldReload = true;
        this.includePrefix = null;
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
                    this.addFileDependents(item, projectFile);
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
            if (folderRelativePath != '.' && this.countInNodes(folderRelativePath, true) == 0) {
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
            this.removeInNodes(folderRelativePath, true);
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
            let directories = yield this.getFoldersFromTree(this.filesTree);
            directories.sort((a, b) => {
                let x = a.toLowerCase();
                let y = b.toLowerCase();
                return x < y ? -1 : x > y ? 1 : 0;
            });
            let result = ['.' + path.sep];
            directories.forEach(dirPath => result.push(this.getRelativePath(dirPath)));
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
    addFileDependents(item, projectFile) {
        if (this.dependents[item.virtualpath]) {
            projectFile.hasDependents = true;
            this.dependents[item.virtualpath].forEach(d => {
                let dependentFullPath = path.join(path.dirname(this.fullPath), d);
                projectFile.dependents.push(new ProjectFile_1.ProjectFile(dependentFullPath));
            });
        }
    }
    checkProjectLoaded() {
        return __awaiter(this, void 0, void 0, function* () {
            if (!this.loaded) {
                let content = yield fs.readFile(this.fullPath, 'utf8');
                yield this.parseProject(content);
                this.loaded = true;
            }
            if (!this.loadedPackages && this.hasReferences) {
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
        let project = StandardProject.getProjectElement(this.document);
        let nodeNames = this.getXmlNodeNames();
        let files = [];
        let folders = [];
        let dependents = {};
        let addFile = ref => {
            let isDependent = false;
            if (ref.elements) {
                ref.elements.forEach(e => {
                    if (e.name === 'DependentUpon') {
                        isDependent = true;
                        let parent = e.elements[0].text;
                        if (!dependents[parent])
                            dependents[parent] = [];
                        dependents[parent].push(this.cleanIncludePath(ref.attributes.Include).replace(/\\/g, path.sep));
                    }
                });
            }
            if (!isDependent) {
                files.push(this.cleanIncludePath(ref.attributes.Include).replace(/\\/g, path.sep));
            }
        };
        if (!project)
            project = { elements: [] };
        if (!project.elements || !Array.isArray(project.elements))
            project.elements = [];
        project.elements.forEach(element => {
            if (element.name === 'ItemGroup') {
                if (element.elements) {
                    element.elements.forEach(e => {
                        if (e.name === 'Reference') {
                            let include = this.cleanIncludePath(e.attributes.Include);
                            this.references.push(new ProjectReference_1.ProjectReference(include, include));
                            return false;
                        }
                        if (e.name === 'Folder') {
                            addFile(e);
                            let folder = this.cleanIncludePath(e.attributes.Include).replace(/\\/g, path.sep);
                            if (folder.endsWith(path.sep))
                                folder = folder.substring(0, folder.length - 1);
                            folders.push(folder);
                            return false;
                        }
                        nodeNames.forEach(nodeName => {
                            if (e.name === nodeName) {
                                addFile(e);
                            }
                        });
                    });
                }
            }
        });
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
            // Get absolute path of file
            filepath = filepath.replace(/\\/g, path.sep);
            filepath = path.resolve(path.dirname(this.fullPath), filepath);
            // Trim the leading path that the file and project file share
            let currentFullPath = commonPrefix(path.dirname(this.fullPath), filepath);
            let virtualPath = path.relative(currentFullPath, filepath);
            let pathParts = virtualPath.split(path.sep);
            let currentLevel = tree;
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
                        virtualpath: virtualPath,
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
        if (this.includePrefix)
            pattern = this.includePrefix + pattern;
        let counter = 0;
        let findPattern = ref => {
            if (ref.attributes.Include.startsWith(pattern)) {
                counter++;
            }
        };
        let nodeNames = this.getXmlNodeNames();
        let project = StandardProject.getProjectElement(this.document);
        project.elements.forEach(element => {
            if (element.name === 'ItemGroup') {
                element.elements.forEach(e => {
                    nodeNames.forEach(nodeName => {
                        if (e.name === nodeName) {
                            findPattern(e);
                        }
                    });
                });
            }
        });
        return counter;
    }
    renameInNodes(pattern, newPattern, isFolder = false) {
        pattern = pattern.replace(/\//g, '\\') + (isFolder ? '\\' : '');
        newPattern = newPattern.replace(/\//g, '\\') + (isFolder ? '\\' : '');
        if (this.includePrefix) {
            pattern = this.includePrefix + pattern;
            newPattern = this.includePrefix + newPattern;
        }
        let findPattern = ref => {
            this.replaceDependsUponNode(ref, pattern, newPattern);
            if (ref.attributes.Include.startsWith(pattern)) {
                ref.attributes.Include = ref.attributes.Include.replace(pattern, newPattern);
            }
        };
        let nodeNames = this.getXmlNodeNames();
        let project = StandardProject.getProjectElement(this.document);
        project.elements.forEach(element => {
            if (element.name === 'ItemGroup') {
                element.elements.forEach(e => {
                    nodeNames.forEach(nodeName => {
                        if (e.name === nodeName) {
                            findPattern(e);
                        }
                    });
                });
            }
        });
    }
    replaceDependsUponNode(ref, pattern, newPattern) {
        if (!ref.elements)
            return;
        ref.elements.forEach(e => {
            if (e.name === 'DependentUpon' && e.elements[0].text.startsWith(pattern)) {
                e.elements[0].text = e.elements[0].text.replace(pattern, newPattern);
            }
        });
    }
    removeInNodes(pattern, isFolder = false, types = null) {
        pattern = pattern.replace(/\//g, '\\') + (isFolder ? '\\' : '');
        if (this.includePrefix)
            pattern = this.includePrefix + pattern;
        if (!types)
            types = this.getXmlNodeNames();
        let project = StandardProject.getProjectElement(this.document);
        project.elements.forEach((element, elementIndex) => {
            if (element.name === 'ItemGroup') {
                let toDelete = [];
                element.elements.forEach(e => {
                    types.forEach(nodeName => {
                        if (e.name === nodeName) {
                            this.deleteDependsUponNode(e, pattern);
                            if (e.attributes.Include.startsWith(pattern)) {
                                toDelete.push(e);
                            }
                        }
                    });
                });
                toDelete.forEach(e => {
                    element.elements.splice(element.elements.indexOf(e), 1);
                });
                if (element.elements.length === 0) {
                    project.elements.splice(elementIndex, 1);
                }
            }
        });
    }
    deleteDependsUponNode(node, pattern) {
        if (!node.elements)
            return;
        node.elements.forEach((e, eIndex) => {
            if (e.name === 'DependentUpon' && e.elements[0].text.startsWith(pattern)) {
                node.elements.splice(eIndex, 1);
            }
        });
        if (node.elements.length === 0) {
            delete node.elements;
        }
    }
    currentItemGroupAdd(type, include, isFolder = false) {
        this.checkCurrentItemGroup();
        include = include.replace(/\//g, '\\') + (isFolder ? '\\' : '');
        if (this.includePrefix)
            include = this.includePrefix + include;
        this.currentItemGroup.elements.push({
            type: 'element',
            name: type,
            attributes: {
                Include: include
            }
        });
    }
    checkCurrentItemGroup() {
        let project = StandardProject.getProjectElement(this.document);
        let current;
        let lastElement;
        project.elements.forEach(element => {
            if (element.name === 'ItemGroup') {
                lastElement = element;
            }
            if (this.currentItemGroup && element === this.currentItemGroup) {
                current = element;
            }
        });
        if (!current && !lastElement) {
            current = {
                type: 'element',
                name: 'ItemGroup',
                elements: []
            };
            project.elements.push(current);
        }
        else if (!current) {
            current = lastElement;
        }
        this.currentItemGroup = current;
    }
    getRelativePath(fullpath) {
        return path.relative(path.dirname(this.fullPath), fullpath);
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
    cleanIncludePath(include) {
        if (this.includePrefix)
            return include.replace(this.includePrefix, "");
        return include;
    }
    getXmlNodeNames() {
        let result = [
            "Compile",
            "ClCompile",
            "ClInclude",
            "Content",
            "TypeScriptCompile",
            "EmbeddedResource",
            "None",
            "Folder"
        ];
        let itemTypes = SolutionExplorerConfiguration.getItemTypes();
        Object.keys(itemTypes).forEach(key => {
            if (result.indexOf(itemTypes[key]) < 0) {
                result.push(itemTypes[key]);
            }
        });
        return result;
    }
}
exports.StandardProject = StandardProject;
//# sourceMappingURL=StandardProject.js.map