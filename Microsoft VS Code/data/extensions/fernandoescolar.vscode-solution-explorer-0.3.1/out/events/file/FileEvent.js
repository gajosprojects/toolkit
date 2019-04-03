"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const EventTypes_1 = require("../EventTypes");
class FileEvent {
    constructor(fileEventType, path) {
        this.fileEventType = fileEventType;
        this.path = path;
    }
    get eventType() {
        return EventTypes_1.EventTypes.File;
    }
}
exports.FileEvent = FileEvent;
//# sourceMappingURL=FileEvent.js.map