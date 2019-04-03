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
const uuid = require("node-uuid");
const fs = require("../async/fs");
const CommandBase_1 = require("./base/CommandBase");
const InputTextCommandParameter_1 = require("./parameters/InputTextCommandParameter");
const Solutions_1 = require("../model/Solutions");
class CreateSolutionFolderCommand extends CommandBase_1.CommandBase {
    constructor(provider) {
        super();
        this.provider = provider;
        this.parameters = [
            new InputTextCommandParameter_1.InputTextCommandParameter('New folder name')
        ];
    }
    shouldRun(item) {
        return !!item.solution;
    }
    runCommand(item, args) {
        return __awaiter(this, void 0, void 0, function* () {
            if (!args || args.length <= 0)
                return;
            let projectInSolution = item.projectInSolution;
            if (!projectInSolution) {
                if (item.solution.Projects.findIndex(p => p.projectName == args[0] && p.projectType == Solutions_1.SolutionProjectType.SolutionFolder && !p.parentProjectGuid) >= 0) {
                    this.provider.logger.error('Can not create solution folder, the folder already exists');
                    return;
                }
            }
            else {
                if (item.solution.Projects.findIndex(p => p.projectName == args[0] && p.projectType == Solutions_1.SolutionProjectType.SolutionFolder && p.parentProjectGuid == projectInSolution.projectGuid) >= 0) {
                    this.provider.logger.error('Can not create solution folder, the folder already exists');
                    return;
                }
            }
            try {
                let data = yield fs.readFile(item.solution.FullPath, 'utf8');
                let lines = data.split('\n');
                let guid = uuid.v1().toUpperCase();
                let done = lines.some((line, index, arr) => {
                    if (line.trim() == 'Global') {
                        lines.splice(index, 0, 'Project("{2150E333-8FDC-42A3-9474-1A3956D46DE8}") = "' + args[0] + '", "' + args[0] + '", "{' + guid + '}"\r', 'EndProject\r');
                        return true;
                    }
                    return false;
                });
                if (projectInSolution && done) {
                    let endGlobalIndex = -1;
                    done = lines.some((line, index, arr) => {
                        if (projectInSolution && line.trim() == 'GlobalSection(NestedProjects) = preSolution') {
                            lines.splice(index + 1, 0, '		{' + guid + '} = ' + projectInSolution.projectGuid + '\r');
                            return true;
                        }
                        if (line.trim() == 'EndGlobal') {
                            endGlobalIndex = index;
                        }
                        return false;
                    });
                    if (!done && endGlobalIndex > 0) {
                        lines.splice(endGlobalIndex, 0, '	GlobalSection(NestedProjects) = preSolution\r', '		{' + guid + '} = ' + projectInSolution.projectGuid + '\r', '	EndGlobalSection\r');
                        done = true;
                    }
                }
                if (done) {
                    yield fs.writeFile(item.solution.FullPath, lines.join('\n'));
                    this.provider.logger.log("Solution folder created: " + args[0]);
                }
                else {
                    this.provider.logger.error('Can not create solution folder');
                }
            }
            catch (ex) {
                this.provider.logger.error('Can not create solution folder: ' + ex);
            }
        });
    }
}
exports.CreateSolutionFolderCommand = CreateSolutionFolderCommand;
//# sourceMappingURL=CreateSolutionFolderCommand.js.map