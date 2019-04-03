"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
function Promisify(target, args, context, resolver) {
    return new Promise((resolve, reject) => {
        target.apply(context, Array.prototype.slice.call(args).concat([(err, result) => {
                if (err)
                    reject(err);
                else if (resolver)
                    resolve(resolver.apply(context, arguments));
                else
                    resolve(result);
            }]));
    });
}
exports.Promisify = Promisify;
//# sourceMappingURL=Promisify.js.map