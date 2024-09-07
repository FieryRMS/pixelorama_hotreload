# Hot Reload projects in Pixelorama

This extensions allows you to hot reload your projects in Pixelorama. It's useful for when you're working on a project and want to see the changes you made in an external program inside Pixelorama.

## How to install

1. Get the `hotreload.pck` file from the releases page. Or package it yourself following the [guide by Pixelorama](https://www.oramainteractive.com/Pixelorama-Docs/extension_system/extension_basics/#exporting-the-extension).

2. Open Pixelorama and go to `Edit > Preferences > Extensions > Add Extension` then select the `hotreload.pck` file.

3. Select the `Hot Reload` extension and click on `Enable` button.

4. You should now have a new option under the `File` menu `Hot Reload OFF for this project`.

## How to use

Hot reloading is off by default for any newly opened project. You can turn it on by clicking the `Hot Reload OFF for this project` option in the `File` menu which will only enable for the currently opened project. The file that will be watched is the same as the quick export file with `Ctrl + E`. Any changes made to this file will update the project in Pixelorama. These changes are undoable.

This extension looks at the `last modified` attribute of the file and compares it to the last time it was checked. It checks this every frame. If the file was modified since the last check, it will overwrite the current layer of the current frame of the project with the new image.
