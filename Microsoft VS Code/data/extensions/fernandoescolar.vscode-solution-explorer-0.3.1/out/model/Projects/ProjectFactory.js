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
const fs = require("../../async/fs");
const xml = require("../../async/xml");
const Solutions_1 = require("../Solutions");
const CpsProject_1 = require("./Kinds/CpsProject");
const StandardProject_1 = require("./Kinds/StandardProject");
const WebsiteProject_1 = require("./Kinds/WebsiteProject");
const Project_1 = require("./Project");
const SharedProject_1 = require("./Kinds/SharedProject");
const DeployProject_1 = require("./Kinds/DeployProject");
const NoReferencesStandardProject_1 = require("./Kinds/NoReferencesStandardProject");
const cpsProjectTypes = [Solutions_1.ProjectTypeIds.cpsCsProjectGuid, Solutions_1.ProjectTypeIds.cpsVbProjectGuid, Solutions_1.ProjectTypeIds.cpsProjectGuid];
const standardProjectTypes = [Solutions_1.ProjectTypeIds.csProjectGuid, Solutions_1.ProjectTypeIds.fsProjectGuid, Solutions_1.ProjectTypeIds.vbProjectGuid, Solutions_1.ProjectTypeIds.vcProjectGuid];
class ProjectFactory {
    static parse(project) {
        if (project.fullPath.toLocaleLowerCase().endsWith(".njsproj")) {
            return ProjectFactory.loadNoReferencesStandardProject(project);
        }
        if (project.projectType == Solutions_1.SolutionProjectType.KnownToBeMSBuildFormat
            && cpsProjectTypes.indexOf(project.projectTypeId) >= 0) {
            return ProjectFactory.loadCpsProject(project);
        }
        if (project.projectType == Solutions_1.SolutionProjectType.KnownToBeMSBuildFormat
            && standardProjectTypes.indexOf(project.projectTypeId) >= 0) {
            return ProjectFactory.determineStandardProject(project);
        }
        if (project.projectType == Solutions_1.SolutionProjectType.WebProject) {
            return ProjectFactory.loadWebsiteProject(project);
        }
        if (project.projectTypeId == Solutions_1.ProjectTypeIds.shProjectGuid) {
            return ProjectFactory.loadSharedProject(project);
        }
        if (project.projectTypeId == Solutions_1.ProjectTypeIds.deployProjectGuid) {
            return ProjectFactory.loadDeploydProject(project);
        }
        return Promise.resolve(null);
    }
    static determineStandardProject(project) {
        return __awaiter(this, void 0, void 0, function* () {
            let document = yield ProjectFactory.loadProjectDocument(project.fullPath);
            let element = Project_1.Project.getProjectElement(document);
            if (!element) {
                return null;
            }
            if (element.attributes.Sdk
                && element.attributes.Sdk.startsWith("Microsoft.NET.Sdk"))
                return new CpsProject_1.CpsProject(project, document);
            return new StandardProject_1.StandardProject(project, document);
        });
    }
    static loadProjectDocument(projectFullPath) {
        return __awaiter(this, void 0, void 0, function* () {
            let content = yield fs.readFile(projectFullPath, 'utf8');
            return yield xml.ParseToJson(content);
        });
    }
    static loadCpsProject(project) {
        return __awaiter(this, void 0, void 0, function* () {
            let document = yield ProjectFactory.loadProjectDocument(project.fullPath);
            return new CpsProject_1.CpsProject(project, document);
        });
    }
    static loadNoReferencesStandardProject(project) {
        return Promise.resolve(new NoReferencesStandardProject_1.NoReferencesStandardProject(project));
    }
    static loadWebsiteProject(project) {
        project.fullPath = project.fullPath + '.web-project';
        return Promise.resolve(new WebsiteProject_1.WebsiteProject(project));
    }
    static loadSharedProject(project) {
        return Promise.resolve(new SharedProject_1.SharedProject(project));
    }
    static loadDeploydProject(project) {
        return Promise.resolve(new DeployProject_1.DeployProject(project));
    }
}
exports.ProjectFactory = ProjectFactory;
//# sourceMappingURL=ProjectFactory.js.map