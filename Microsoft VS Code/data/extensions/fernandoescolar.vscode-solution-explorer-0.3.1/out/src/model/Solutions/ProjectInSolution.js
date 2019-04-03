"use strict";
/***********
 * TypeScript simplified version of:
 * https://github.com/Microsoft/msbuild/blob/master/src/Build/Construction/Solution/ProjectInSolution.cs
 */
Object.defineProperty(exports, "__esModule", { value: true });
class ProjectInSolution {
    constructor(solution) {
        this.solution = solution;
        this.dependencies = [];
        this.webProperties = {};
        this.configuration = {};
    }
    addDependency(parentGuid) {
        this.dependencies.push(parentGuid);
    }
    addWebProperty(name, value) {
        this.webProperties[name] = value;
    }
    setProjectConfiguration(name, configuration) {
        this.configuration[name] = configuration;
    }
}
exports.ProjectInSolution = ProjectInSolution;
//# sourceMappingURL=ProjectInSolution.js.map