"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const CliCommandBase_1 = require("./base/CliCommandBase");
const StaticCommandParameter_1 = require("./parameters/StaticCommandParameter");
class CleanCommand extends CliCommandBase_1.CliCommandBase {
    constructor(provider) {
        super('Clean', provider, 'dotnet');
    }
    shouldRun(item) {
        this.parameters = [
            new StaticCommandParameter_1.StaticCommandParameter('clean'),
            new StaticCommandParameter_1.StaticCommandParameter(item.path)
        ];
        return true;
    }
}
exports.CleanCommand = CleanCommand;
//# sourceMappingURL=CleanCommand.js.map