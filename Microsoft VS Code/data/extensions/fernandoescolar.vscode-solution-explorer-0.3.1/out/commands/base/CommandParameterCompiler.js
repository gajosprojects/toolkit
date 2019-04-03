"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
class CommandParameterCompiler {
    constructor(title, parameters) {
        this.title = title;
        this.parameters = parameters;
    }
    get steps() {
        let numberOfSteps = 0;
        this.parameters.forEach(p => { numberOfSteps += p.shouldAskUser ? 1 : 0; });
        return numberOfSteps;
    }
    get step() {
        let virtualStep = 0;
        this.parameters.forEach((p, index) => { virtualStep += index <= this.currentStep && p.shouldAskUser ? 1 : 0; });
        return virtualStep;
    }
    get results() {
        this.refreshResult();
        return this.result;
    }
    get currentCommandParameter() {
        return this.parameters[this.currentStep];
    }
    next() {
        if (!this.resolver)
            return;
        if (this.currentStep + 1 < this.parameters.length) {
            this.currentStep++;
            this.currentCommandParameter.setArguments(this);
            if (!this.currentCommandParameter.shouldAskUser) {
                this.next();
            }
        }
        else {
            this.onCompleted();
        }
    }
    prev() {
        if (!this.resolver)
            return;
        if (this.currentStep - 1 <= 0) {
            this.currentStep--;
            this.currentCommandParameter.setArguments(this);
            if (!this.currentCommandParameter.shouldAskUser) {
                this.prev();
            }
        }
    }
    cancel() {
        this.onCancel();
    }
    compile() {
        return new Promise(resolve => {
            this.resolver = resolve;
            this.currentStep = -1;
            this.next();
        });
    }
    onCompleted() {
        if (this.resolver) {
            this.refreshResult();
            this.resolver(this.result);
            this.resolver = null;
        }
    }
    onCancel() {
        if (this.resolver) {
            this.resolver(null);
            this.resolver = null;
        }
    }
    refreshResult() {
        this.result = [];
        this.parameters.forEach(p => { this.result = this.result.concat(p.getArguments()); });
    }
}
exports.CommandParameterCompiler = CommandParameterCompiler;
//# sourceMappingURL=CommandParameterCompiler.js.map