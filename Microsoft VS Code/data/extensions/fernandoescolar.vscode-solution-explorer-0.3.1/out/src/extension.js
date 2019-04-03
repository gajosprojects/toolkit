'use strict';
Object.defineProperty(exports, "__esModule", { value: true });
const vscode = require("vscode");
const events_1 = require("./events");
const SolutionExplorerProvider_1 = require("./SolutionExplorerProvider");
const SolutionExplorerCommands_1 = require("./SolutionExplorerCommands");
const SolutionExplorerFileWatcher_1 = require("./SolutionExplorerFileWatcher");
const SolutionExplorerConfiguration = require("./SolutionExplorerConfiguration");
const SolutionExplorerOutputChannel_1 = require("./SolutionExplorerOutputChannel");
var eventAggregator, solutionExplorerProvider, solutionExplorerCommands, solutionExplorerFileWatcher, solutionExplorerOutputChannel;
function activate(context) {
    const rootPath = vscode.workspace.rootPath;
    eventAggregator = new events_1.EventAggregator();
    solutionExplorerProvider = new SolutionExplorerProvider_1.SolutionExplorerProvider(rootPath, eventAggregator);
    solutionExplorerCommands = new SolutionExplorerCommands_1.SolutionExplorerCommands(context, solutionExplorerProvider);
    solutionExplorerFileWatcher = new SolutionExplorerFileWatcher_1.SolutionExplorerFileWatcher(eventAggregator);
    solutionExplorerOutputChannel = new SolutionExplorerOutputChannel_1.SolutionExplorerOutputChannel(eventAggregator);
    SolutionExplorerConfiguration.register();
    solutionExplorerProvider.register();
    solutionExplorerCommands.register();
    solutionExplorerFileWatcher.register();
    solutionExplorerOutputChannel.register();
}
exports.activate = activate;
function deactivate() {
    solutionExplorerProvider.unregister();
    solutionExplorerFileWatcher.unregister();
    solutionExplorerOutputChannel.unregister();
}
exports.deactivate = deactivate;
//# sourceMappingURL=extension.js.map