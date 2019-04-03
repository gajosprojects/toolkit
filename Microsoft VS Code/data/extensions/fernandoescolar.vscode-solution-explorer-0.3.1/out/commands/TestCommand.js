"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const CliCommandBase_1 = require("./base/CliCommandBase");
const StaticCommandParameter_1 = require("./parameters/StaticCommandParameter");
class TestCommand extends CliCommandBase_1.CliCommandBase {
    constructor(provider) {
        super('Test', provider, 'dotnet');
    }
    shouldRun(item) {
        this.parameters = [
            new StaticCommandParameter_1.StaticCommandParameter('test'),
            new StaticCommandParameter_1.StaticCommandParameter(item.path)
        ];
        return true;
    }
}
exports.TestCommand = TestCommand;
//# sourceMappingURL=TestCommand.js.map