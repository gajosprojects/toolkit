# vscode-solution-explorer

This extension adds a Visual Studio Solution File explorer panel in Visual Studio Code. Now you can navigate into your solution following the original Visual Studio structure.

## Features

Adds a Solution Explorer panel where you can find a Visual Studio Solution File Explorer.

- Can load any .sln version

- Supports csproj, vcxproj, fsproj and vbproj (from vs2017 and before)

- Supports dotnet core projects

- You can create, delete, rename or move project folders and files.

- You can create, delete, rename or move solution, solution folders and projects.

- You can add or remove packages and references when the project is of kind CPS (dotnet core).

![Solution Explorer](https://github.com/fernandoescolar/vscode-solution-explorer/raw/master/images/vscode-solution-explorer-1.gif)

![Solution Explorer](https://github.com/fernandoescolar/vscode-solution-explorer/raw/master/images/vscode-solution-explorer-2.gif)

![Solution Explorer](https://github.com/fernandoescolar/vscode-solution-explorer/raw/master/images/vscode-solution-explorer-3.gif)

## Requirements

You have to open a folder with at least one solution file (".sln") in the root path.

Or you can create a new one by clicking with the rigth mouse button.

## License

The source code is licensed under the [CC-BY-SA](https://github.com/fernandoescolar/vscode-solution-explorer/blob/master/LICENSE.md) license.

The icons from ([vscode-icons extension](https://github.com/vscode-icons/vscode-icons/)) are licensed under the [Creative Commons - ShareAlike (CC BY-SA)](https://creativecommons.org/licenses/by-sa/4.0/) license. 

Branded icons are licensed under their copyright license.

## Extension Settings

- `vssolution.showMode` Show the solution explorer in the "activityBar", in the "explorer" pane or "none" to hide it. This feature is only for testing pourposes.

- `vssolution.solutionExplorerIcons` "solution-explorer": custom items from vscode-solution-explorer extension. "mix": file and folder icons from the installed icons theme. "current-theme": all the icons are from the installed icons theme.

- `vssolution.showOutputChannel` Show the solution explorer output channel.

- `vssolution.trackActiveItem` Select the active editor file in the solution explorer (not recomended).

- `vssolution.netcoreIgnore` Folder and file names to ignore when get a dotnet core project content.

- `vssolution.xxprojItemTypes` Type of XML element to put in the xxproj files.

- `vssolution.xmlspaces` Spaces to be used for indenting XML output. It could be a number or an string. ex. "2", " " or "t".

- `vssolution.altSolutionFolders` If there is no solution in the workplace root folder, it will search for solutions in any of these folders.

- `vssolution.win32Encoding` Win32 "codepage" to "iconv.js" encoding equivalences.

###### Example

```javascript
{
    "vssolution.showMode": "activityBar",

    "vssolution.solutionExplorerIcons": "current-theme",

    "vssolution.showOutputChannel": true,

    "vssolution.trackActiveItem": false,

    "vssolution.netcoreIgnore": [
        "bin",
        "node_modules",
        "obj",
        ".ds_store"
    ],

    "vssolution.xxprojItemTypes": {
        "*": "Content",
        "cs": "Compile",
        "cpp": "ClCompile",
        "cc": "ClCompile",
        "c": "ClCompile",
        "h": "ClInclude",
        "hpp": "ClInclude",
        "vb": "Compile",
        "fs": "Compile",
        "ts": "TypeScriptCompile"
    },

    "vssolution.xmlspaces": "2",

    "vssolution.altSolutionFolders": [
        "src"
    ],

    "vssolution.win32Encoding": {
        "932": "Shift_JIS",
        "936": "GBK",
        "950": "BIG5"
    }
}
```

## Known Issues

Please report your issues: [vscode-solution-explorer GitHub page](https://github.com/fernandoescolar/vscode-solution-explorer/issues)

## Release Notes

There is a lot of work to do.

### 0.3.1

Bug fixed: Create new file, project and solution command issues.

New Feature #61: Now solution file items are shown.

### 0.3.0

Bug fixed #51: Updated license to CC-BY-SA.

Bug fixed #49: Modify default 'showMode' and 'trackActiveItem' configuration setting values.

New comand parameter compiler adding a wizard style requesting commad parameters.

Bug fixed #48: now you can specify the package version when adding a new nuget package to a project.

Bug fixed #55: changed message to create a new solution.

Bug fixed #53: deleted test button from solution level.

Bug fixed #42: added the solution/project path in dotnet commads.

Bug fixed #54: launch dotnet commands in terminal.

PR #46: Add an option to disable the question about creating the solution template folder - by [remcoros](https://github.com/remcoros).

PR #56: Properly handle project files with paths outside the project root - by [mwpenny](https://github.com/mwpenny)

PR #58: Add support for C/C++ projects (.vcxproj; issue #19) - by [mwpenny](https://github.com/mwpenny)

### 0.2.34

Added "win32Encoding" configuration parameter to help people fixing win32 encoding problems in the output.

Bug fixed #36: chinese encoding problem. Thanks to [darkmfj](https://github.com/darkmfj).

Feature #23: Added .njsproj project support.

## Thanks to contributors

[dfrencham](https://github.com/dfrencham)
[darkmfj](https://github.com/darkmfj)
[remcoros](https://github.com/remcoros)
[mwpenny](https://github.com/mwpenny)

**Enjoy!**
