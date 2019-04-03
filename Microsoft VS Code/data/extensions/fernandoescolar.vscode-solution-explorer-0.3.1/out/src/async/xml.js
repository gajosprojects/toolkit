"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const xml2js = require("xml2js");
function ParseToJson(content) {
    return new Promise((resolve, reject) => {
        let parser = new xml2js.Parser();
        parser.parseString(content, function (err, result) {
            if (err)
                reject(err);
            resolve(result);
        });
    });
}
exports.ParseToJson = ParseToJson;
function ParseToXml(content) {
    let builder = new xml2js.Builder();
    return Promise.resolve(builder.buildObject(content));
}
exports.ParseToXml = ParseToXml;
//# sourceMappingURL=xml.js.map