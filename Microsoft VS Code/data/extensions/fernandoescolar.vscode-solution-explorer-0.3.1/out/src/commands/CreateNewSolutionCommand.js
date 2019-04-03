"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const CliCommandBase_1 = require("./base/CliCommandBase");
const StaticCommandParameter_1 = require("./parameters/StaticCommandParameter");
const InputTextCommandParameter_1 = require("./parameters/InputTextCommandParameter");
class CreateNewSolutionCommand extends CliCommandBase_1.CliCommandBase {
    constructor(provider) {
        super(provider, 'dotnet');
    }
    shouldRun(item) {
        this.parameters = [
            new StaticCommandParameter_1.StaticCommandParameter('new'),
            new StaticCommandParameter_1.StaticCommandParameter('sln'),
            new InputTextCommandParameter_1.InputTextCommandParameter('Solution name...', '-n'),
            new StaticCommandParameter_1.StaticCommandParameter(item.path, '-o'),
        ];
        return true;
    }
}
exports.CreateNewSolutionCommand = CreateNewSolutionCommand;
//# sourceMappingURL=CreateNewSolutionCommand.js.map