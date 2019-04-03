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
const ConfirmCommandParameter_1 = require("./parameters/ConfirmCommandParameter");
class DeleteCommand extends CommandBase_1.CommandBase {
    constructor(provider) {
        super('Delete');
        this.provider = provider;
    }
    shouldRun(item) {
        this.parameters = [
            new ConfirmCommandParameter_1.ConfirmCommandParameter('Are you sure you want to delete file "' + item.label + '"?')
        ];
        return !!item.project;
    }
    runCommand(item, args) {
        return __awaiter(this, void 0, void 0, function* () {
            try {
                if (item.contextValue.startsWith(tree_1.ContextValues.ProjectFile))
                    yield item.project.deleteFile(item.path);
                else if (item.contextValue.startsWith(tree_1.ContextValues.ProjectFolder))
                    yield item.project.deleteFolder(item.path);
                else
                    return;
                this.provider.logger.log("Deleted: " + item.path);
            }
            catch (ex) {
                this.provider.logger.error('Can not delete item: ' + ex);
            }
        });
    }
}
exports.DeleteCommand = DeleteCommand;
//# sourceMappingURL=DeleteCommand.js.map