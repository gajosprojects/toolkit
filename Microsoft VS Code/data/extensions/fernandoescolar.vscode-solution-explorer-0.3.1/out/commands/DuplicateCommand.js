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
const fs = require("../async/fs");
const Utilities = require("../model/Utilities");
const CommandBase_1 = require("./base/CommandBase");
class DuplicateCommand extends CommandBase_1.CommandBase {
    constructor(provider) {
        super('Duplicate');
        this.provider = provider;
    }
    shouldRun(item) {
        if (item && item.path)
            return true;
        return false;
    }
    runCommand(item, args) {
        return __awaiter(this, void 0, void 0, function* () {
            try {
                let filepath = yield Utilities.createCopyName(item.path);
                let filename = path.basename(filepath);
                let folder = path.dirname(filepath);
                let content = yield fs.readFile(item.path, "utf8");
                filepath = yield item.project.createFile(folder, filename, content);
                this.provider.logger.log("File duplicated: " + filepath);
            }
            catch (ex) {
                this.provider.logger.error('Can not duplicate file: ' + ex);
            }
        });
    }
}
exports.DuplicateCommand = DuplicateCommand;
//# sourceMappingURL=DuplicateCommand.js.map