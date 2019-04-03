"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const path = require("path");
const StandardProject_1 = require("./StandardProject");
const __1 = require("..");
const projectFileName = "";
class SharedProject extends StandardProject_1.StandardProject {
    constructor(projectInSolution) {
        super(projectInSolution, null, 'shared');
        this.setHasReferences(false);
        this.includePrefix = "$(MSBuildThisFileDirectory)";
    }
    get fullPath() {
        return this.projectInSolution.fullPath.replace(".shproj", ".projitems");
    }
    getProjectReferences() {
        return Promise.resolve(null);
    }
    getPackageReferences() {
        return Promise.resolve(null);
    }
    addFileDependents(item, projectFile) {
        let key = path.basename(item.virtualpath);
        if (this.dependents[key]) {
            projectFile.hasDependents = true;
            this.dependents[key].forEach(d => {
                let dependentFullPath = path.join(path.dirname(this.fullPath), d);
                projectFile.dependents.push(new __1.ProjectFile(dependentFullPath));
            });
        }
    }
    replaceDependsUponNode(ref, pattern, newPattern) {
        ref.elements.forEach(e => {
            if (e.name === 'DependentUpon' && e.elements[0].text.startsWith(pattern)) {
                e.elements[0].text = e.elements[0].text.replace(pattern, newPattern);
            }
        });
    }
    deleteDependsUponNode(node, pattern) {
        if (!node.elements)
            return;
        node.elements.forEach((e, eIndex) => {
            if (e.name === 'DependentUpon' && e.elements[0].text.startsWith(pattern)) {
                node.elements.splice(eIndex, 1);
            }
        });
        if (node.elements.length === 0) {
            delete node.elements;
        }
    }
}
exports.SharedProject = SharedProject;
//# sourceMappingURL=SharedProject.js.map