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
const fs = require("fs");
const spath = require("path");
const Promisify_1 = require("./Promisify");
// returns value in error parameter
// export function exists(path: string) { return Promisify<boolean>(fs.exists, arguments); }
function exists(path) {
    return new Promise((resolve, reject) => fs.lstat(path, err => !err ? resolve(true) : err.code === 'ENOENT' ? resolve(false) : reject(err)));
}
exports.exists = exists;
function lstat(path) { return Promisify_1.Promisify(fs.lstat, arguments); }
exports.lstat = lstat;
function mkdir(path, mode) { return Promisify_1.Promisify(fs.mkdir, arguments); }
exports.mkdir = mkdir;
function readdir(path) { return Promisify_1.Promisify(fs.readdir, arguments); }
exports.readdir = readdir;
function readFile(file, options) { return Promisify_1.Promisify(fs.readFile, arguments); }
exports.readFile = readFile;
function rename(oldPath, newPath) { return Promisify_1.Promisify(fs.rename, arguments); }
exports.rename = rename;
function rmdir(path) { return Promisify_1.Promisify(fs.rmdir, arguments); }
exports.rmdir = rmdir;
function writeFile(file, data, options) { return Promisify_1.Promisify(fs.writeFile, arguments); }
exports.writeFile = writeFile;
function unlink(path) { return Promisify_1.Promisify(fs.unlink, arguments); }
exports.unlink = unlink;
function rmdir_recursive(dir) {
    return __awaiter(this, void 0, void 0, function* () {
        var list = yield readdir(dir);
        for (var i = 0; i < list.length; i++) {
            var filename = spath.join(dir, list[i]);
            var stat = yield lstat(filename);
            if (filename == "." || filename == "..") {
                // pass these files
            }
            else if (stat.isDirectory()) {
                // rmdir recursively
                yield rmdir_recursive(filename);
            }
            else {
                // rm fiilename
                yield unlink(filename);
            }
        }
        yield fs.rmdir(dir);
    });
}
exports.rmdir_recursive = rmdir_recursive;
;
//# sourceMappingURL=fs.js.map