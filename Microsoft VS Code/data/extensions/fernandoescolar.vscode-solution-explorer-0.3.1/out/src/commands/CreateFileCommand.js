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
const vscode = require("vscode");
const path = require("path");
const tree_1 = require("../tree");
const CommandBase_1 = require("./base/CommandBase");
const InputTextCommandParameter_1 = require("./parameters/InputTextCommandParameter");
const InputOptionsCommandParameter_1 = require("./parameters/InputOptionsCommandParameter");
const TemplateEngine_1 = require("../templates/TemplateEngine");
class CreateFileCommand extends CommandBase_1.CommandBase {
    constructor(provider) {
        super();
        this.provider = provider;
        this.templates = new TemplateEngine_1.TemplateEngine(path.dirname(__filename));
        this.parameters = [
            new InputTextCommandParameter_1.InputTextCommandParameter('New file name'),
            new InputOptionsCommandParameter_1.InputOptionsCommandParameter('Select template', () => this.getTemplatesTypes()),
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
                let content = yield this.getContent();
                let filepath = yield item.project.createFile(targetpath, args[0], content);
                let document = yield vscode.workspace.openTextDocument(filepath);
                vscode.window.showTextDocument(document);
                this.provider.logger.log("File created: " + filepath);
            }
            catch (ex) {
                this.provider.logger.error('Can not create file: ' + ex);
            }
        });
    }
    getTemplatesTypes() {
        return __awaiter(this, void 0, void 0, function* () {
            let extension = path.extname(this.args[0]).substring(1);
            let result = yield this.templates.getTemplates(extension);
            return result;
        });
    }
    getContent() {
        if (!this.args[1])
            return Promise.resolve("");
        let extension = path.extname(this.args[0]).substring(1);
        let parameters = {
            namespace: "",
            name: path.basename(this.args[0], extension)
        };
        return this.templates.generate(extension, this.args[1], parameters);
    }
}
exports.CreateFileCommand = CreateFileCommand;
//# sourceMappingURL=CreateFileCommand.js.map