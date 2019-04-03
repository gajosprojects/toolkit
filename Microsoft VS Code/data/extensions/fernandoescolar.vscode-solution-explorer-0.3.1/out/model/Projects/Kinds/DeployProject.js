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
const StandardProject_1 = require("./StandardProject");
class DeployProject extends StandardProject_1.StandardProject {
    constructor(projectInSolution) {
        super(projectInSolution, null, 'deploy');
    }
    getProjectFilesAndFolders(virtualPath) {
        const _super = name => super[name];
        return __awaiter(this, void 0, void 0, function* () {
            let result = yield _super("getProjectFilesAndFolders").call(this, virtualPath);
            let index = result.files.findIndex(f => f.name.toLocaleLowerCase() === 'deployment.targets');
            if (index >= 0) {
                result.files.splice(index, 1);
            }
            return result;
        });
    }
}
exports.DeployProject = DeployProject;
//# sourceMappingURL=DeployProject.js.map