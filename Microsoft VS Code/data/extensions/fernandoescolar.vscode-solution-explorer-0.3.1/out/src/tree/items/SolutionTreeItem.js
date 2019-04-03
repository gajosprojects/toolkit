"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const TreeItem_1 = require("../TreeItem");
const TreeItemContext_1 = require("../TreeItemContext");
const ContextValues_1 = require("../ContextValues");
const Solutions_1 = require("../../model/Solutions");
const TreeItemFactory = require("../TreeItemFactory");
const events_1 = require("../../events");
class SolutionTreeItem extends TreeItem_1.TreeItem {
    constructor(context) {
        super(context, context.solution.Name, TreeItem_1.TreeItemCollapsibleState.Expanded, ContextValues_1.ContextValues.Solution, context.solution.FullPath);
        this.subscription = null;
        this.allowIconTheme = false;
        this.subscription = context.eventAggregator.subscribe(events_1.EventTypes.File, evt => this.onFileEvent(evt));
    }
    dispose() {
        this.subscription.dispose();
        this.subscription = null;
        super.dispose();
    }
    createChildren(childContext) {
        return TreeItemFactory.CreateItemsFromSolution(childContext, this.solution);
    }
    onFileEvent(event) {
        let fileEvent = event;
        if (fileEvent.path == this.solution.FullPath && fileEvent.fileEventType != events_1.FileEventType.Delete) {
            Solutions_1.SolutionFile.Parse(this.solution.FullPath).then(res => {
                this.context = new TreeItemContext_1.TreeItemContext(this.context.provider, res);
                this.refresh();
            });
        }
    }
}
exports.SolutionTreeItem = SolutionTreeItem;
//# sourceMappingURL=SolutionTreeItem.js.map