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
const fs = require("../async/fs");
const path = require("path");
const clipboardy = require("clipboardy");
const Utilities = require("../model/Utilities");
const tree_1 = require("../tree");
const CommandBase_1 = require("./base/CommandBase");
class PasteCommand extends CommandBase_1.CommandBase {
    constructor(provider) {
        super('Paste');
        this.provider = provider;
    }
    shouldRun(item) {
        if (item && item.path)
            return true;
        return false;
    }
    runCommand(item, args) {
        return __awaiter(this, void 0, void 0, function* () {
            let data = yield clipboardy.read();
            if (!data)
                return;
            if (!(yield fs.exists(data)))
                return;
            let targetpath = item.path;
            if (!item.contextValue.startsWith(tree_1.ContextValues.ProjectFolder)) {
                targetpath = path.dirname(targetpath);
            }
            let stat = yield fs.lstat(data);
            if (stat.isDirectory()) {
                this.copyDirectory(item, data, targetpath);
            }
            else {
                this.copyFile(item, data, targetpath);
            }
        });
    }
    copyDirectory(item, sourcepath, targetpath) {
        return __awaiter(this, void 0, void 0, function* () {
            let items = yield this.getFilesToCopyFromDirectory(sourcepath, targetpath);
            let keys = Object.keys(items).sort((a, b) => a.length > b.length ? 1 : -1);
            for (let i = 0; i < keys.length; i++) {
                let key = keys[i];
                let stat = yield fs.lstat(key);
                if (stat.isDirectory()) {
                    yield fs.mkdir(items[key]);
                }
                else {
                    this.copyFile(item, key, path.dirname(items[key]));
                }
            }
        });
    }
    copyFile(item, sourcepath, targetpath) {
        return __awaiter(this, void 0, void 0, function* () {
            try {
                let filename = path.basename(sourcepath);
                let filepath = path.join(targetpath, filename);
                filepath = yield Utilities.createCopyName(filepath);
                filename = path.basename(filepath);
                let content = yield fs.readFile(sourcepath, "utf8");
                filepath = yield item.project.createFile(targetpath, filename, content);
                this.provider.logger.log("File copied: " + sourcepath + ' -> ' + filepath);
            }
            catch (ex) {
                this.provider.logger.error('Can not copy file: ' + ex);
            }
        });
    }
    getFilesToCopyFromDirectory(sourcepath, targetpath) {
        return __awaiter(this, void 0, void 0, function* () {
            let result = {};
            targetpath = path.join(targetpath, path.basename(sourcepath));
            targetpath = yield Utilities.createCopyName(targetpath);
            result[sourcepath] = targetpath;
            let items = yield fs.readdir(sourcepath);
            for (let i = 0; i < items.length; i++) {
                let filename = path.join(sourcepath, items[i]);
                let stat = yield fs.lstat(filename);
                if (stat.isDirectory()) {
                    result = Object.assign(yield this.getFilesToCopyFromDirectory(filename, targetpath), result);
                }
                else {
                    result[filename] = path.join(targetpath, items[i]);
                }
            }
            return result;
        });
    }
}
exports.PasteCommand = PasteCommand;
//# sourceMappingURL=PasteCommand.js.map