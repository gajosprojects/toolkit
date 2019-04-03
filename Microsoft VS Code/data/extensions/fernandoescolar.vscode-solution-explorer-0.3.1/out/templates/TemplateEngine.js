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
const Handlebars = require("handlebars");
const path = require("path");
const fs = require("../async/fs");
const tree_1 = require("../tree");
const TemplateFoldername = "solution-explorer";
const VsCodeFoldername = ".vscode";
const TemplateFilename = "template-list.json";
const SourceFolder = path.join(__filename, "..", "..", "..", "files-vscode-folder");
class TemplateEngine {
    constructor(workspaceRoot) {
        this.workspaceRoot = workspaceRoot;
        this.vscodeFolder = path.join(workspaceRoot, VsCodeFoldername);
        this.workingFolder = path.join(workspaceRoot, VsCodeFoldername, TemplateFoldername);
        this.templateFile = path.join(workspaceRoot, VsCodeFoldername, TemplateFoldername, TemplateFilename);
    }
    getTemplates(extension) {
        return __awaiter(this, void 0, void 0, function* () {
            if (!this.templates) {
                if (!(yield fs.exists(this.templateFile)))
                    return [];
                let content = yield fs.readFile(this.templateFile, "utf8");
                this.templates = JSON.parse(content).templates;
            }
            let result = [];
            this.templates.forEach(t => {
                if (t.extension.toLocaleLowerCase() == extension.toLocaleLowerCase()) {
                    result.push(t.name);
                }
            });
            return result;
        });
    }
    generate(filename, templateName, item) {
        return __awaiter(this, void 0, void 0, function* () {
            let extension = path.extname(filename).substring(1);
            let index = this.templates.findIndex(t => t.extension.toLocaleLowerCase() == extension.toLocaleLowerCase() && t.name == templateName);
            if (index < 0)
                return;
            let template = this.templates[index];
            let content = yield fs.readFile(path.join(this.workingFolder, template.file), "utf8");
            let handlebar = Handlebars.compile(content);
            let parameters = yield this.getParameters(template, filename, item);
            let result = handlebar(parameters);
            return result;
        });
    }
    existsTemplates() {
        return __awaiter(this, void 0, void 0, function* () {
            return yield fs.exists(this.templateFile);
        });
    }
    creteTemplates() {
        return __awaiter(this, void 0, void 0, function* () {
            if (!(yield fs.exists(this.vscodeFolder)))
                yield fs.mkdir(this.vscodeFolder);
            yield this.copyFolder(SourceFolder, this.workingFolder);
        });
    }
    getParameters(template, filename, item) {
        return __awaiter(this, void 0, void 0, function* () {
            let parametersGetter = require(path.join(this.workingFolder, template.parameters));
            if (parametersGetter) {
                let result = parametersGetter(filename, item.project ? item.project.fullPath : null, item.contextValue.startsWith(tree_1.ContextValues.ProjectFolder) ? item.path : null);
                if (Promise.resolve(result) === result) {
                    result = yield result;
                }
                return result;
            }
            return null;
        });
    }
    copyFolder(src, dest) {
        return __awaiter(this, void 0, void 0, function* () {
            var exists = yield fs.exists(src);
            var stats = exists && (yield fs.lstat(src));
            var isDirectory = exists && stats.isDirectory();
            if (exists && isDirectory) {
                if (!(yield fs.exists(dest)))
                    yield fs.mkdir(dest);
                let items = yield fs.readdir(src);
                for (let i = 0; i < items.length; i++) {
                    let childItemName = items[i];
                    yield this.copyFolder(path.join(src, childItemName), path.join(dest, childItemName));
                }
            }
            else {
                let content = yield fs.readFile(src, "binary");
                yield fs.writeFile(dest, content, "binary");
            }
        });
    }
}
exports.TemplateEngine = TemplateEngine;
//# sourceMappingURL=TemplateEngine.js.map