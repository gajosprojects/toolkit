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
const Utilities = require("../../Utilities");
const Project_1 = require("../Project");
const ProjectFile_1 = require("../ProjectFile");
const ProjectFolder_1 = require("../ProjectFolder");
class FileSystemBasedProject extends Project_1.Project {
    constructor(projectInSolution, type) {
        super(projectInSolution, type);
    }
    getProjectFilesAndFolders(virtualPath) {
        return __awaiter(this, void 0, void 0, function* () {
            let folderPath = path.dirname(this.projectInSolution.fullPath);
            if (virtualPath)
                folderPath = path.join(folderPath, virtualPath);
            let result = yield Utilities.getDirectoryItems(folderPath);
            let files = [];
            let folders = [];
            result.files.forEach(filepath => files.push(new ProjectFile_1.ProjectFile(filepath)));
            result.directories.forEach(folderpath => folders.push(new ProjectFolder_1.ProjectFolder(folderpath)));
            return { files, folders };
        });
    }
    renameFile(filepath, name) {
        return this.renameItem(filepath, name);
    }
    deleteFile(filepath) {
        return __awaiter(this, void 0, void 0, function* () {
            if (yield fs.exists(filepath)) {
                yield fs.unlink(filepath);
            }
        });
    }
    createFile(folderpath, filename, content) {
        return __awaiter(this, void 0, void 0, function* () {
            let filepath = path.join(folderpath, filename);
            if (!(yield fs.exists(filepath))) {
                yield fs.writeFile(filepath, content || "");
            }
            return filepath;
        });
    }
    renameFolder(folderpath, name) {
        return this.renameItem(folderpath, name);
    }
    deleteFolder(folderpath) {
        return fs.rmdir_recursive(folderpath);
    }
    createFolder(folderpath) {
        return __awaiter(this, void 0, void 0, function* () {
            yield fs.mkdir(folderpath);
            return folderpath;
        });
    }
    getFolderList() {
        return __awaiter(this, void 0, void 0, function* () {
            let folderPath = path.dirname(this.projectInSolution.fullPath);
            let directories = yield Utilities.getAllDirectoriesRecursive(folderPath);
            let result = ['.' + path.sep];
            directories.forEach(dirPath => result.push('.' + dirPath.replace(folderPath, '')));
            return result;
        });
    }
    moveFile(filepath, newfolderPath) {
        return this.moveItem(filepath, newfolderPath);
    }
    moveFolder(folderpath, newfolderPath) {
        return this.moveItem(folderpath, newfolderPath);
    }
    moveItem(itemPath, newfolderPath) {
        return __awaiter(this, void 0, void 0, function* () {
            let folderPath = path.dirname(this.projectInSolution.fullPath);
            let fullFolderPath = path.join(folderPath, newfolderPath);
            let itemName = itemPath.split(path.sep).pop();
            let newItemPath = path.join(fullFolderPath, itemName);
            yield fs.rename(itemPath, newItemPath);
            return newItemPath;
        });
    }
    renameItem(itemPath, name) {
        return __awaiter(this, void 0, void 0, function* () {
            let folder = path.dirname(itemPath);
            let newItempath = path.join(folder, name);
            yield fs.rename(itemPath, newItempath);
            return newItempath;
        });
    }
}
exports.FileSystemBasedProject = FileSystemBasedProject;
//# sourceMappingURL=FileSystemBasedProject.js.map