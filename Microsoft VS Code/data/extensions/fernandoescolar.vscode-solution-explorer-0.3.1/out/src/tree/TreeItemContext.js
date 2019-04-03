"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
class TreeItemContext {
    constructor(provider, solution, project, parent) {
        this.provider = provider;
        this.solution = solution;
        this.project = project;
        this.parent = parent;
    }
    get eventAggregator() {
        return this.provider.eventAggregator;
    }
    copy(project, parent) {
        return new TreeItemContext(this.provider, this.solution, project ? project : this.project, parent ? parent : this.parent);
    }
}
exports.TreeItemContext = TreeItemContext;
//# sourceMappingURL=TreeItemContext.js.map