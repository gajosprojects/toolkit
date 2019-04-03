/*---------------------------------------------------------------------------------------------
*  Copyright (c) Alessandro Fragnani. All rights reserved.
*  Licensed under the MIT License. See License.md in the project root for license information.
*--------------------------------------------------------------------------------------------*/
'use strict';
Object.defineProperty(exports, "__esModule", { value: true });
const vscode = require("vscode");
const formatter = require("./formatter");
const fs = require("fs");
const path = require("path");
const cp = require("child_process");
var opener = require('opener');
const Manager_1 = require("../vscode-whats-new/src/Manager");
const PascalFormatterContentProvider_1 = require("./whats-new/PascalFormatterContentProvider");
const documentSelector = [
    { language: 'pascal', scheme: 'file' },
    { language: 'pascal', scheme: 'untitled' },
    { language: 'objectpascal', scheme: 'file' },
    { language: 'objectpascal', scheme: 'untitled' }
];
// this method is called when your extension is activated
// your extension is activated the very first time the command is executed
function activate(context) {
    // interface EngineParams {
    //     engine: string;
    //     enginePath: string;
    //     engineParameters: string;
    //     formatIndent: number;
    //     formatWrapLineLength: number;
    // }
    // Use the console to output diagnostic information (console.log) and errors (console.error)
    // This line of code will only be executed once when your extension is activated
    // console.log('Congratulations, your extension "vscode-pascal-formatter" is now active!');
    let provider = new PascalFormatterContentProvider_1.WhatsNewPascalFormatterContentProvider();
    let viewer = new Manager_1.WhatsNewManager(context).registerContentProvider("pascal-formatter", provider);
    viewer.showPageInActivation();
    context.subscriptions.push(vscode.commands.registerCommand('pascalFormatter.whatsNew', () => viewer.showPage()));
    //
    vscode.commands.registerCommand('pascalFormatter.editFormatterParameters', () => {
        checkEngineDefined()
            .then((engineType) => {
            checkEngineParametersDefined(engineType.toString())
                .then((engineParameters) => {
                let engineParametersFile = engineParameters['engineParameters'];
                if (engineParametersFile === '') {
                    var optionGenerate = {
                        title: "Generate"
                    };
                    vscode.window.showErrorMessage('The \"pascal.formatter.engineParameters\" setting is not defined. Would you like to generate the default?', optionGenerate).then(option => {
                        // nothing selected
                        if (typeof option === 'undefined') {
                            return;
                        }
                        if (option.title === "Generate") {
                            engineParametersFile = generateDefaultEngineParameters(engineParameters['engine'], engineParameters['enginePath']);
                            vscode.workspace.openTextDocument(engineParametersFile).then(doc => {
                                vscode.window.showTextDocument(doc);
                            });
                        }
                        else {
                            return;
                        }
                    });
                }
                else {
                    vscode.workspace.openTextDocument(engineParametersFile).then(doc => {
                        vscode.window.showTextDocument(doc);
                    });
                }
            })
                .catch((error) => {
                vscode.window.showErrorMessage(error);
            });
        })
            .catch((error) => {
            //reject(error);
            vscode.window.setStatusBarMessage('checkEngineDefined: ' + error, 5000);
        });
        function generateDefaultEngineParameters(engine, enginePath) {
            let configFileName;
            if (engine === 'ptop') { // can be anyfilename.cfg
                configFileName = path.basename(enginePath, path.extname(enginePath)) + '.cfg';
                configFileName = path.join(path.dirname(enginePath), configFileName);
                let command = "\"" + enginePath + "\" -g " + configFileName;
                cp.exec(command);
            }
            else { // jcf -> must be JCFSettings.cfg
                configFileName = path.join(path.dirname(enginePath), 'JCFSettings.cfg');
                let jsonFile = fs.readFileSync(context.asAbsolutePath('jcfsettings.json'), 'UTF8');
                let xml = JSON.parse(jsonFile);
                console.log(xml.defaultConfig.join('\n'));
                fs.writeFileSync(configFileName, xml.defaultConfig.join('\n'));
            }
            return configFileName;
        }
    });
    context.subscriptions.push(vscode.languages.registerDocumentFormattingEditProvider(documentSelector, {
        provideDocumentFormattingEdits: (document, options) => {
            return new Promise((resolve, reject) => {
                checkEngineDefined()
                    .then((engineType) => {
                    checkEngineParametersDefined(engineType.toString())
                        .then((engineParameters) => {
                        let f;
                        f = new formatter.Formatter(document, options);
                        let range;
                        range = new vscode.Range(0, 0, document.lineCount, document.lineAt(document.lineCount - 1).range.end.character);
                        f.format(range, engineParameters['engine'], engineParameters['enginePath'], engineParameters['engineParameters'], engineParameters['formatIndent'], engineParameters['formatWrapLineLength'])
                            .then((formattedXml) => {
                            resolve([new vscode.TextEdit(range, formattedXml.toString())]);
                        })
                            .catch((error) => {
                            console.log('format: ' + error);
                            vscode.window.showErrorMessage('Error while formatting: ' + error);
                        });
                    })
                        .catch((error) => {
                        //vscode.window.setStatusBarMessage('checkEngineParametersDefined: ' + error, 5000);
                        vscode.window.showErrorMessage(error);
                    });
                })
                    .catch((error) => {
                    //reject(error);
                    vscode.window.setStatusBarMessage('checkEngineDefined: ' + error, 5000);
                });
            });
        }
    }));
    context.subscriptions.push(vscode.languages.registerDocumentRangeFormattingEditProvider(documentSelector, {
        provideDocumentRangeFormattingEdits: (document, range, options) => {
            return new Promise((resolve, reject) => {
                checkEngineDefined()
                    .then((engineType) => {
                    if (!engineSupportsRange(engineType.toString(), document, range)) {
                        reject('The selected engine \"' + engineType.toString() + '\" does not support selection.');
                        return;
                    }
                    checkEngineParametersDefined(engineType.toString())
                        .then((engineParameters) => {
                        let f;
                        f = new formatter.Formatter(document, options);
                        f.format(range, engineParameters['engine'], engineParameters['enginePath'], engineParameters['engineParameters'], engineParameters['formatIndent'], engineParameters['formatWrapLineLength'])
                            .then((formattedXml) => {
                            resolve([new vscode.TextEdit(range, formattedXml.toString())]);
                        })
                            .catch((error) => {
                            console.log('format: ' + error);
                            vscode.window.showErrorMessage('Error while formatting: ' + error);
                        });
                    })
                        .catch((error) => {
                        //vscode.window.setStatusBarMessage('checkEngineParametersDefined: ' + error, 5000);
                        vscode.window.showErrorMessage(error);
                    });
                })
                    .catch((error) => {
                    //reject(error);
                    vscode.window.setStatusBarMessage('checkEngineDefined: ' + error, 5000);
                });
            });
        }
    }));
    //
    function checkEngineDefined() {
        return new Promise((resolve, reject) => {
            let engineType = vscode.workspace.getConfiguration('pascal').get('formatter.engine', '');
            if (engineType === '') {
                var optionJCF = {
                    title: "Jedi Code Format"
                };
                var optionPTOP = {
                    title: "FreePascal PtoP"
                };
                vscode.window.showErrorMessage('The \"pascal.formatter.engine\" setting is not defined. Do you want to download some formatter tool first?', optionJCF, optionPTOP).then(option => {
                    // nothing selected
                    if (typeof option === 'undefined') {
                        reject('undefined');
                        return;
                    }
                    switch (option.title) {
                        case optionJCF.title:
                            opener('http://jedicodeformat.sourceforge.net/');
                            break;
                        case optionPTOP.title:
                            opener('http://www.freepascal.org/tools/ptop.var');
                            break;
                        default:
                            break;
                    }
                    reject('hyperlink');
                });
            }
            else {
                resolve(engineType);
            }
        });
    }
    function checkEngineParametersDefined(engine) {
        return new Promise((resolve, reject) => {
            let enginePath = vscode.workspace.getConfiguration('pascal').get('formatter.enginePath', '');
            if (enginePath == '') {
                reject('The \"pascal.formatter.enginePath\" setting is not defined. Please configure.');
                return;
            }
            let engineParameters = vscode.workspace.getConfiguration('pascal').get('formatter.engineParameters', '');
            let formatIndent = vscode.workspace.getConfiguration('pascal').get('format.indent', 0);
            let formatWrapLineLength = vscode.workspace.getConfiguration('pascal').get('format.wrapLineLength', 0);
            resolve({
                'engine': engine,
                'enginePath': enginePath,
                'engineParameters': engineParameters,
                'formatIndent': formatIndent,
                'formatWrapLineLength': formatWrapLineLength
            });
        });
    }
    function engineSupportsRange(engine, document, range) {
        if (engine === 'ptop') {
            return true;
        }
        else { // jcf
            return (range.start.character === 0) &&
                (range.start.line === 0) &&
                (range.end.line === document.lineCount - 1) &&
                (range.end.character === document.lineAt(document.lineCount - 1).range.end.character);
        }
    }
}
exports.activate = activate;
// this method is called when your extension is deactivated
function deactivate() {
}
exports.deactivate = deactivate;
//# sourceMappingURL=extension.js.map