"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const StandardProject_1 = require("./StandardProject");
class NoReferencesStandardProject extends StandardProject_1.StandardProject {
    constructor(projectInSolution, document, type) {
        super(projectInSolution, document, type ? type : 'standard');
        this.setHasReferences(false);
    }
}
exports.NoReferencesStandardProject = NoReferencesStandardProject;
//# sourceMappingURL=NoReferencesStandardProject.js.map