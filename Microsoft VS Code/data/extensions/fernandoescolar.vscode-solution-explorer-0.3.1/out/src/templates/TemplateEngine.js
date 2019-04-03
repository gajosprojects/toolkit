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
const TemplateFilename = "template-list.json";
class TemplateEngine {
    constructor(workingFolder) {
        this.workingFolder = workingFolder;
    }
    getTemplates(extension) {
        return __awaiter(this, void 0, void 0, function* () {
            if (!this.templates) {
                let filepath = path.join(this.workingFolder, TemplateFilename);
                let content = yield fs.readFile(filepath, "utf8");
                this.templates = eval(content).templates;
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
    generate(extension, templateName, parameters) {
        return __awaiter(this, void 0, void 0, function* () {
            let index = this.templates.findIndex(t => t.extension.toLocaleLowerCase() == extension.toLocaleLowerCase() && t.name == templateName);
            if (index < 0)
                return;
            let template = this.templates[index];
            let content = yield fs.readFile(path.join(this.workingFolder, template.file), "utf8");
            let handlebar = Handlebars.compile(content);
            let result = handlebar(parameters);
            return result;
        });
    }
}
exports.TemplateEngine = TemplateEngine;
//# sourceMappingURL=TemplateEngine.js.map