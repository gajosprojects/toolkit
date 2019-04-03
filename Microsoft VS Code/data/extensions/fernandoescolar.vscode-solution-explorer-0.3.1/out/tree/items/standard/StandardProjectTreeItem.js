"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const ProjectTreeItem_1 = require("../ProjectTreeItem");
const index_1 = require("../../../events/index");
class StandardProjectTreeItem extends ProjectTreeItem_1.ProjectTreeItem {
    constructor(context, projectInSolution) {
        super(context, projectInSolution);
        this.subscription = null;
        this.subscription = context.eventAggregator.subscribe(index_1.EventTypes.File, evt => this.onFileEvent(evt));
    }
    dispose() {
        this.subscription.dispose();
        this.subscription = null;
        super.dispose();
    }
    shouldHandleFileEvent(fileEvent) {
        return fileEvent.path == this.path;
    }
    onFileEvent(event) {
        let fileEvent = event;
        if (this.shouldHandleFileEvent(fileEvent)) {
            this.project.refresh().then(res => {
                this.refresh();
            });
        }
    }
}
exports.StandardProjectTreeItem = StandardProjectTreeItem;
//# sourceMappingURL=StandardProjectTreeItem.js.map