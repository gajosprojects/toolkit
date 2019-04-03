"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const CliCommandBase_1 = require("./base/CliCommandBase");
const StaticCommandParameter_1 = require("./parameters/StaticCommandParameter");
class RestoreCommand extends CliCommandBase_1.CliCommandBase {
    constructor(provider) {
        super('Restore', provider, 'dotnet');
    }
    shouldRun(item) {
        this.parameters = [
            new StaticCommandParameter_1.StaticCommandParameter('restore'),
            new StaticCommandParameter_1.StaticCommandParameter(item.path)
        ];
        return true;
    }
}
exports.RestoreCommand = RestoreCommand;
//# sourceMappingURL=RestoreCommand.js.map