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
const vscode = require("vscode");
const CommandBase_1 = require("./base/CommandBase");
class OpenFileCommand extends CommandBase_1.CommandBase {
    constructor() {
        super('Open file');
    }
    shouldRun(item) {
        if (item && item.path)
            return true; // return item && item.path; // raises an error
        return false;
    }
    runCommand(item, args) {
        return __awaiter(this, void 0, void 0, function* () {
            let options = {
                preview: !this.checkDoubleClick(item),
                preserveFocus: true
            };
            let filepath = item.path;
            let document = yield vscode.workspace.openTextDocument(filepath);
            vscode.window.showTextDocument(document, options);
        });
    }
    checkDoubleClick(item) {
        let result = false;
        if (this.lastOpenedFile && this.lastOpenedDate) {
            let isTheSameFile = this.lastOpenedFile == item.path;
            let dateDiff = (new Date() - this.lastOpenedDate);
            result = isTheSameFile && dateDiff < 500;
        }
        this.lastOpenedFile = item.path;
        this.lastOpenedDate = new Date();
        return result;
    }
}
exports.OpenFileCommand = OpenFileCommand;
//# sourceMappingURL=OpenFileCommand.js.map