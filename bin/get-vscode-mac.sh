# get Visual Studio Code for Mac
pushd ~/Downloads
wget 'https://code.visualstudio.com/sha/download?build=stable&os=cli-darwin-x64' -O vscode_cli_darwin_x64_cli.zip
wget 'https://code.visualstudio.com/sha/download?build=stable&os=darwin-universal' -O VSCode-darwin-universal.zip
unzip vscode_cli_darwin_x64_cli.zip
unzip VSCode-darwin-universal.zip
cp code /usr/local/bin/
cp -R 'Visual Studio Code.app' /Applications/
