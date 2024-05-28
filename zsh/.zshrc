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

# ================== C Compile Functions ===================
# Compilation flags
# export ARCHFLAGS="-arch x86_64"

[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
eval "$(~/.rbenv/bin/rbenv init - zsh)"

cpile() {
BLUE='\033[0;34m'
WHITE='\033[0;37m' 
RED='\033[0;31m'
GREEN='\033[0;32m'
PURPLE='\033[0;35m'

# Controll ENVS if not set use defaults:
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
echo -e "🚀 ${BLUE}[Compiling...]" 

# Get main source file:
FILE_NAME=$(echo "$1" | cut -f 1 -d '.')
FILE_EXT=$(echo "$1" | cut -f 2 -d '.')
C_SOURCES=()

if test "$FILE_EXT" = "cpp"
then
    COMPILER="g++"
    STANDART_FLAG=$(echo $CPP_STANDART)
    echo -e "   std: ${WHITE}$STANDART_FLAG"
else
    COMPILER="gcc"
    STANDART_FLAG=$(echo $C_STANDART)
    echo -e "   std: ${WHITE}$STANDART_FLAG"
fi

if (( $# > 1 )); then
    echo -e "   ${BLUE}sources: ${WHITE}$# files."
    echo -e "${GREEN}   ❯ ${PURPLE}$1"

    for arg in "$@"
    do
        if ! [ "$arg" = "$1" ]; then
            C_SOURCES+="$arg"
        fi
    done
    echo -e "   #<$C_SOURCES>"
else
    echo -e "${GREEN}   ❯ ${PURPLE}$1"
fi

# compile all files:
"$COMPILER" "$FILE_NAME"."$FILE_EXT" $C_SOURCES $(echo $CFLAGS) -std=$STANDART_FLAG -o "$FILE_NAME"."$C_OBJ_FILE" -lm

#only compile
if [ "$RCPILE_ONLY_COMPILE" = "1" ]; then
    echo -e "✅ ${GREEN}compiled!${PWHITE}"
    exit
fi

echo -e "💿 ${BLUE}[Run]\n${WHITE}"
./"$FILE_NAME"."$C_OBJ_FILE"
}

# ================= Aliases ==========================

# rubocop
rr() { bundle exec rubocop }

# rubocop autocorrect
rra() { 
  if [ -n "$1" ] 
  then
    echo "💎 [running rubocop autocorrect for "$1" ]"
    bundle exec rubocop -f files -A "$1" 
  else
    echo "💎 [running rubocop autocorrect...]"
    bundle exec rubocop -a 
  fi
}

# Change ruby version rbenv
ruby-v() {
  if [ -n "$1" ]
  then
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
 if [ -n "$1" ]
 then
   echo "💎 [RSpec]"
   bundle exec rspec "$1"
 else
   echo "💎 [RSpec]"
   bundle exec rspec --exclude-pattern "**/prepending/*_spec.rb"
 fi
 }

# rspec fail fast.  
rsf() { bundle exec rspec --fail-fast }

rss() {
 if [ -n "$1" ]
 then
   echo "💎 [RSpec]"
   bundle exec spring rspec "$1"
 else
   echo "💎 [RSpec]"
   bundle exec spring rspec --exclude-pattern "**/prepending/*_spec.rb"
 fi
}

 # Git status
 alias gs='git status'
 # LazyGit
 lg() {
   lazygit
 }

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

# ================ PATH EXPORTS ===================================
# Python Use system python instead of build from source or package.
export PATH="/usr/bin:$PATH"
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
  if [ -n "$1" ]; 
  then
    nvm use default $1
  else
   nvm alias default 20.12.2 
  fi
}

# eval "$(/bin/brew shellenv)"
# eval "$(/bin/brew shellenv)"
# eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
