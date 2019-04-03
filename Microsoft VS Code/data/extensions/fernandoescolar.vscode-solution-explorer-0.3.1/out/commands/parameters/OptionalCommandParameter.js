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
class OptionalCommandParameter {
    constructor(message, commandParameter) {
        this.message = message;
        this.commandParameter = commandParameter;
        this.executed = false;
    }
    get shouldAskUser() { return true; }
    setArguments(state) {
        return __awaiter(this, void 0, void 0, function* () {
            this.executed = false;
            const option = yield this.showConfirmMessage(state);
            if (option === 'Yes') {
                this.executed = true;
                yield this.commandParameter.setArguments(state);
                return;
            }
            state.next();
        });
    }
    getArguments() {
        if (this.executed) {
            return this.commandParameter.getArguments();
        }
        else {
            return [];
        }
    }
    showConfirmMessage(state) {
        return new Promise(resolve => {
            let accepted = false;
            const input = vscode.window.createQuickPick();
            input.title = state.title;
            input.step = state.step;
            input.totalSteps = state.steps;
            input.placeholder = this.message;
            input.items = [{ label: 'Yes' }, { label: 'No' }];
            input.onDidAccept(() => {
                accepted = true;
                resolve(input.activeItems[0].label);
            });
            input.onDidHide(() => {
                if (!accepted) {
                    state.cancel();
                }
            });
            input.show();
        });
    }
}
exports.OptionalCommandParameter = OptionalCommandParameter;
//# sourceMappingURL=OptionalCommandParameter.js.map