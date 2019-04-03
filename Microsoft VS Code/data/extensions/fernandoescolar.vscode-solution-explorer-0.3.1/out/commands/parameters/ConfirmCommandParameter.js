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
class ConfirmCommandParameter {
    constructor(message) {
        this.message = message;
    }
    get shouldAskUser() { return true; }
    setArguments(state) {
        return __awaiter(this, void 0, void 0, function* () {
            let option = yield vscode.window.showWarningMessage(this.message, 'Yes', 'No');
            if (option !== null && option !== undefined && option == 'Yes') {
                state.next();
            }
            state.cancel();
        });
    }
    getArguments() {
        return [];
    }
}
exports.ConfirmCommandParameter = ConfirmCommandParameter;
//# sourceMappingURL=ConfirmCommandParameter.js.map