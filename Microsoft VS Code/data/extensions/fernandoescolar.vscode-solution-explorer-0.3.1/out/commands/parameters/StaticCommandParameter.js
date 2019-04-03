"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
class StaticCommandParameter {
    constructor(value, option) {
        this.value = value;
        this.option = option;
    }
    setArguments() {
        return Promise.resolve();
    }
    get shouldAskUser() { return false; }
    getArguments() {
        if (this.option)
            return [this.option, this.value];
        return [this.value];
    }
}
exports.StaticCommandParameter = StaticCommandParameter;
//# sourceMappingURL=StaticCommandParameter.js.map