"use strict";
var __awaiter = (this && this.__awaiter) || function (thisArg, _arguments, P, generator) {
    return new (P || (P = Promise))(function (resolve, reject) {
        function fulfilled(value) { try { step(generator.next(value)); } catch (e) { reject(e); } }
        function rejected(value) { try { step(generator["throw"](value)); } catch (e) { reject(e); } }
        function step(result) { result.done ? resolve(result.value) : new P(function (resolve) { resolve(result.value); }).then(fulfilled, rejected); }
        step((generator = generator.apply(thisArg, _arguments || [])).next());
    });
};
Object.defineProperty(exports, "__esModule", { value: true });
const path = require("path");
const CliCommandBase_1 = require("./base/CliCommandBase");
const StaticCommandParameter_1 = require("./parameters/StaticCommandParameter");
const InputTextCommandParameter_1 = require("./parameters/InputTextCommandParameter");
const InputOptionsCommandParameter_1 = require("./parameters/InputOptionsCommandParameter");
const ProjectTypes = [
    { name: 'Console application', value: 'console', languages: ['C#', 'F#', 'VB'] },
    { name: 'Class library', value: 'classlib', languages: ['C#', 'F#', 'VB'] },
    { name: 'Unit test project', value: 'mstest', languages: ['C#', 'F#', 'VB'] },
    { name: 'xUnit test project', value: 'xunit', languages: ['C#', 'F#', 'VB'] },
    { name: 'ASP.NET Core empty', value: 'web', languages: ['C#', 'F#'] },
    { name: 'ASP.NET Core Web App (Model-View-Controller)', value: 'mvc', languages: ['C#', 'F#'] },
    { name: 'ASP.NET Core Web App', value: 'razor', languages: ['C#'] },
    { name: 'ASP.NET Core with Angular', value: 'angular', languages: ['C#'] },
    { name: 'ASP.NET Core with React.js', value: 'react', languages: ['C#'] },
    { name: 'ASP.NET Core with React.js and Redux', value: 'reactredux', languages: ['C#'] },
    { name: 'ASP.NET Core Web API', value: 'webapi', languages: ['C#', 'F#'] }
];
class AddNewProjectCommand extends CliCommandBase_1.CliCommandBase {
    constructor(provider) {
        super(provider, 'dotnet');
    }
    run(item) {
        const _super = name => super[name];
        return __awaiter(this, void 0, void 0, function* () {
            yield _super("run").call(this, item);
            yield this.addProjectToSolution(item);
        });
    }
    shouldRun(item) {
        this.parameters = [
            new StaticCommandParameter_1.StaticCommandParameter('new'),
            new InputOptionsCommandParameter_1.InputOptionsCommandParameter('Select project type', this.getProjectTypes()),
            new InputOptionsCommandParameter_1.InputOptionsCommandParameter('Select language', () => this.getLanguages(), '-lang'),
            new InputTextCommandParameter_1.InputTextCommandParameter('Project name...', '-n'),
            new InputTextCommandParameter_1.InputTextCommandParameter('Folder name...', '-o'),
        ];
        return true;
    }
    getProjectTypes() {
        let result = {};
        ProjectTypes.forEach(pt => {
            result[pt.name] = pt.value;
        });
        return result;
    }
    getLanguages() {
        let result = ['C#'];
        let selectedProject = this.args[this.args.length - 1];
        let index = ProjectTypes.findIndex(pt => pt.value == selectedProject);
        if (index >= 0)
            result = ProjectTypes[index].languages;
        return Promise.resolve(result);
    }
    addProjectToSolution(item) {
        let workingpath = path.dirname(item.path);
        let projectPath = path.join(workingpath, this.args[this.args.length - 1], this.args[this.args.length - 3]);
        if (this.args[this.args.length - 5] == 'C#')
            projectPath += '.csproj';
        if (this.args[this.args.length - 5] == 'F#')
            projectPath += '.fsproj';
        if (this.args[this.args.length - 5] == 'VB')
            projectPath += '.vbproj';
        return this.runCliCommand('dotnet', ['sln', item.path, 'add', projectPath], workingpath);
    }
}
exports.AddNewProjectCommand = AddNewProjectCommand;
//# sourceMappingURL=AddNewProjectCommand.js.map