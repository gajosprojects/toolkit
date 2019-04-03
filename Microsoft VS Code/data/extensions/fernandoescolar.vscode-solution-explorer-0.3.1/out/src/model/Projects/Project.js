"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
class Project {
    constructor(projectInSolution, type) {
        this.projectInSolution = projectInSolution;
        this.type = type;
        this._hasReferences = true;
    }
    get fullPath() {
        return this.projectInSolution.fullPath;
    }
    get hasReferences() {
        return this._hasReferences;
    }
    setHasReferences(value) {
        this._hasReferences = value;
    }
}
exports.Project = Project;
//# sourceMappingURL=Project.js.map