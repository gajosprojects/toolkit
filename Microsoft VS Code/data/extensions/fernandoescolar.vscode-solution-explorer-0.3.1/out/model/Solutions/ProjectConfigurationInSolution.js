"use strict";
/***********
 * TypeScript simplified version of:
 * https://github.com/Microsoft/msbuild/blob/master/src/Build/Construction/Solution/ProjectConfigurationInSolution.cs
 */
Object.defineProperty(exports, "__esModule", { value: true });
class ProjectConfigurationInSolution {
    constructor(configurationName, platformName, includeInBuild) {
        this.configurationName = configurationName;
        this.platformName = platformName;
        this.includeInBuild = includeInBuild;
    }
    get fullName() {
        return this.computeFullName();
    }
    computeFullName() {
        // Some configurations don't have the platform part
        if (this.platformName && this.platformName.length > 0) {
            return this.configurationName + '|' + this.platformName;
        }
        else {
            return this.configurationName;
        }
    }
}
exports.ProjectConfigurationInSolution = ProjectConfigurationInSolution;
//# sourceMappingURL=ProjectConfigurationInSolution.js.map