"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const FileSystemBasedProject_1 = require("./FileSystemBasedProject");
class WebsiteProject extends FileSystemBasedProject_1.FileSystemBasedProject {
    constructor(projectInSolution) {
        super(projectInSolution, 'website');
        this.setHasReferences(false);
    }
    refresh() {
        return Promise.resolve();
    }
    getProjectReferences() {
        return Promise.resolve(null);
    }
    getPackageReferences() {
        return Promise.resolve(null);
    }
}
exports.WebsiteProject = WebsiteProject;
//# sourceMappingURL=WebsiteProject.1.js.map