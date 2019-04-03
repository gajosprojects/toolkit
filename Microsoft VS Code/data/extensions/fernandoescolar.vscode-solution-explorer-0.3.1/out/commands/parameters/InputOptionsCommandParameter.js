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
class InputOptionsCommandParameter {
    constructor(placeholder, items, option) {
        this.placeholder = placeholder;
        this.items = items;
        this.option = option;
    }
    get shouldAskUser() { return true; }
    setArguments(state) {
        return __awaiter(this, void 0, void 0, function* () {
            const validate = value => {
                if (value !== null && value !== undefined) {
                    this.value = this.getValue(value);
                    return true;
                }
                return false;
            };
            let items = yield this.getItems();
            if (items.length <= 0) {
                state.next();
                return;
            }
            if (items.length == 1) {
                this.value = this.getValue(items[0]);
                state.next();
                return;
            }
            items.sort((a, b) => {
                let x = a.toLowerCase();
                let y = b.toLowerCase();
                return x < y ? -1 : x > y ? 1 : 0;
            });
            let accepted = false;
            const input = vscode.window.createQuickPick();
            input.title = state.title;
            input.step = state.step;
            input.totalSteps = state.steps;
            input.placeholder = this.placeholder;
            input.items = this.createQuickPickItems(items);
            input.onDidTriggerButton(item => {
                if (item === vscode.QuickInputButtons.Back) {
                    state.prev();
                }
                else {
                    if (validate(input.activeItems[0].label)) {
                        accepted = true;
                        state.next();
                    }
                    else {
                        state.cancel();
                    }
                }
            });
            input.onDidAccept(() => {
                if (validate(input.activeItems[0].label)) {
                    accepted = true;
                    state.next();
                }
                else {
                    state.cancel();
                }
            });
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
    getItems() {
        return __awaiter(this, void 0, void 0, function* () {
            if (typeof (this.items) == 'function') {
                this._items = yield this.items();
            }
            else {
                this._items = this.items;
            }
            return this.parseItems(this._items);
        });
    }
    parseItems(items) {
        if (Array.isArray(items))
            return items;
        return Object.keys(items);
    }
    getValue(value) {
        if (Array.isArray(this._items))
            return value;
        return this._items[value];
    }
    createQuickPickItems(strings) {
        return strings.map(s => { return { label: s }; });
    }
}
exports.InputOptionsCommandParameter = InputOptionsCommandParameter;
//# sourceMappingURL=InputOptionsCommandParameter.js.map