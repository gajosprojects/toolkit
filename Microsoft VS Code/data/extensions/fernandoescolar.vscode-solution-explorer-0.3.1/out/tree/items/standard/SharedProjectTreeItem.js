"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const StandardProjectTreeItem_1 = require("./StandardProjectTreeItem");
class SharedProjectTreeItem extends StandardProjectTreeItem_1.StandardProjectTreeItem {
    shouldHandleFileEvent(fileEvent) {
        let path = this.path.replace(".shproj", ".projitems");
        return fileEvent.path == path;
    }
    addContextValueSuffix() {
        this.contextValue += '-standard';
    }
}
exports.SharedProjectTreeItem = SharedProjectTreeItem;
//# sourceMappingURL=SharedProjectTreeItem.js.map