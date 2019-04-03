"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const path = require("path");
class ProjectFolder {
    constructor(fullPath) {
        this.fullPath = fullPath;
        this.name = this.fullPath.split(path.sep).pop();
    }
}
exports.ProjectFolder = ProjectFolder;
//# sourceMappingURL=ProjectFolder.js.map