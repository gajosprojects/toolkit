"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const CliCommandBase_1 = require("./base/CliCommandBase");
const StaticCommandParameter_1 = require("./parameters/StaticCommandParameter");
class RunCommand extends CliCommandBase_1.CliCommandBase {
    constructor(provider) {
        super('Run', provider, 'dotnet');
    }
    shouldRun(item) {
        this.parameters = [
            new StaticCommandParameter_1.StaticCommandParameter('run'),
            new StaticCommandParameter_1.StaticCommandParameter(item.path, '--project')
        ];
        return true;
    }
}
exports.RunCommand = RunCommand;
//# sourceMappingURL=RunCommand.js.map