"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const vscode_1 = require("vscode");
const events_1 = require("./events");
class SolutionExplorerFileWatcher {
    constructor(eventAggregator) {
        this.eventAggregator = eventAggregator;
    }
    register() {
        this.fileWatcher = vscode_1.workspace.createFileSystemWatcher("**/*");
        this.fileWatcher.onDidChange(uri => this.onChange(uri));
        this.fileWatcher.onDidCreate(uri => this.onCreate(uri));
        this.fileWatcher.onDidDelete(uri => this.onDelete(uri));
    }
    unregister() {
        this.fileWatcher.dispose();
        this.fileWatcher = null;
    }
    onChange(uri) {
        let event = new events_1.FileEvent(events_1.FileEventType.Modify, this.parseUri(uri));
        this.raiseEvent(event);
    }
    onCreate(uri) {
        let event = new events_1.FileEvent(events_1.FileEventType.Create, this.parseUri(uri));
        this.raiseEvent(event);
    }
    onDelete(uri) {
        let event = new events_1.FileEvent(events_1.FileEventType.Delete, this.parseUri(uri));
        this.raiseEvent(event);
    }
    raiseEvent(event) {
        console.log("Event[" + event.eventType + "] " + event.fileEventType + " - " + event.path);
        this.eventAggregator.publish(event);
    }
    parseUri(uri) {
        return uri.fsPath;
    }
}
exports.SolutionExplorerFileWatcher = SolutionExplorerFileWatcher;
//# sourceMappingURL=SolutionExplorerFileWatcher.js.map