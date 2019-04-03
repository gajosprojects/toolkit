"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const vscode = require("vscode");
const ConfigurationName = 'vssolution';
const ItemTypesName = 'xxprojItemTypes';
const ShowInExplorerName = 'showInExplorer';
const SolutionExplorerIconsName = 'solutionExplorerIcons';
const ShowOutputChannelName = 'showOutputChannel';
const NetcoreIgnoreName = 'netcoreIgnore';
let config = null;
function register() {
    config = vscode.workspace.getConfiguration(ConfigurationName);
}
exports.register = register;
function getItemTypes() {
    return config.get(ItemTypesName, {
        "*": "Content",
        "cs": "Compile",
        "vb": "Compile",
        "fs": "Compile",
        "ts": "TypeScriptCompile"
    });
}
exports.getItemTypes = getItemTypes;
function getShowInExplorer() {
    return config.get(ShowInExplorerName, true);
}
exports.getShowInExplorer = getShowInExplorer;
function getSolutionExplorerIcons() {
    return config.get(SolutionExplorerIconsName, exports.ICONS_CUSTOM);
}
exports.getSolutionExplorerIcons = getSolutionExplorerIcons;
function getShowOutputChannel() {
    return config.get(ShowOutputChannelName, true);
}
exports.getShowOutputChannel = getShowOutputChannel;
function getNetCoreIgnore() {
    return config.get(NetcoreIgnoreName, ["bin", "node_modules", "obj", ".ds_store"]);
}
exports.getNetCoreIgnore = getNetCoreIgnore;
exports.ICONS_THEME = "current-theme";
exports.ICONS_MIXED = "mix";
exports.ICONS_CUSTOM = "solution-explorer";
//# sourceMappingURL=SolutionExplorerConfiguration.js.map