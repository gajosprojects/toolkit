"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const vscode = require("vscode");
const ConfigurationName = 'vssolution';
const ItemTypesName = 'xxprojItemTypes';
const ShowModeName = 'showMode';
const TrackActiveItemName = 'trackActiveItem';
const SolutionExplorerIconsName = 'solutionExplorerIcons';
const ShowOutputChannelName = 'showOutputChannel';
const NetcoreIgnoreName = 'netcoreIgnore';
const AlternativeSolutionFoldersName = 'altSolutionFolders';
const XmlSpacesName = 'xmlspaces';
const XmlClosingTagSpace = 'xmlClosingTagSpace';
const Win32EncodingName = 'win32Encoding';
const CreateTemplateFolderQuestion = 'createTemplateFolderQuestion';
let config = null;
function register() {
    config = vscode.workspace.getConfiguration(ConfigurationName);
}
exports.register = register;
function getItemTypes() {
    return config.get(ItemTypesName, {
        "*": "Content",
        "cs": "Compile",
        "cpp": "ClCompile",
        "cc": "ClCompile",
        "c": "ClCompile",
        "h": "ClInclude",
        "hpp": "ClInclude",
        "vb": "Compile",
        "fs": "Compile",
        "ts": "TypeScriptCompile",
        "xaml": "EmbeddedResource"
    });
}
exports.getItemTypes = getItemTypes;
function getShowMode() {
    return config.get(ShowModeName, exports.SHOW_MODE_ACTIVITYBAR);
}
exports.getShowMode = getShowMode;
function getSolutionExplorerIcons() {
    return config.get(SolutionExplorerIconsName, exports.ICONS_CUSTOM);
}
exports.getSolutionExplorerIcons = getSolutionExplorerIcons;
function getTrackActiveItem() {
    return config.get(TrackActiveItemName, false);
}
exports.getTrackActiveItem = getTrackActiveItem;
function getShowOutputChannel() {
    return config.get(ShowOutputChannelName, true);
}
exports.getShowOutputChannel = getShowOutputChannel;
function getNetCoreIgnore() {
    return config.get(NetcoreIgnoreName, ["bin", "node_modules", "obj", ".ds_store"]);
}
exports.getNetCoreIgnore = getNetCoreIgnore;
function getAlternativeSolutionFolders() {
    return config.get(AlternativeSolutionFoldersName, ["src"]);
}
exports.getAlternativeSolutionFolders = getAlternativeSolutionFolders;
function getXmlSpaces() {
    let value = config.get(XmlSpacesName, "2");
    if (isNaN(parseInt(value))) {
        return value;
    }
    else {
        return parseInt(value);
    }
}
exports.getXmlSpaces = getXmlSpaces;
function getXmlClosingTagSpace() {
    return config.get(XmlClosingTagSpace, false);
}
exports.getXmlClosingTagSpace = getXmlClosingTagSpace;
function getWin32EncodingTable() {
    return config.get(Win32EncodingName, {
        "932": "Shift_JIS",
        "936": "GBK",
        "950": "BIG5"
    });
}
exports.getWin32EncodingTable = getWin32EncodingTable;
function getCreateTemplateFolderQuestion() {
    return config.get(CreateTemplateFolderQuestion, true);
}
exports.getCreateTemplateFolderQuestion = getCreateTemplateFolderQuestion;
exports.ICONS_THEME = "current-theme";
exports.ICONS_MIXED = "mix";
exports.ICONS_CUSTOM = "solution-explorer";
exports.SHOW_MODE_ACTIVITYBAR = "activityBar";
exports.SHOW_MODE_EXPLORER = "explorer";
exports.SHOW_MODE_NONE = "none";
//# sourceMappingURL=SolutionExplorerConfiguration.js.map