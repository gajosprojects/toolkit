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
    setArguments() {
        return __awaiter(this, void 0, void 0, function* () {
            let items = yield this.getItems();
            if (items.length <= 0) {
                return true;
            }
            if (items.length == 1) {
                this.value = this.getValue(items[0]);
                return true;
            }
            let value = yield vscode.window.showQuickPick(items, { placeHolder: this.placeholder });
            if (value !== null && value !== undefined) {
                this.value = this.getValue(value);
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
}
exports.InputOptionsCommandParameter = InputOptionsCommandParameter;
//# sourceMappingURL=InputOptionsCommandParameter.js.map