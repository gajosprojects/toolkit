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
const InputTextCommandParameter_1 = require("./parameters/InputTextCommandParameter");
class RenameSolutionItemCommand extends CommandBase_1.CommandBase {
    constructor(provider) {
        super();
        this.provider = provider;
    }
    shouldRun(item) {
        this.parameters = [
            new InputTextCommandParameter_1.InputTextCommandParameter(item.label)
        ];
        return !!item.solution;
    }
    runCommand(item, args) {
        return __awaiter(this, void 0, void 0, function* () {
            if (!args || args.length <= 0)
                return;
            let projectInSolution = item.projectInSolution;
            try {
                if (!projectInSolution) {
                    let name = args[0];
                    if (!name.toLowerCase().endsWith('.sln'))
                        name += '.sln';
                    yield this.renameFile(item.solution.FullPath, name);
                    this.provider.logger.log("Solution renamed: " + name);
                    this.provider.refresh();
                }
                else {
                    let data = yield fs.readFile(item.solution.FullPath, 'utf8');
                    let lines = data.split('\n');
                    lines.some((l, index) => {
                        if (l.indexOf('"' + item.label + '"') >= 0) {
                            let aux = l;
                            while (aux.indexOf('"' + item.label + '"') >= 0) {
                                aux = aux.replace('"' + item.label + '"', '"' + args[0] + '"');
                            }
                            lines.splice(index, 1, aux);
                            return true;
                        }
                        return false;
                    });
                    if (item.project) {
                        let ext = path.extname(item.project.fullPath);
                        let sourceName = item.project.fullPath.replace(path.dirname(item.project.fullPath), '');
                        if (sourceName.startsWith(path.sep))
                            sourceName = sourceName.substring(1);
                        let name = args[0];
                        if (!name.toLowerCase().endsWith(ext))
                            name += ext;
                        yield this.renameFile(item.project.fullPath, name);
                        lines.some((l, index) => {
                            if (l.indexOf(sourceName) >= 0) {
                                let aux = l.replace(sourceName, name);
                                lines.splice(index, 1, aux);
                                return true;
                            }
                            return false;
                        });
                    }
                    yield fs.writeFile(item.solution.FullPath, lines.join('\n'));
                    this.provider.logger.log("Solution item moved");
                }
            }
            catch (ex) {
                this.provider.logger.error('Can not rename this item: ' + ex);
            }
        });
    }
    renameFile(fullpath, name) {
        return __awaiter(this, void 0, void 0, function* () {
            let folder = path.dirname(fullpath);
            let newItempath = path.join(folder, name);
            yield fs.rename(fullpath, newItempath);
            return newItempath;
        });
    }
}
exports.RenameSolutionItemCommand = RenameSolutionItemCommand;
//# sourceMappingURL=RenameSolutionItemCommand.js.map