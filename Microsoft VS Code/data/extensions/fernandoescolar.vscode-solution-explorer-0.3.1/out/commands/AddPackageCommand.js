"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const CliCommandBase_1 = require("./base/CliCommandBase");
const StaticCommandParameter_1 = require("./parameters/StaticCommandParameter");
const InputTextCommandParameter_1 = require("./parameters/InputTextCommandParameter");
const OptionalCommandParameter_1 = require("./parameters/OptionalCommandParameter");
class AddPackageCommand extends CliCommandBase_1.CliCommandBase {
    constructor(provider) {
        super('Add package', provider, 'dotnet');
    }
    shouldRun(item) {
        this.parameters = [
            new StaticCommandParameter_1.StaticCommandParameter('add'),
            new StaticCommandParameter_1.StaticCommandParameter(item.project.fullPath),
            new StaticCommandParameter_1.StaticCommandParameter('package'),
            new InputTextCommandParameter_1.InputTextCommandParameter('Package Name', ''),
            new OptionalCommandParameter_1.OptionalCommandParameter('Would you like to specify the package version?', new InputTextCommandParameter_1.InputTextCommandParameter('Package version', '1.0.0.0', '-v'))
        ];
        return true;
    }
}
exports.AddPackageCommand = AddPackageCommand;
//# sourceMappingURL=AddPackageCommand.js.map