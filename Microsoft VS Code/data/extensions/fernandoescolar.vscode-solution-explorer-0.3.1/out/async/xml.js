"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const convert = require("xml-js");
const config = require("../SolutionExplorerConfiguration");
const readOptions = {
    compact: false
};
const writeOptions = {
    compact: false,
    spaces: 2
};
function ParseToJson(content) {
    let result = convert.xml2js(content, readOptions);
    if (result.declaration) {
        delete result.declaration;
    }
    return Promise.resolve(result);
}
exports.ParseToJson = ParseToJson;
function ParseToXml(content) {
    writeOptions.spaces = config.getXmlSpaces();
    let result = convert.js2xml(content, writeOptions);
    if (config.getXmlClosingTagSpace()) {
        let re = /([A-Za-z0-9_\"]+)\/\>/g;
        result = result.replace(re, "$1 />");
    }
    return Promise.resolve(result);
}
exports.ParseToXml = ParseToXml;
//# sourceMappingURL=xml.js.map