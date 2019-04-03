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
class OpenFileCommandParameter {
    constructor(options, option) {
        this.options = options;
        this.option = option;
    }
    get shouldAskUser() { return true; }
    setArguments(state) {
        return __awaiter(this, void 0, void 0, function* () {
            let uris = yield vscode.window.showOpenDialog(this.options);
            if (uris !== null && uris.length == 1) {
                this.value = uris[0].fsPath;
                state.next();
            }
            state.cancel();
        });
    }
    getArguments() {
        if (this.option)
            return [this.option, this.value];
        return [this.value];
    }
}
exports.OpenFileCommandParameter = OpenFileCommandParameter;
//# sourceMappingURL=OpenFileCommandParameter.js.map