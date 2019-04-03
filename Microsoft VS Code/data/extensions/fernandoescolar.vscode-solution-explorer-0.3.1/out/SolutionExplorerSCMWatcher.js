"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const vscode = require("vscode");
class SolutionExplorerSCMWatcher {
    constructor(eventAggregator) {
        this.eventAggregator = eventAggregator;
        vscode.scm;
    }
    register() {
    }
    unregister() {
    }
    raiseEvent(event) {
        console.log("Event[" + event.eventType + "] " + event.fileEventType + " - " + event.path);
        this.eventAggregator.publish(event);
    }
}
exports.SolutionExplorerSCMWatcher = SolutionExplorerSCMWatcher;
//# sourceMappingURL=SolutionExplorerSCMWatcher.js.map