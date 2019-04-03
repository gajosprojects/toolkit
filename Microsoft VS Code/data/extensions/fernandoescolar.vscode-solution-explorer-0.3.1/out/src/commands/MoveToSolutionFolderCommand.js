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
const fs = require("../async/fs");
const CommandBase_1 = require("./base/CommandBase");
const Solutions_1 = require("../model/Solutions");
const InputOptionsCommandParameter_1 = require("./parameters/InputOptionsCommandParameter");
class MoveToSolutionFolderCommand extends CommandBase_1.CommandBase {
    constructor(provider) {
        super();
        this.provider = provider;
    }
    shouldRun(item) {
        this.parameters = [
            new InputOptionsCommandParameter_1.InputOptionsCommandParameter('Select folder...', () => this.getFolders(item.solution))
        ];
        return !!item.solution;
    }
    runCommand(item, args) {
        return __awaiter(this, void 0, void 0, function* () {
            if (!args || args.length <= 0)
                return;
            let projectInSolution = item.projectInSolution;
            if (!projectInSolution) {
                this.provider.logger.error('Can not move this item');
                return;
            }
            try {
                let data = yield fs.readFile(item.solution.FullPath, 'utf8');
                let lines = data.split('\n');
                let done = false;
                if (!projectInSolution.parentProjectGuid) {
                    if (args[0] == 'root') {
                        return;
                    }
                    let endGlobalIndex = -1;
                    done = lines.some((line, index, arr) => {
                        if (projectInSolution && line.trim() == 'GlobalSection(NestedProjects) = preSolution') {
                            lines.splice(index + 1, 0, '		' + projectInSolution.projectGuid + ' = ' + args[0] + '\r');
                            return true;
                        }
                        if (line.trim() == 'EndGlobal') {
                            endGlobalIndex = index;
                        }
                        return false;
                    });
                    if (!done && endGlobalIndex > 0) {
                        lines.splice(endGlobalIndex, 0, '	GlobalSection(NestedProjects) = preSolution\r', '		' + projectInSolution.projectGuid + ' = ' + args[0] + '\r', '	EndGlobalSection\r');
                        done = true;
                    }
                }
                else if (args[0] != 'root') {
                    let index = lines.findIndex(l => l.trim().startsWith(projectInSolution.projectGuid + ' = ' + projectInSolution.parentProjectGuid));
                    if (index >= 0) {
                        lines.splice(index, 1, '		' + projectInSolution.projectGuid + ' = ' + args[0] + '\r');
                        done = true;
                    }
                }
                else {
                    let index = lines.findIndex(l => l.trim().startsWith(projectInSolution.projectGuid + ' = ' + projectInSolution.parentProjectGuid));
                    if (index >= 0) {
                        lines.splice(index, 1);
                        done = true;
                    }
                }
                if (done) {
                    yield fs.writeFile(item.solution.FullPath, lines.join('\n'));
                    this.provider.logger.log("Solution item moved");
                }
                else {
                    this.provider.logger.error('Can not move this item');
                }
            }
            catch (ex) {
                this.provider.logger.error('Can not move this item: ' + ex);
            }
        });
    }
    getFolders(solution) {
        let folders = [];
        solution.Projects.forEach(p => {
            if (p.projectType == Solutions_1.SolutionProjectType.SolutionFolder) {
                folders.push({ id: p.projectGuid, name: this.getFolderName(p, solution) });
            }
        });
        folders.sort((a, b) => {
            let x = a.name.toLowerCase();
            let y = b.name.toLowerCase();
            return x < y ? -1 : x > y ? 1 : 0;
        });
        let result = {};
        result[path.sep] = 'root';
        folders.forEach(f => {
            result[f.name] = f.id;
        });
        return Promise.resolve(result);
    }
    getFolderName(p, solution) {
        if (!p.parentProjectGuid)
            return path.sep + p.projectName;
        let parent = solution.ProjectsById[p.parentProjectGuid];
        return this.getFolderName(parent, solution) + path.sep + p.projectName;
    }
}
exports.MoveToSolutionFolderCommand = MoveToSolutionFolderCommand;
//# sourceMappingURL=MoveToSolutionFolderCommand.js.map