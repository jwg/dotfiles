### bashrc for OS X and GNU/Linux
### https://github.com/jwg/dotfiles
###
### Inspired by:
### - https://github.com/cactus/dotconfigs
### - ubuntu/debian default bashrc

# don't do anything for non-interactive shell
[ -z "$PS1" ] && return

# load local env vars from .bashrc.pre
[ -f $HOME/.bashrc.pre ] && . $HOME/.bashrc.pre

# detect os type
export OS=$(uname -s)

###
### functions
###

# fallback if function isn't provided by bash-completion
__git_ps1() {
  ref=$(git symbolic-ref -q HEAD 2> /dev/null) || return
  printf "${1:- (%s)}" "${ref#refs/heads/}"
}

set_bash_prompt() {
  ## set some color variables to make things a bit easier to read later
  local TXTBLK='\e[0;30m' # Black - Regular
  local TXTRED='\e[0;31m' # Red
  local TXTGRN='\e[0;32m' # Green
  local TXTYLW='\e[0;33m' # Yellow
  local TXTBLU='\e[0;34m' # Blue
  local TXTPUR='\e[0;35m' # Purple
  local TXTCYN='\e[0;36m' # Cyan
  local TXTWHT='\e[0;37m' # White
  local BLDBLK='\e[1;30m' # Black - Bold
  local BLDRED='\e[1;31m' # Red
  local BLDGRN='\e[1;32m' # Green
  local BLDYLW='\e[1;33m' # Yellow
  local BLDBLU='\e[1;34m' # Blue
  local BLDPUR='\e[1;35m' # Purple
  local BLDCYN='\e[1;36m' # Cyan
  local BLDWHT='\e[1;37m' # White
  local UNDBLK='\e[4;30m' # Black - Underline
  local UNDRED='\e[4;31m' # Red
  local UNDGRN='\e[4;32m' # Green
  local UNDYLW='\e[4;33m' # Yellow
  local UNDBLU='\e[4;34m' # Blue
  local UNDPUR='\e[4;35m' # Purple
  local UNDCYN='\e[4;36m' # Cyan
  local UNDWHT='\e[4;37m' # White
  local BAKBLK='\e[40m' # Black - Background
  local BAKRED='\e[41m' # Red - Background
  local BAKGRN='\e[42m' # Green - Background
  local BAKYLW='\e[43m' # Yellow - Background
  local BAKBLU='\e[44m' # Blue - Background
  local BAKPUR='\e[45m' # Purple - Background
  local BAKCYN='\e[46m' # Cyan - Background
  local BAKWHT='\e[47m' # White - Background
  local TXTRST='\e[0m' # Text Reset

  # set ps1 to show git branch, using previously defined
  # function. Also show different host color if over ssh.
  # visual cues = winrar
  # ( idea lifted from phrakture. pew pew! )
  if [ -z "$SSH_TTY" ]; then
    export PS1="\[${TXTWHT}\]\u@\h\[${TXTRST}\]:\w\[${TXTGRN}\]\$(__git_ps1 '(%s)')\[${TXTRST}\]\\$ "
  else
    export PS1="\[${TXTYLW}\]\u@\h\[${TXTRST}\]:\w\[${TXTGRN}\]\$(__git_ps1 '(%s)')\[${TXTRST}\]\\$ "
  fi
}

###
### environment
###

# os specific
case $OS in
  Darwin)
    # clean tarballs
    export COPYFILE_DISABLE='true'
    export LSCOLORS='gxfxcxdxbxegedabagacad'

    # node.js, ruby
    export NVM_DIR=~/.nvm
    source $(brew --prefix nvm)/nvm.sh
    nvm use --delete-prefix node
    if which rbenv > /dev/null; then eval "$(rbenv init -)"; fi

    [ -f `brew --prefix`/etc/bash_completion ] &&
      . `brew --prefix`/etc/bash_completion
    ;;
  Linux)
    #    if [ -e /etc/redhat-release ]; then
    # redhat/centos/fedora specific

    #    fi

    #    if [ -e /etc/debian_version ]; then
    # debian/ubuntu specific
    #    fi

    ## dircolors stuff ##
    #[ -x /usr/bin/dircolors ] && eval "`dircolors -b`"
    export LS_COLORS='no=00:fi=00:di=36;40:ln=35;40:pi=33;40:so=36;40:bd=40;33;01:cd=40;33;01:or=35;40:mi=41;30;01:ex=31;40:*.tar=01;31:*.tgz=01;31:*.arj=01;31:*.taz=01;31:*.lzh=01;31:*.zip=01;31:*.z=01;31:*.Z=01;31:*.gz=01;31:*.bz2=01;31:*.bz=01;31:*.tz=01;31:*.rpm=01;31:*.cpio=01;31:';

    # make less more friendly for non-text input files, see lesspipe(1)
    [ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"
    ## if the above fails, try this too.
    #if [ $? -ne 0 ]; then
    #  ## lesspipe if installed ##
    #  LESSPIPEX="$(type -p lesspipe.sh)"
    #  [ -x "${LESSPIPEX}" ] && export LESSOPEN="|${LESSPIPEX} %s"
    #fi

    ## enable bash completion ##
    [ -f /etc/bash_completion ] && . /etc/bash_completion
    ;;
esac

set_bash_prompt

# shopt!
shopt -s checkwinsize
shopt -s huponexit
shopt -s no_empty_cmd_completion

# editors
export EDITOR=vim
export VISUAL=vim
export PAGER=less

# bash history
export HISTCONTROL="ignorespace:erasedups"
export HISTIGNORE="&:l[ls]:[bf]g:exit"

# grep colors
export GREP_OPTIONS='--color=auto'

# git
export GIT_EDITOR=vim

## less specific vars ##
# turn off .lesshst file
export LESSHISTFILE="-"
# color highlighting in less
export LESS_TERMCAP_mb=$'\E[01;31m'
export LESS_TERMCAP_md=$'\E[01;31m'
export LESS_TERMCAP_me=$'\E[0m'
export LESS_TERMCAP_se=$'\E[0m'
export LESS_TERMCAP_so=$'\E[01;44;33m'
export LESS_TERMCAP_ue=$'\E[0m'
export LESS_TERMCAP_us=$'\E[01;32m'

# add ~/bin to PATH
if [ -d ~/bin ] ; then
  export PATH="${PATH}:${HOME}/bin"
fi

###
### aliases
###
case $OS in
  Darwin)
    alias ls='ls -G -p'
    ;;
  Linux)
    alias ls='ls --color=auto -p'
    ;;
esac

# load local overrides from .bashrc.post
[ -f $HOME/.bashrc.post ] && . $HOME/.bashrc.post
