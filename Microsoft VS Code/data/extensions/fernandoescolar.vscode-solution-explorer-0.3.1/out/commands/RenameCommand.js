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
const InputTextCommandParameter_1 = require("./parameters/InputTextCommandParameter");
class RenameCommand extends CommandBase_1.CommandBase {
    constructor(provider) {
        super('Rename');
        this.provider = provider;
    }
    shouldRun(item) {
        this.parameters = [
            new InputTextCommandParameter_1.InputTextCommandParameter('New name', item.label, null, item.label)
        ];
        return !!item.project;
    }
    runCommand(item, args) {
        return __awaiter(this, void 0, void 0, function* () {
            if (!args || args.length <= 0)
                return;
            try {
                if (item.contextValue.startsWith(tree_1.ContextValues.ProjectFile))
                    yield item.project.renameFile(item.path, args[0]);
                else if (item.contextValue.startsWith(tree_1.ContextValues.ProjectFolder))
                    yield item.project.renameFolder(item.path, args[0]);
                else
                    return;
                this.provider.logger.log("Renamed: " + item.path + " -> " + args[0]);
            }
            catch (ex) {
                this.provider.logger.error('Can not rename item: ' + ex);
            }
        });
    }
}
exports.RenameCommand = RenameCommand;
//# sourceMappingURL=RenameCommand.js.map