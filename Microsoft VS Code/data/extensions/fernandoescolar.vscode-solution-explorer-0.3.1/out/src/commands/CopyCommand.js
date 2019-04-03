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
const clipboardy = require("clipboardy");
const CommandBase_1 = require("./base/CommandBase");
class CopyCommand extends CommandBase_1.CommandBase {
    constructor(provider) {
        super();
        this.provider = provider;
    }
    shouldRun(item) {
        if (item && item.path)
            return true;
        return false;
    }
    runCommand(item, args) {
        return __awaiter(this, void 0, void 0, function* () {
            yield clipboardy.write(item.path);
        });
    }
}
exports.CopyCommand = CopyCommand;
//# sourceMappingURL=CopyCommand.js.map