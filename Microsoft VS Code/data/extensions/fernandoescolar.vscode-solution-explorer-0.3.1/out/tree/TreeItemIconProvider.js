"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const path = require("path");
const fs = require("fs");
const ContextValues_1 = require("./ContextValues");
function getFileIconPath(filename) {
    return path.join(__filename, '..', '..', '..', 'icons', filename);
}
function getIconPath(lightFilename, darkFilename = null) {
    return {
        light: getFileIconPath(lightFilename),
        dark: getFileIconPath(darkFilename ? darkFilename : lightFilename)
    };
}
function getIconPathFromExtension(path, alternative) {
    if (path) {
        let extension = path.split('.').pop();
        let iconpath = getFileIconPath(extension + '.svg');
        if (fs.existsSync(iconpath))
            return getIconPath(extension + '.svg');
        iconpath = getFileIconPath(extension + '.png');
        if (fs.existsSync(iconpath))
            return getIconPath(extension + '.png');
    }
    return getIconPath(alternative);
}
function findIconPath(name, path, contextValue) {
    if (contextValue == ContextValues_1.ContextValues.Solution) {
        return getIconPath('sln.svg');
    }
    else if (contextValue.startsWith(ContextValues_1.ContextValues.ProjectFile)) {
        return getIconPathFromExtension(path, 'file.svg');
    }
    else if (contextValue.startsWith(ContextValues_1.ContextValues.ProjectReferences)) {
        return getIconPath('references.svg');
    }
    else if (contextValue.startsWith(ContextValues_1.ContextValues.ProjectReferencedProject)) {
        return getIconPath('referenced-project.svg');
    }
    else if (contextValue.startsWith(ContextValues_1.ContextValues.ProjectReferencedPackage)) {
        return getIconPath('packages.svg');
    }
    else if (contextValue == ContextValues_1.ContextValues.SolutionFolder || contextValue.startsWith(ContextValues_1.ContextValues.ProjectFolder)) {
        if (path && path.endsWith("wwwroot"))
            return getIconPath('wwwroot.svg');
        return getIconPath('folder.svg');
    }
    else if (contextValue.startsWith(ContextValues_1.ContextValues.Project)) {
        return getIconPathFromExtension(path, 'csproj.svg');
    }
    return getIconPath('file.svg');
}
exports.findIconPath = findIconPath;
//# sourceMappingURL=TreeItemIconProvider.js.map