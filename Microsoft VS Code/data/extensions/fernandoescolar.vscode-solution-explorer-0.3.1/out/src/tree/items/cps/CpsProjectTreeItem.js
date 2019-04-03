"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const path = require("path");
const ProjectTreeItem_1 = require("../ProjectTreeItem");
const index_1 = require("../../../events/index");
class CpsProjectTreeItem extends ProjectTreeItem_1.ProjectTreeItem {
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
    onFileEvent(event) {
        let fileEvent = event;
        let workingdir = path.dirname(this.path);
        let dirname = path.dirname(fileEvent.path);
        if (fileEvent.path == this.path) {
            this.project.refresh().then(res => {
                this.refresh();
            });
        }
        else if (dirname.startsWith(workingdir)) {
            this.refresh();
        }
    }
}
exports.CpsProjectTreeItem = CpsProjectTreeItem;
//# sourceMappingURL=CpsProjectTreeItem.js.map