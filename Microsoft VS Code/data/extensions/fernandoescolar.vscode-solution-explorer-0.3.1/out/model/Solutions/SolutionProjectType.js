"use strict";
/***********
 * TypeScript simplified version of:
 * https://github.com/Microsoft/msbuild/blob/master/src/Build/Construction/Solution/ProjectInSolution.cs
 */
Object.defineProperty(exports, "__esModule", { value: true });
var SolutionProjectType;
(function (SolutionProjectType) {
    SolutionProjectType[SolutionProjectType["Unknown"] = 0] = "Unknown";
    /// <summary>
    /// C#, C++, VB, and VJ# projects
    /// </summary>
    SolutionProjectType[SolutionProjectType["KnownToBeMSBuildFormat"] = 1] = "KnownToBeMSBuildFormat";
    /// <summary>
    /// Solution folders appear in the .sln file, but aren't buildable projects.
    /// </summary>
    SolutionProjectType[SolutionProjectType["SolutionFolder"] = 2] = "SolutionFolder";
    /// <summary>
    /// ASP.NET projects
    /// </summary>
    SolutionProjectType[SolutionProjectType["WebProject"] = 3] = "WebProject";
    /// <summary>
    /// Web Deployment (.wdproj) projects
    /// </summary>
    SolutionProjectType[SolutionProjectType["WebDeploymentProject"] = 4] = "WebDeploymentProject";
    /// <summary>
    /// Project inside an Enterprise Template project
    /// </summary>
    SolutionProjectType[SolutionProjectType["EtpSubProject"] = 5] = "EtpSubProject";
})(SolutionProjectType = exports.SolutionProjectType || (exports.SolutionProjectType = {}));
//# sourceMappingURL=SolutionProjectType.js.map