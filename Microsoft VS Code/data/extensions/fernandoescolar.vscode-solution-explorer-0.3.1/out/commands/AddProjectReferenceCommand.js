"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const path = require("path");
const CliCommandBase_1 = require("./base/CliCommandBase");
const StaticCommandParameter_1 = require("./parameters/StaticCommandParameter");
const InputOptionsCommandParameter_1 = require("./parameters/InputOptionsCommandParameter");
const Solutions_1 = require("../model/Solutions");
class AddProjectReferenceCommand extends CliCommandBase_1.CliCommandBase {
    constructor(provider) {
        super('Add project reference', provider, 'dotnet');
    }
    shouldRun(item) {
        this.parameters = [
            new StaticCommandParameter_1.StaticCommandParameter('add'),
            new StaticCommandParameter_1.StaticCommandParameter(item.project.fullPath),
            new StaticCommandParameter_1.StaticCommandParameter('reference'),
            new InputOptionsCommandParameter_1.InputOptionsCommandParameter('Select project...', () => this.getCPSProjects(item))
        ];
        return true;
    }
    getCPSProjects(item) {
        let result = {};
        item.solution.Projects.forEach(p => {
            if (item.project && item.project.fullPath === p.fullPath)
                return false;
            if (p.projectType != Solutions_1.SolutionProjectType.SolutionFolder) {
                result[this.getProjectName(p, item.solution.Projects)] = p.fullPath;
            }
        });
        return Promise.resolve(result);
    }
    getProjectName(project, projects) {
        if (!project.parentProjectGuid)
            return project.projectName;
        let index = projects.findIndex(p => p.projectGuid == project.parentProjectGuid);
        if (index <= 0)
            return project.projectName;
        return this.getProjectName(projects[index], projects) + path.sep + project.projectName;
    }
}
exports.AddProjectReferenceCommand = AddProjectReferenceCommand;
//# sourceMappingURL=AddProjectReferenceCommand.js.map