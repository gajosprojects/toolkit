"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const CliCommandBase_1 = require("./base/CliCommandBase");
const StaticCommandParameter_1 = require("./parameters/StaticCommandParameter");
const InputTextCommandParameter_1 = require("./parameters/InputTextCommandParameter");
class AddPackageCommand extends CliCommandBase_1.CliCommandBase {
    constructor(provider) {
        super(provider, 'dotnet');
    }
    shouldRun(item) {
        this.parameters = [
            new StaticCommandParameter_1.StaticCommandParameter('add'),
            new StaticCommandParameter_1.StaticCommandParameter(item.project.fullPath),
            new StaticCommandParameter_1.StaticCommandParameter('package'),
            new InputTextCommandParameter_1.InputTextCommandParameter('Package Name...')
        ];
        return true;
    }
}
exports.AddPackageCommand = AddPackageCommand;
//# sourceMappingURL=AddPackageCommand.js.map