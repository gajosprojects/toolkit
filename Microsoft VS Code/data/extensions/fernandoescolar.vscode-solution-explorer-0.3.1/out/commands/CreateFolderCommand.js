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
const tree_1 = require("../tree");
const CommandBase_1 = require("./base/CommandBase");
const InputTextCommandParameter_1 = require("./parameters/InputTextCommandParameter");
class CreateFolderCommand extends CommandBase_1.CommandBase {
    constructor(provider) {
        super('Create folder');
        this.provider = provider;
        this.parameters = [
            new InputTextCommandParameter_1.InputTextCommandParameter('New folder name', '')
        ];
    }
    shouldRun(item) {
        return !!item.project;
    }
    runCommand(item, args) {
        return __awaiter(this, void 0, void 0, function* () {
            if (!args || args.length <= 0)
                return;
            try {
                let targetpath = item.path;
                if (!item.contextValue.startsWith(tree_1.ContextValues.ProjectFolder))
                    targetpath = path.dirname(targetpath);
                let folderpath = path.join(targetpath, args[0]);
                yield item.project.createFolder(folderpath);
                this.provider.logger.log("Folder created: " + args[0]);
            }
            catch (ex) {
                this.provider.logger.error('Can not create folder: ' + ex);
            }
        });
    }
}
exports.CreateFolderCommand = CreateFolderCommand;
//# sourceMappingURL=CreateFolderCommand.js.map