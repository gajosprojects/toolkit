"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const CliCommandBase_1 = require("./base/CliCommandBase");
const StaticCommandParameter_1 = require("./parameters/StaticCommandParameter");
class RemoveProjectCommand extends CliCommandBase_1.CliCommandBase {
    constructor(provider) {
        super(provider, 'dotnet');
    }
    shouldRun(item) {
        this.parameters = [
            new StaticCommandParameter_1.StaticCommandParameter('sln'),
            new StaticCommandParameter_1.StaticCommandParameter(item.solution.FullPath),
            new StaticCommandParameter_1.StaticCommandParameter('remove'),
            new StaticCommandParameter_1.StaticCommandParameter(item.path),
        ];
        return true;
    }
}
exports.RemoveProjectCommand = RemoveProjectCommand;
//# sourceMappingURL=RemoveProjectCommand.js.map