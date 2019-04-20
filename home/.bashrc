# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# colored GCC warnings and errors
#export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

alias change-wallpaper="bash /home/falvyu/scripts/change-wallpaper.bash"
alias clion="/home/falvyu/Documents/Tools/clion-2017.2.2/bin/clion.sh"


function hex-to-dec(){
    echo "ibase=16; $1" | bc
}

function dec-to-bin() {
    echo "ibase=10; obase=2; $1" | bc
}

function bcf(){
    echo "scale=5; $*" | bc
}

function remove_audio(){
    ffmpeg -i $1 -vcodec copy -an $2
}


term_emulator() {
    pid=$$
    while true; do
        pid=$(ps -h -o ppid -p $pid 2>/dev/null)
        case $(ps -h -o comm -p $pid 2>/dev/null) in
        (gnome-terminal) TERM_EM="gnome-terminal";return;;
        (xterm) TERM_EM="xterm" ;return;;
        (rxvt) TERM_EM="rxvt";return;;
        (python) if [ ! -z "$(ps -h -o args -p $pid 2>/dev/null | grep guake)" ]; then TERM_EM="guake"; return; fi ;;
	(terminology) TERM_EM="terminology"; return;;
        esac
        [[ $(echo $pid) == 1 ]] && break
    done
}
term_emulator

NEOFETCH_IMG="/home/falvyu/Documents/Wallpaper/downloaded/57158021_p14_master1200.jpg"


# If using i3
if [[ $DESKTOP_SESSION == "/usr/share/xsessions/i3" ]]
then
    alias set-wp="sh ~/scripts/set-wallpaper.sh"
fi

# Check terminal emulator
#if [[ $TERM_EM == "terminology" ]]
#then
#    neofetch #--tycat $NEOFETCH_IMG
#    echo $TERM_EM
#else
    #neofetch # --w3m --source $NEOFETCH_IMG
#fi


alias mountwin="sudo mount /dev/sda5 /media/falvyu/"
alias mars="java -jar ~/Document/Tools/Mars/Mars4_5.jar"
alias reboot="systemctl reboot"
alias microcap="wine ~/.wine/drive_c/MC11demo/mc11demo.exe"
alias waifu2x="waifu2x-converter-cpp"


function waifu2x-scale() {
    waifu2x -i $1 -o ${1}_x${2}.png --scale_ratio $2
}


alias create_hotspot='bash ~/scripts/hotspot.sh'
alias listen_tcp='bash ~/scripts/listen_tcp.sh'
alias wget='wget --no-use-server-timestamps'


export LD_LIBRARY_PATH="/usr/local/lib"


# Lustre
export LUSTRE_INSTALL='/home/falvyu/Documents/Applications/lustre-v4-III-dc-linux64'
source $LUSTRE_INSTALL/setenv.sh
