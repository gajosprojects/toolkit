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
    constructor(description, placeholder, option, initialValue) {
        this.description = description;
        this.placeholder = placeholder;
        this.option = option;
        this.initialValue = initialValue;
    }
    get shouldAskUser() { return true; }
    setArguments(state) {
        return __awaiter(this, void 0, void 0, function* () {
            const validate = value => {
                if (value !== null && value !== undefined) {
                    this.value = value;
                    return true;
                }
                return false;
            };
            let accepted = false;
            let input = vscode.window.createInputBox();
            input.title = state.title;
            input.step = state.step;
            input.totalSteps = state.steps;
            input.prompt = this.description;
            input.value = yield this.getInitialValue();
            input.placeholder = input.value || this.placeholder;
            input.onDidTriggerButton(item => {
                if (item === vscode.QuickInputButtons.Back) {
                    validate(input.value);
                    state.prev();
                }
                else {
                    if (validate(input.value)) {
                        accepted = true;
                        state.next();
                    }
                    else {
                        state.cancel();
                    }
                }
            });
            input.onDidAccept(() => {
                if (validate(input.value)) {
                    accepted = true;
                    state.next();
                }
                else {
                    state.cancel();
                }
            }),
                input.onDidHide(() => {
                    if (!accepted) {
                        state.cancel();
                    }
                });
            input.show();
        });
    }
    getArguments() {
        if (this.option)
            return [this.option, this.value];
        return [this.value];
    }
    getInitialValue() {
        if (typeof (this.initialValue) == 'function') {
            return this.initialValue();
        }
        return Promise.resolve(this.initialValue);
    }
}
exports.InputTextCommandParameter = InputTextCommandParameter;
//# sourceMappingURL=InputTextCommandParameter.js.map