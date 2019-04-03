"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const vscode_1 = require("vscode");
const events_1 = require("./events");
const SolutionExplorerConfiguration = require("./SolutionExplorerConfiguration");
class SolutionExplorerOutputChannel {
    constructor(eventAggregator) {
        this.eventAggregator = eventAggregator;
    }
    register() {
        this.shouldShow = SolutionExplorerConfiguration.getShowOutputChannel();
        if (!this.shouldShow)
            return;
        this.outputChannel = vscode_1.window.createOutputChannel('Solution Explorer');
        this.subscription = this.eventAggregator.subscribe(events_1.EventTypes.Log, e => this.onEventHandled(e));
    }
    unregister() {
        if (this.outputChannel)
            this.outputChannel.dispose();
        if (this.subscription)
            this.subscription.dispose();
        this.outputChannel = null;
        this.subscription = null;
    }
    onEventHandled(event) {
        if (!this.shouldShow)
            return;
        let logEvent = event;
        if (logEvent.logEventType == events_1.LogEventType.Clear)
            this.outputChannel.clear();
        if (logEvent.logEventType == events_1.LogEventType.Append) {
            this.outputChannel.appendLine(logEvent.text);
            this.outputChannel.show();
        }
    }
}
exports.SolutionExplorerOutputChannel = SolutionExplorerOutputChannel;
//# sourceMappingURL=SolutionExplorerOutputChannel.js.map