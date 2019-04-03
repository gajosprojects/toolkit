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
const CommandBase_1 = require("./base/CommandBase");
class CollapseAllCommand extends CommandBase_1.CommandBase {
    constructor(provider) {
        super('Collapse All');
        this.provider = provider;
    }
    shouldRun(item) {
        return true;
    }
    runCommand(item, args) {
        return __awaiter(this, void 0, void 0, function* () {
            let items = yield this.provider.getChildren();
            if (items && items.length > 0)
                items.forEach(i => i.collapse());
        });
    }
}
exports.CollapseAllCommand = CollapseAllCommand;
//# sourceMappingURL=CollapseAllCommand.js.map