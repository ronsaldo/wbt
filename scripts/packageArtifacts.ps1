$ErrorActionPreference = "Stop"

$DIST = "artifacts/dist/win64/"

New-Item -Path "$DIST/module-sources" -ItemType "directory"
foreach($element in "pharo-vm",
    "README.md", "LICENSE",
    "Pharo*.sources", "wbt.image", "wbt.changes",
    "wbt.bat", "wbt-ui.bat"
) {
    Copy-Item -Recurse -Path "$element" -Destination "$DIST"
}

