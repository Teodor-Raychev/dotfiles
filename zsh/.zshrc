# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

typeset -g POWERLEVEL9K_INSTANT_PROMPT=quiet
ZSH_THEME="powerlevel10k/powerlevel10k"
plugins=(git)

source $ZSH/oh-my-zsh.sh

# User configuration

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Terminal Colors: 
ZSH__BLUE='\033[0;34m'
ZSH__WHITE='\033[0;37m' 
ZSH__RED='\033[0;31m'
ZSH__GREEN='\033[0;32m'
ZSH__PURPLE='\033[0;35m'
ZSH__YELLOW='\033[1;33m'

# ================== C Compile Functions ===================
# Compilation flags
# export ARCHFLAGS="-arch x86_64"

[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
eval "$(~/.rbenv/bin/rbenv init - zsh)"

cpile() {
  CPILE_VER="alpha2.0.1"
  while test $# -gt 0; do
    case "$1" in
      -h|--help)
        echo -e " ____  ____  _  _     _____"
        echo -e "/   _\/  __\/ \/ \   /  __/"
        echo -e "|  /  |  \/|| || |   |  \  "
        echo -e "|  \__|  __/| || |_/\|  /_ "
        echo -e "\____/\_/   \_/\____/\____\\"
        echo -e "\nParameters:"
        echo -e "${ZSH__YELLOW}[file(s)]${ZSH__WHITE}            # name of source files to be compiled, including the extensions."
        echo -e "                     # example: 'cpile main.c linked_to_main.c some_lib.c'"
        echo -e "                     # Note: cpile will determine the extension c/cpp, and use the proper compiler."
        echo -e "${ZSH__YELLOW}-h/--h${ZSH__WHITE}               # help menu"
        echo -e "${ZSH__YELLOW}CPP_STANDART${ZSH__WHITE}         # ENV varibale to control the CPP standart. Default: c++11"
        echo -e "${ZSH__YELLOW}C_STANDART${ZSH__WHITE}           # ENV varibale to control the C standart. Default: gnu89"
        echo -e "${ZSH__YELLOW}CFLAGS${ZSH__WHITE}               # ENV varibale to control the flags passed ot the compiler. Default: '-Wall -g 02'"
        echo -e "${ZSH__YELLOW}C_OBJ_FILE${ZSH__WHITE}           # ENV varibale to control the object file extension. Default: o"
        echo -e "${ZSH__YELLOW}RCPILE_ONLY_COMPILE${ZSH__WHITE}  # if set to 1 cpile will only compile, and not run the object files. Default: 0"
        echo -e "${ZSH__YELLOW}COMPILER${ZSH__WHITE}             # Automatically set when passing C/C++ files. Default: N/A, Values: gcc/g++"
        return 1
        shift
        ;;  
      -v|--version)
        echo "$CPILE_VER"
        return 1
        shift
        ;;
      *)
        break
        ;;
    esac
  done

# Control ENVS if not set use defaults:
if [[ -z "${CPP_STANDART}" ]]; then
    CPP_STANDART=c++11
fi
if [[ -z "${C_STANDART}" ]]; then
    C_STANDART=gnu89
fi
if [[ -z "${CFLAGS}" ]]; then
    CFLAGS="-Wall -g -O2"
fi
if [[ -z "${C_OBJ_FILE}" ]]; then
    C_OBJ_FILE=о
fi
if [[ -z "${RCPILE_ONLY_COMPILE}" ]]; then
    RCPILE_ONLY_COMPILE=0
fi

# Compile C source file or files
echo -e "🚀 ${ZSH__BLUE}[Compiling...]" 

# Get main source file:
FILE_NAME=$(echo "$1" | cut -f 1 -d '.')
FILE_EXT=$(echo "$1" | cut -f 2 -d '.')
C_SOURCES=()

if test "$FILE_EXT" = "cpp"
then
    COMPILER="g++"
    STANDART_FLAG=$(echo $CPP_STANDART)
    echo -e "   std: ${ZSH__WHITE}$STANDART_FLAG"
else
    COMPILER="gcc"
    STANDART_FLAG=$(echo $C_STANDART)
    echo -e "   std: ${ZSH__WHITE}$STANDART_FLAG"
fi

