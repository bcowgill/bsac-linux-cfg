# oh-my-git-aliases.sh
# How to use these aliases:
# http://mjk.space/git-aliases-i-cant-live-without/

# Source:
# https://github.com/mjkonarski/oh-my-git-aliases/raw/master/oh-my-git-aliases.sh

# Place the below into your .bashrc or appropriate shell config file
# if [ -f ~/oh-my-git-aliases.sh ]; then
#     . ~/oh-my-git-aliases.sh
# fi

alias g='git'

alias gst='g status'

alias gfe='g fetch'
alias gfea='gfe --all' # BSAC

alias gco='g checkout'
alias gcd='gco develop'
alias gcm='gco master'

alias gpb='ggpush'
alias ggpush='g push origin $(current_branch)'
alias ggpushf='ggpush --force-with-lease origin $(current_branch)'
alias ggpusht='g push origin --tags'

alias gc='g commit' # clashes with gc command
alias gc!='gc --amend'
alias gca='gc -a'
alias gca!='gca --amend'

alias gl='g pull'
alias glr='gl --rebase'
alias glff='gl --ff-only'

alias gm='g merge'
alias gma='gm --abort' # BSAC
alias gmff='gm --ff-only'
alias gmnff='gm --no-ff'
alias gmt='g mergetool' # BSAC

alias ga='g add'
alias gap='ga --patch'
alias gai='ga -i'

alias gb='g branch'
alias gba='gb -a'
alias gbl='gb --list' # BSAC
alias gblr='gb --list --remote' # BSAC

alias ggr='g grep'

alias grb='g rebase'
alias grbi='grb --interactive'
alias grbiod='grbi origin/develop'
alias grbiom='grbi origin/master'
alias grbc='grb --continue'
alias grba='grb --abort'
alias grbs='grb --skip' # BSAC

alias gt='g tag'

alias gre='g reset'
alias greh='gre --hard'
alias ggrh='greh @{u}'

grf() {
        gre @~ "$@" && gc! --no-edit
}

alias gd='g diff'
alias gdc='gd --cached'
alias gdo='gd origin/$(current_branch) $(current_branch)'
alias gdt='g difftool --no-prompt --ignore-all-space' # BSAC

alias gcp='g cherry-pick'
alias gcpa='gcp --abort'
alias gcpc='gcp --continue'

alias gsta='g stash'
alias gsts='gsta show --text'
alias gstp='gsta pop'
alias gstd='gsta drop'
alias gstaa='gsta apply' # BSAC
alias gdrop='gsta save crap; gstd' # BSAC

alias gcl='g clone'

alias gr='g remote'

alias glog='g log --oneline --graph --decorate --all' # BSAC

alias ggraph='glog --simplify-by-decoration' # BSAC
#alias ggraph='g graph --simplify-by-decoration' # BSAC

# https://github.com/robbyrussell/oh-my-zsh
function current_branch() {
  ref=$(git symbolic-ref HEAD 2> /dev/null) || \
  ref=$(git rev-parse --short HEAD 2> /dev/null) || return
  echo ${ref#refs/heads/}
}
