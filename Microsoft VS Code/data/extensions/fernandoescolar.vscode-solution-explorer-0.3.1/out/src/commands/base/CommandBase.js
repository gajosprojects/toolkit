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
class CommandBase {
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
            this.args = [];
            for (let i = 0; i < this.parameters.length; i++) {
                let parameter = this.parameters[i];
                let success = yield parameter.setArguments();
                if (!success)
                    return;
                this.args = this.args.concat(parameter.getArguments());
            }
            return this.args;
        });
    }
    shouldRun(item) {
        return true;
    }
}
exports.CommandBase = CommandBase;
//# sourceMappingURL=CommandBase.js.map