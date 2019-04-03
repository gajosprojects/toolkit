"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const CommandBase_1 = require("./base/CommandBase");
class RefreshCommand extends CommandBase_1.CommandBase {
    constructor(provider) {
        super();
        this.provider = provider;
    }
    shouldRun(item) {
        return true;
    }
    runCommand(item, args) {
        if (item) {
            item.refresh();
            this.provider.logger.log("Refreshed " + item.path);
        }
        else {
            this.provider.refresh();
            this.provider.logger.log("Refreshed");
        }
        return Promise.resolve();
    }
}
exports.RefreshCommand = RefreshCommand;
//# sourceMappingURL=RefreshCommand.js.map