if (( $# > 1 )); then
    echo -e "   ${ZSH__BLUE}sources: ${ZSH__WHITE}$# files."
    echo -e "${ZSH__GREEN}   ❯ ${ZSH__PURPLE}$1"

    for arg in "$@"
    do
        if ! [ "$arg" = "$1" ]; then
            C_SOURCES+="$arg"
        fi
    done
    echo -e "   #<$C_SOURCES>"
else
    echo -e "${ZSH__GREEN}   ❯ ${ZSH__PURPLE}$1"
fi

# compile all files:
"$COMPILER" "$FILE_NAME"."$FILE_EXT" $C_SOURCES $(echo $CFLAGS) -std=$STANDART_FLAG -o "$FILE_NAME"."$C_OBJ_FILE" -lm

# only compile
if [ "$RCPILE_ONLY_COMPILE" = "1" ]; then
    echo -e "✅ ${ZSH__GREEN}compiled!${PWHITE}"
    exit
fi

echo -e "💿 ${ZSH__BLUE}[Run]\n${ZSH__WHITE}"
./"$FILE_NAME"."$C_OBJ_FILE"
}

# ================= Aliases ==========================

# rubocop
rr() { bundle exec rubocop }

# rubocop autocorrect
rra() { 
  if [ -n "$1" ]; then
    echo -e ${ZSH__GREEN}"💎 [running rubocop autocorrect for "$1" ]"${ZSH__WHITE}
    bundle exec rubocop -f files -A "$1" 
  else
    echo -e ${ZSH__GREEN}"💎 [running rubocop autocorrect...]"${ZSH__WHITE}
    bundle exec rubocop -a 
  fi
}

# Change ruby version rbenv
ruby-v() {
  if [ -n "$1" ]; then
    echo "$1" > .ruby-version
    echo "\n"
    echo "💎 Switched to version $1 \n"
    echo "\n"
    echo "Current rbenv ruby version:"
    rbenv version
  else
    echo "Please provide a ruby version. Example 2.7.4"
  fi
}

# rspec
rs() {
 if [ -n "$1" ]; then
   echo -e ${ZSH__RED}"💎 [RSpec]"${ZSH__WHITE}
   bundle exec rspec "$1"
 else
   echo -e ${ZSH__RED}"💎 [RSpec]"${ZSH__WHITE}
   bundle exec rspec --exclude-pattern "**/prepending/*_spec.rb"
 fi
 }

# rspec fail fast.  
rsf() { bundle exec rspec --fail-fast }

rss() {
 if [ -n "$1" ]; then
   echo -e ${ZSH__RED}"💎 [RSpec]"${ZSH__WHITE}
   bundle exec spring rspec "$1"
 else
   echo -e ${ZSH__RED}"💎 [RSpec]"${ZSH__WHITE}
   bundle exec spring rspec --exclude-pattern "**/prepending/*_spec.rb"
 fi
}

 # Git status
 alias gs='git status'
 # LazyGit
 lg() {
   lazygit
 }

# Lynx
lnx() { 
  lynxcfg="-cfg=$HOME/.config/lynx/.lynx.cfg";
  lynxlss="-lss=$HOME/.config/lynx/lynx.lss";
  if [ -n "$1" ]; then
    lynx $lynxcfg $lynxlss "$1"
  else
    lynx $lynxcfg $lynxlss
  fi
}

urlencode() {
  declare str="$*"
  declare encoded=""
  declare i c x
  for (( i=0; i<${#str}; i++)); do
    c=${str:$i:1}
    case "$c" in
      [-_.~a-zA-Z0-9] ) x="$c" ;;
      * ) printf -v x '%%%02x' "'$c'" ;;
    esac
    encoded+="$x"
  done
  echo "$encoded"
}

duck() {
  declare url=$(urlencode "$*")
  lnx "https://duckduckgo.com/lite?q=$url"
}

ggle() {
  declare url=$(urlencode "$*")
  lnx "https://google.com/search?q=$url"
}

alias "?"=duck
alias "??"=ggle

# Tmux
# tmux source ~/.config/tmux/tmux.conf
ta() { tmux a -t $1 }
tka() { tmux kill-server & tmux }
tkt() { tmux kill-session -t "$1" }

 # RubyMine 
 # mine() {
 #    if [ -n "$1" ]
 #    then
 #        /opt/RubyMine/bin/rubymine.sh & disown
 #    else
 #       /opt/RubyMine/bin/rubmine.sh "$1" & disown
 #    fi 
 # }

# Docker: 

docker-start() {
  sudo service docker start
}

docker-stop() {
  sudo service docker stop
}

# Memory cleanup
ubuntu-free() {
    sudo sync && sudo sysctl -w vm.drop_caches=3
    # sudo sync; echo 1 > /proc/sys/vm/drop_caches
}

# Neovim clean undodir
nvim-clean() {
  neovim_match="nvim"
  declare -i match_count=$(ps aux | grep -i ${neovim_match} | wc -l)
  echo -e ${ZSH__GREEN}"🧹 cleaning ~/.vim/undodir ..."${ZSH__WHITE}
  if [[ "${match_count}" -gt 1 ]] then
    echo -e ${ZSH__RED}"🇻  Neovim is running, please close it before cleaning."${ZSH__WHITE}
  else
    cd ~/.vim/
    rm -r undodir
    mkdir undodir
    echo "cd: "
    cd -
  fi
}

# Nvim Configs
nconf() {
  cd ~/.config/nvim && nvim
}

# Notes
notes() { 
  cd ~/Documents/notes && nvim
}

# ================ PATH EXPORTS ===================================

# Python Use system python instead of build from source or package.
export PATH="/usr/bin:$PATH"
# doom emacs
# export PATH="~/.config/emacs/bin:$PATH"
# export PATH=$PATH:/home/$USER/.emacs.d/bin
# set pyenv, like rbenv
export PATH="$HOME/.pyenv/bin:$PATH"
eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"

# Nvim path
export PATH="$PATH:/opt/nvim-linux64/bin"

# Anaconda3 init:
export PATH="$PATH:/opt/anaconda3/bin"

# Rbenv
eval "$(rbenv init -)"

# NVM 
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
export NODE_PATH=$NODE_PATH:`npm root -g`
# set default version to be used across terminal sessions:
# set default node.
nvm-default() 
{ 
  if [ -n "$1" ]; then
    nvm use default $1
  else
   nvm alias default 20.12.2 
  fi
}

# eval "$(/bin/brew shellenv)"
# eval "$(/bin/brew shellenv)"
# eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
