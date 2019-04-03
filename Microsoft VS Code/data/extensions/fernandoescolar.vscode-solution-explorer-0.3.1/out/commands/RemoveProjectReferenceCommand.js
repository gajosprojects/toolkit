"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const CliCommandBase_1 = require("./base/CliCommandBase");
const StaticCommandParameter_1 = require("./parameters/StaticCommandParameter");
class RemoveProjectReferenceCommand extends CliCommandBase_1.CliCommandBase {
    constructor(provider) {
        super('Remove project reference', provider, 'dotnet');
    }
    shouldRun(item) {
        this.parameters = [
            new StaticCommandParameter_1.StaticCommandParameter('remove'),
            new StaticCommandParameter_1.StaticCommandParameter(item.project.fullPath),
            new StaticCommandParameter_1.StaticCommandParameter('reference'),
            new StaticCommandParameter_1.StaticCommandParameter(item.path)
        ];
        return true;
    }
}
exports.RemoveProjectReferenceCommand = RemoveProjectReferenceCommand;
//# sourceMappingURL=RemoveProjectReferenceCommand.js.map