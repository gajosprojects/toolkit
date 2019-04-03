"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const path = require("path");
const os = require("os");
const vscode = require("vscode");
const child_process_1 = require("child_process");
const tree_1 = require("../../tree");
const CommandBase_1 = require("./CommandBase");
const iconv = require("iconv-lite");
const configuration = require("../../SolutionExplorerConfiguration");
const TERMINAL_NAME = "dotnet";
class CliCommandBase extends CommandBase_1.CommandBase {
    constructor(title, provider, app) {
        super(title);
        this.provider = provider;
        this.app = app;
        this.codepage = "65001";
    }
    runCommand(item, args) {
        let workingFolder = this.getWorkingFolder(item);
        return this.runCliCommand(this.app, args, workingFolder);
    }
    runCliCommand(app, args, path) {
        this.checkCurrentEncoding();
        const terminal = this.ensureTerminal();
        let cargs = Array(args.length);
        args.forEach((a, index) => cargs[index] = '"' + a + '"');
        terminal.sendText([app, ...cargs].join(' '), true);
        // this.provider.logger.log('Terminal: ' + [ app, ...args ].join(' '));
        terminal.show();
        return Promise.resolve();
    }
    getWorkingFolder(item) {
        if (item && item.path && item.contextValue !== tree_1.ContextValues.ProjectReferencedPackage)
            return path.dirname(item.path);
        if (item && item.project)
            return path.dirname(item.project.fullPath);
        if (item && item.solution)
            return item.solution.FolderPath;
        return vscode.workspace.rootPath;
    }
    checkCurrentEncoding() {
        if (os.platform() === "win32") {
            this.codepage = child_process_1.execSync('chcp').toString().split(':').pop().trim();
        }
    }
    decode(data) {
        var encodings = configuration.getWin32EncodingTable();
        var keys = Object.keys(encodings);
        for (let i = 0; i < keys.length; i++) {
            if (keys[i] === this.codepage) {
                return iconv.decode(data, encodings[keys[i]]);
            }
        }
        return data.toString();
    }
    ensureTerminal() {
        let terminal;
        vscode.window.terminals.forEach(t => { if (t.name === TERMINAL_NAME)
            terminal = t; });
        if (!terminal) {
            terminal = vscode.window.createTerminal(TERMINAL_NAME);
        }
        return terminal;
    }
}
exports.CliCommandBase = CliCommandBase;
//# sourceMappingURL=CliCommandBase.js.map