"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const EventTypes_1 = require("../EventTypes");
class LogEvent {
    constructor(logEventType, text) {
        this.logEventType = logEventType;
        this.text = text;
    }
    get eventType() {
        return EventTypes_1.EventTypes.Log;
    }
}
exports.LogEvent = LogEvent;
//# sourceMappingURL=LogEvent.js.map