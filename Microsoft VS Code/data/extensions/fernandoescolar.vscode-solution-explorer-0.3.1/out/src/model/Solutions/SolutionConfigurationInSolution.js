"use strict";
/***********
 * TypeScript simplified version of:
 * https://github.com/Microsoft/msbuild/blob/master/src/Build/Construction/Solution/SolutionConfigurationInSolution.cs
 */
Object.defineProperty(exports, "__esModule", { value: true });
class SolutionConfigurationInSolution {
    constructor(configurationName, platformName) {
        this.configurationName = configurationName;
        this.platformName = platformName;
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
exports.SolutionConfigurationInSolution = SolutionConfigurationInSolution;
//# sourceMappingURL=SolutionConfigurationInSolution.js.map