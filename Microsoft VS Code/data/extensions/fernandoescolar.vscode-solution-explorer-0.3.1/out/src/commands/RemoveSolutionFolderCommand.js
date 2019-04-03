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
const fs = require("../async/fs");
const CommandBase_1 = require("./base/CommandBase");
class RemoveSolutionFolderCommand extends CommandBase_1.CommandBase {
    constructor(provider) {
        super();
        this.provider = provider;
        this.parameters = [];
    }
    shouldRun(item) {
        return !!item.solution;
    }
    runCommand(item, args) {
        return __awaiter(this, void 0, void 0, function* () {
            let projectInSolution = item.projectInSolution;
            if (!projectInSolution) {
                this.provider.logger.error('Can not delete solution folder');
                return;
            }
            try {
                let data = yield fs.readFile(item.solution.FullPath, 'utf8');
                let lines = data.split('\n');
                let toDelete = [projectInSolution];
                item.solution.Projects.forEach(p => {
                    if (p.parentProjectGuid == projectInSolution.projectGuid) {
                        toDelete.push(p);
                    }
                });
                toDelete.forEach(p => {
                    this.deleteProject(p, lines);
                });
                yield fs.writeFile(item.solution.FullPath, lines.join('\n'));
                this.provider.logger.log("Solution folder deleted");
            }
            catch (ex) {
                this.provider.logger.error('Can not delete solution folder: ' + ex);
            }
        });
    }
    deleteProject(p, lines) {
        lines.some((line, index, arr) => {
            if (line.trim().startsWith('Project(') && line.indexOf('"' + p.projectGuid + '"') > 0) {
                lines.splice(index, 2);
                return true;
            }
            return false;
        });
        let index;
        do {
            index = lines.findIndex(l => l.indexOf(p.projectGuid) >= 0);
            if (index >= 0)
                lines.splice(index, 1);
        } while (index >= 0);
    }
}
exports.RemoveSolutionFolderCommand = RemoveSolutionFolderCommand;
//# sourceMappingURL=RemoveSolutionFolderCommand.js.map