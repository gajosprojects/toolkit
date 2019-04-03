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
const tree_1 = require("../tree");
const CommandBase_1 = require("./base/CommandBase");
const InputOptionsCommandParameter_1 = require("./parameters/InputOptionsCommandParameter");
class MoveCommand extends CommandBase_1.CommandBase {
    constructor(provider) {
        super();
        this.provider = provider;
    }
    shouldRun(item) {
        this.parameters = [
            new InputOptionsCommandParameter_1.InputOptionsCommandParameter('Select folder...', () => item.project.getFolderList())
        ];
        return !!item.project;
    }
    runCommand(item, args) {
        return __awaiter(this, void 0, void 0, function* () {
            if (!args || args.length <= 0)
                return;
            try {
                let newPath;
                if (item.contextValue.startsWith(tree_1.ContextValues.ProjectFile))
                    newPath = yield item.project.moveFile(item.path, args[0]);
                else if (item.contextValue.startsWith(tree_1.ContextValues.ProjectFolder))
                    newPath = yield item.project.moveFolder(item.path, args[0]);
                else
                    return;
                this.provider.logger.log("Moved: " + item.path + " -> " + newPath);
            }
            catch (ex) {
                this.provider.logger.error('Can not move item: ' + ex);
            }
        });
    }
}
exports.MoveCommand = MoveCommand;
//# sourceMappingURL=MoveCommand.js.map