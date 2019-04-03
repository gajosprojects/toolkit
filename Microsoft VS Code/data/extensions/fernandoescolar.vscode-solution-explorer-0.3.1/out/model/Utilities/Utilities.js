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
const fs = require("../../async/fs");
const DirectorySearchResult_1 = require("./DirectorySearchResult");
function searchFilesInDir(startPath, extension) {
    return __awaiter(this, void 0, void 0, function* () {
        if (!(yield fs.exists(startPath))) {
            return [];
        }
        let result = [];
        let files = yield fs.readdir(startPath);
        for (let i = 0; i < files.length; i++) {
            let filename = path.join(startPath, files[i]);
            let stat = yield fs.lstat(filename);
            if (filename.endsWith(extension)) {
                result.push(filename);
            }
        }
        return result;
    });
}
exports.searchFilesInDir = searchFilesInDir;
function getDirectoryItems(dirPath) {
    return __awaiter(this, void 0, void 0, function* () {
        if (!(yield fs.exists(dirPath))) {
            throw "Directory doesn't exist";
        }
        let directories = [], files = [];
        let items = yield fs.readdir(dirPath);
        for (let i = 0; i < items.length; i++) {
            let filename = path.join(dirPath, items[i]);
            let stat = yield fs.lstat(filename);
            if (stat.isDirectory()) {
                directories.push(filename);
            }
            else {
                files.push(filename);
            }
        }
        directories.sort((a, b) => {
            let x = a.toLowerCase();
            let y = b.toLowerCase();
            return x < y ? -1 : x > y ? 1 : 0;
        });
        files.sort((a, b) => {
            let x = a.toLowerCase();
            let y = b.toLowerCase();
            return x < y ? -1 : x > y ? 1 : 0;
        });
        return new DirectorySearchResult_1.DirectorySearchResult(directories, files);
    });
}
exports.getDirectoryItems = getDirectoryItems;
function getAllDirectoriesRecursive(dirPath, ignore) {
    return __awaiter(this, void 0, void 0, function* () {
        if (!(yield fs.exists(dirPath))) {
            throw "Directory doesn't exist";
        }
        let result = [];
        let items = yield fs.readdir(dirPath);
        for (let i = 0; i < items.length; i++) {
            if (ignore && ignore.indexOf(items[i].toLocaleLowerCase()) >= 0)
                continue;
            let filename = path.join(dirPath, items[i]);
            let stat = yield fs.lstat(filename);
            if (stat.isDirectory()) {
                result.push(filename);
                let subDirs = yield getAllDirectoriesRecursive(filename);
                subDirs.forEach(path => {
                    result.push(path);
                });
                ;
            }
        }
        result.sort((a, b) => {
            let x = a.toLowerCase();
            let y = b.toLowerCase();
            return x < y ? -1 : x > y ? 1 : 0;
        });
        return result;
    });
}
exports.getAllDirectoriesRecursive = getAllDirectoriesRecursive;
function createCopyName(filepath) {
    return __awaiter(this, void 0, void 0, function* () {
        let counter = 1;
        let ext = path.extname(filepath);
        let name = path.basename(filepath, ext);
        let folder = path.dirname(filepath);
        while (yield fs.exists(filepath)) {
            filepath = path.join(folder, name + '.' + counter + ext);
            counter++;
        }
        return filepath;
    });
}
exports.createCopyName = createCopyName;
//# sourceMappingURL=Utilities.js.map