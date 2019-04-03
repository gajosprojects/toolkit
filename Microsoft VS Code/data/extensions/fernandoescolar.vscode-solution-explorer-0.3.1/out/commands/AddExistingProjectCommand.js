"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const CliCommandBase_1 = require("./base/CliCommandBase");
const StaticCommandParameter_1 = require("./parameters/StaticCommandParameter");
const OpenFileCommandParameter_1 = require("./parameters/OpenFileCommandParameter");
class AddExistingProjectCommand extends CliCommandBase_1.CliCommandBase {
    constructor(provider) {
        super('Add existing project', provider, 'dotnet');
    }
    shouldRun(item) {
        let options = {
            openLabel: 'Add',
            canSelectFolders: false,
            canSelectMany: false,
            filters: { 'Projects': ['csproj', 'vbproj', 'fsproj'] }
        };
        this.parameters = [
            new StaticCommandParameter_1.StaticCommandParameter('sln'),
            new StaticCommandParameter_1.StaticCommandParameter(item.path),
            new StaticCommandParameter_1.StaticCommandParameter('add'),
            new OpenFileCommandParameter_1.OpenFileCommandParameter(options)
        ];
        return true;
    }
}
exports.AddExistingProjectCommand = AddExistingProjectCommand;
//# sourceMappingURL=AddExistingProjectCommand.js.map