$ErrorActionPreference = "Stop"

.\pharo-vm\PharoConsole.exe "$pwd\wbt.image" test --junit-xml-output --stage-name="WBT" --stage-name="WBT" "WBT*"

$DIST = "artifacts/test-results/win64"
New-Item -Path "$DIST" -ItemType "directory"
Copy-Item -Path "*.xml" -Destination "$DIST"
