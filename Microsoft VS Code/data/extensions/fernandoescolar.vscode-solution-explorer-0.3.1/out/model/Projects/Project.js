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
    get solutionItems() {
        return this.projectInSolution.solutionItems;
    }
    static getProjectElement(document) {
        if (document.elements.length == 1) {
            return document.elements[0];
        }
        else {
            for (let i = 0; i < document.elements.length; i++) {
                if (document.elements[i].type !== 'comment') {
                    return document.elements[i];
                }
            }
        }
        return null;
    }
}
exports.Project = Project;
//# sourceMappingURL=Project.js.map