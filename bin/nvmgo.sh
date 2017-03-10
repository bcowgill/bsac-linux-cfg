#BSAC Node version manager allows you to have multiple versions of nodejs
export NVM_DIR="$HOME/.nvm"
if [ -s "$NVM_DIR/nvm.sh" ]; then
    . "$NVM_DIR/nvm.sh"
    [[ -r $NVM_DIR/bash_completion ]] && . $NVM_DIR/bash_completion
    # nvm ls
    # nvm ls-remote
    if [ -e "$HOME/.nvmrc" ]; then
        nvm use > /dev/null
    else
        nvm use v6.9.2 > /dev/null
    fi
fi

