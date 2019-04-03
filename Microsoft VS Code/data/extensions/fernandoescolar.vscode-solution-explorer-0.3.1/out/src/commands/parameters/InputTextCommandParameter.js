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
class InputTextCommandParameter {
    constructor(placeholder, option) {
        this.placeholder = placeholder;
        this.option = option;
    }
    setArguments() {
        return __awaiter(this, void 0, void 0, function* () {
            let value = yield vscode.window.showInputBox({ placeHolder: this.placeholder });
            if (value !== null && value !== undefined) {
                this.value = value;
                return true;
            }
            return false;
        });
    }
    getArguments() {
        if (this.option)
            return [this.option, this.value];
        return [this.value];
    }
}
exports.InputTextCommandParameter = InputTextCommandParameter;
//# sourceMappingURL=InputTextCommandParameter.js.map