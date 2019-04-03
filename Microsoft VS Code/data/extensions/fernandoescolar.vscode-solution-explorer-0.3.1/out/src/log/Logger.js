"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const vscode_1 = require("vscode");
const events_1 = require("../events");
class Logger {
    constructor(eventAggregator) {
        this.eventAggregator = eventAggregator;
    }
    log(text) {
        let event = new events_1.LogEvent(events_1.LogEventType.Append, text);
        this.eventAggregator.publish(event);
    }
    info(text) {
        this.log("info: " + text);
        vscode_1.window.showInformationMessage(text);
    }
    error(text) {
        this.log("error: " + text);
        vscode_1.window.showErrorMessage(text);
    }
    warn(text) {
        this.log("warning: " + text);
        vscode_1.window.showWarningMessage(text);
    }
}
exports.Logger = Logger;
//# sourceMappingURL=Logger.js.map