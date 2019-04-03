"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
class Handler {
    constructor(eventType, callback) {
        this.eventType = eventType;
        this.callback = callback;
    }
    handle(event) {
        if (event.eventType === this.eventType) {
            this.callback.call(null, event);
        }
    }
}
class EventAggregator {
    constructor() {
        this.eventHandlers = {};
    }
    publish(event) {
        if (!event) {
            throw new Error('Event type is invalid.');
        }
        setTimeout(() => {
            let handlers = this.eventHandlers[event.eventType];
            if (handlers) {
                handlers = handlers.slice();
                handlers.forEach(handler => {
                    handler.handle(event);
                });
            }
        }, 1);
    }
    subscribe(eventType, callback) {
        if (!eventType) {
            throw new Error('Event type was invalid.');
        }
        let handler = new Handler(eventType, callback);
        let subscribers = this.eventHandlers[eventType] || (this.eventHandlers[eventType] = []);
        subscribers.push(handler);
        return {
            dispose() {
                let idx = subscribers.indexOf(handler);
                if (idx !== -1) {
                    subscribers.splice(idx, 1);
                }
            }
        };
    }
    subscribeOnce(eventType, callback) {
        let sub = this.subscribe(eventType, (event) => {
            sub.dispose();
            return callback(event);
        });
        return sub;
    }
}
exports.EventAggregator = EventAggregator;
//# sourceMappingURL=EventAggregator.js.map