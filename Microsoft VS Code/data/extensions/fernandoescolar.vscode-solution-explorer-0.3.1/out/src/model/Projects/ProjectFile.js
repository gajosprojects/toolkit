"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const path = require("path");
class ProjectFile {
    constructor(fullPath) {
        this.fullPath = fullPath;
        this.hasDependents = false;
        this.dependents = [];
        this.name = this.fullPath.split(path.sep).pop();
    }
}
exports.ProjectFile = ProjectFile;
//# sourceMappingURL=ProjectFile.js.map