#
# Portable KSH dot file
# Works with BASH, MKSH and (PD)KSH
# (c) Tobias Farrenkopf
#


USER=${USER:-`id -un`}
LOGNAME=${LOGNAME:-$USER}
EDITOR=vi
VISUAL=vi
FCEDIT=vi
EXINIT='set autoindent'
PAGER=less
LESS="-MIRFx4sX"
more='less'

LC_ALL=
LC_CTYPE=en_US.UTF-8
LANG=en_US.UTF-8

unix=`uname -s`
case $unix in
  Linux)  HOSTNAME=${HOSTNAME:-`hostname --fqdn`}
    ;;
  Darwin) HOSTNAME=${HOSTNAME:-`uname -n`}
    ;;
  *BSD)   HOSTNAME=${HOSTNAME:-`uname -n`}
    export PERL_BADLANG=0
    ;;
  *)      HOSTNAME=${HOSTNAME:-`hostname`}
    LC_ALL=C
    LANG=C
    ;;
esac

export USER LOGNAME MAIL EDITOR VISUAL PAGER LESS LANG LC_ALL LC_CTYPE

# Interactive Settings:
case "$-" in *i*)

  HISTSIZE=10000

  #Prompt
  if [ $(id -u) -eq 0 ]; then
    PS1='${USER}@${HOSTNAME%%\.*} [${PWD}] ${?#0}# '
  else
    PS1='$(local_or_remote) [${PWD#${PWD%/*/*/*/*/*}/}]$(parse_git_branch) ${?#0}> '
  fi


  unalias -a
  alias ll='ls -alF'
  alias cp='cp -i'
  alias mv='mv -i'
  alias rm='rm -i'
  alias l='ls -crtl'
  alias h='history'
  #alias d='pwd'
  alias reload='. $HOME/.shrc'
  alias realias='$EDITOR $HOME/.aliases.sh; . $HOME/.bashrc'
  alias tzoom='$(tmux_zoom)'

  # Read ~/.aliases.sh if the file exists
  if [ -f $HOME/.aliases.sh ]; then
    . $HOME/.aliases.sh
  fi

  case $unix in
    *BSD)
      alias reboot='shutdown -r now'
      alias halt='shutdown -h now'
      ;;
  esac

  #[[ -s $MAIL ]] && print "You have mail."

  umask 002
  set -o vi
  #noclobber
  set -C
  stty -ixon


  if [ -n "$BASH" ]; then
    shopt -s cdspell
    shopt -s direxpand
    shopt -s dirspell
  fi

  # KSH88
  #stty erase '^?'
  ##stty susp '^Z'
  ##stty sane susp '^Z'
  ##stty kill '^C'

  # KSH93
  #typeset -A Keytable
  #trap 'eval "${Keytable[${.sh.edchar}]}"' KEYBD
  #function keybind # key [action]
  #{
  #    typeset key=$(print -f "%q" "$2")
  #    case $# in
  #    2)      Keytable[$1]=' .sh.edchar=${.sh.edmode}'"$key"
  #            ;;
  #    1)      unset Keytable[$1]
  #            ;;
  #    *)      print -u2 "Usage: $0 key [action]"
  #            return 2 # usage errors return 2 by default
  #            ;;
  #    esac
  #}
  #keybind $'\t' $'\E\E'
  #keybind $'' 'echo -ne "\E[H\E[J"'$'\r'
  # SPECIAL  ^^ CHARARACTER HERE

  # PDKSH
  #bind '^I'=complete
  #bind '^I'=complete-list
  #bind -m '^L'='clear^M'
  # Bind POS1, END and DEL keys
  # For DEL see http://monkey.org/openbsd/archive/misc/0310/msg00504.html
  #bind '^XH'=beginning-of-line      # POS1/HOME
  #bind '^XF'=end-of-line            # END
  #bind "^[[3"=prefix-2              # DEL
  #bind "^[[3~"=delete-char-forward  # DEL

  date
  uptime
  who
  ;;
esac
unset unix


## Functions
parse_git_branch() {
  git branch 2> /dev/null | cut -c 1-25 | sed -e '/^[^*]/d' -e 's/* \(.*\)/(\1)/'
}

local_or_remote() {
  if [ -n "$REMOTE_SESSION" ]; then
    echo ${USER}@${HOSTNAME%%\.*}
  else
    echo "$USER"
  fi
}
