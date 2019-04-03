"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const StandardProjectTreeItem_1 = require("./StandardProjectTreeItem");
class DeployProjectTreeItem extends StandardProjectTreeItem_1.StandardProjectTreeItem {
    addContextValueSuffix() {
        this.contextValue += '-standard';
    }
}
exports.DeployProjectTreeItem = DeployProjectTreeItem;
//# sourceMappingURL=DeployProjectTreeItem.js.map