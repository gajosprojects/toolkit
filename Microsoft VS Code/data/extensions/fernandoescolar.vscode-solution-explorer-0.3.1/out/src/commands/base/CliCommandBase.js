"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const path = require("path");
const child_process_1 = require("child_process");
const CommandBase_1 = require("./CommandBase");
class CliCommandBase extends CommandBase_1.CommandBase {
    constructor(provider, app) {
        super();
        this.provider = provider;
        this.app = app;
    }
    runCommand(item, args) {
        let workingFolder = this.getWorkingFolder(item);
        return this.runCliCommand(this.app, args, workingFolder);
    }
    runCliCommand(app, args, path) {
        this.provider.logger.log('Cli: ' + [app, ...args].join(' '));
        return new Promise(resolve => {
            let process = child_process_1.spawn(app, args, { cwd: path });
            process.stdout.on('data', (data) => {
                this.provider.logger.log(data);
            });
            process.stderr.on('data', (data) => {
                this.provider.logger.error(data);
            });
            process.on('exit', (code) => {
                this.provider.logger.log('End Cli');
                resolve();
            });
        });
    }
    getWorkingFolder(item) {
        if (item.path)
            return path.dirname(item.path);
        if (item.project)
            return path.dirname(item.project.fullPath);
        if (item.solution)
            return item.solution.FolderPath;
        return null;
    }
}
exports.CliCommandBase = CliCommandBase;
//# sourceMappingURL=CliCommandBase.js.map