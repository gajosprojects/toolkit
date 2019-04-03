"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const CliCommandBase_1 = require("./base/CliCommandBase");
const StaticCommandParameter_1 = require("./parameters/StaticCommandParameter");
class PublishCommand extends CliCommandBase_1.CliCommandBase {
    constructor(provider) {
        super('Publish', provider, 'dotnet');
    }
    shouldRun(item) {
        this.parameters = [
            new StaticCommandParameter_1.StaticCommandParameter('publish'),
            new StaticCommandParameter_1.StaticCommandParameter(item.path)
        ];
        return true;
    }
}
exports.PublishCommand = PublishCommand;
//# sourceMappingURL=PublishCommand.js.map