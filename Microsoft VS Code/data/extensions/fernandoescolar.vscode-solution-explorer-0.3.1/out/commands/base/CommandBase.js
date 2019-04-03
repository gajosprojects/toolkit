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
const CommandParameterCompiler_1 = require("./CommandParameterCompiler");
class CommandBase {
    constructor(title) {
        this.title = title;
    }
    get args() {
        return this.currentState ? this.currentState.results : [];
    }
    run(item) {
        return __awaiter(this, void 0, void 0, function* () {
            if (!this.shouldRun(item))
                return;
            let args = yield this.getArguments();
            if (!args)
                return;
            yield this.runCommand(item, args);
        });
    }
    getArguments() {
        return __awaiter(this, void 0, void 0, function* () {
            if (!this.parameters)
                return [];
            this.currentState = new CommandParameterCompiler_1.CommandParameterCompiler(this.title, this.parameters);
            const args = yield this.currentState.compile();
            return args;
        });
    }
    shouldRun(item) {
        return true;
    }
}
exports.CommandBase = CommandBase;
//# sourceMappingURL=CommandBase.js.map