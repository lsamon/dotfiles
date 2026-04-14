# ==============================================================================
# ~/.zshrc
# ==============================================================================

# ==============================================================================
# Oh My Zsh
# ==============================================================================

export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="agnoster"  # popular theme with git branch in prompt
                       # alternatives: robbyrussell, powerlevel10k, avit

# Plugins
plugins=(
  git                        # git aliases and completion
  rails                      # rails aliases
  bundler                    # bundle exec shortcuts
  ruby                       # ruby helpers
  docker                     # docker completion
  docker-compose             # docker compose completion
  kubectl                    # kubectl completion + aliases
  rbenv                      # rbenv init
  fzf                        # fuzzy finder keybindings
  zsh-autosuggestions        # fish-style autosuggestions
  zsh-syntax-highlighting    # highlight valid/invalid commands
  z                          # jump to frecent directories
)

source $ZSH/oh-my-zsh.sh

# ==============================================================================
# History
# ==============================================================================

HISTSIZE=10000
SAVEHIST=10000
HISTFILE=~/.zsh_history
setopt HIST_IGNORE_DUPS        # no duplicate entries
setopt HIST_IGNORE_SPACE       # ignore commands starting with space
setopt HIST_VERIFY             # show command before executing from history
setopt SHARE_HISTORY           # share history across sessions
setopt EXTENDED_HISTORY        # save timestamps

# ==============================================================================
# Autosuggestions settings
# ==============================================================================

ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#888888"   # suggestion text colour
ZSH_AUTOSUGGEST_STRATEGY=(history completion)  # use history first, then completion
bindkey '^ ' autosuggest-accept                # Ctrl+Space to accept suggestion
bindkey '^]' autosuggest-accept                # or Right arrow (already default)

# ==============================================================================
# Editor
# ==============================================================================

export EDITOR='cursor --wait'
export VISUAL='cursor --wait'

# ==============================================================================
# Navigation
# ==============================================================================

alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias ~='cd ~'
alias -- -='cd -'

mkcd() { mkdir -p "$1" && cd "$1"; }

# ==============================================================================
# ls
# ==============================================================================

alias ls='ls --color=auto --group-directories-first'
alias ll='ls -lhF'
alias la='ls -lahF'
alias lsd='ls -lhF | grep "^d"'
alias l='ls -CF'

# ==============================================================================
# Safety
# ==============================================================================

alias cp='cp -i'
alias mv='mv -i'
alias rm='rm -i'
alias mkdir='mkdir -p'

# ==============================================================================
# General utilities
# ==============================================================================

alias grep='grep --color=auto'
alias df='df -h'
alias du='du -h'
alias free='free -h'
alias myip='curl -s https://ifconfig.me && echo'
alias reload='source ~/.zshrc'
alias path='echo -e ${PATH//:/\\n}'
alias now='date +"%T"'
alias week='date +%V'
alias less='less -R'

tre() { tree -aC -I '.git|node_modules|.bundle|tmp|log' "${@:-.}" | less -FRNX; }

extract() {
  if [ -f "$1" ]; then
    case "$1" in
      *.tar.bz2) tar xjf "$1"   ;;
      *.tar.gz)  tar xzf "$1"   ;;
      *.bz2)     bunzip2 "$1"   ;;
      *.rar)     unrar x "$1"   ;;
      *.gz)      gunzip "$1"    ;;
      *.tar)     tar xf "$1"    ;;
      *.tbz2)    tar xjf "$1"   ;;
      *.tgz)     tar xzf "$1"   ;;
      *.zip)     unzip "$1"     ;;
      *.Z)       uncompress "$1";;
      *.7z)      7z x "$1"      ;;
      *)         echo "'$1' cannot be extracted via extract()" ;;
    esac
  else
    echo "'$1' is not a valid file"
  fi
}

# dotfiles management (bare repo)
alias dotfiles='git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'

# ==============================================================================
# Git
# ==============================================================================

# Oh My Zsh git plugin already provides many aliases.
# These are extras on top:
alias gds='git diff --staged'
alias gclean='git clean -fd'
alias greset='git reset --hard HEAD'

# dotfiles management (bare repo)
alias dotfiles='git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'

# ==============================================================================
# Ruby / Rails
# ==============================================================================

# rbenv (Oh My Zsh rbenv plugin handles init, but PATH is set here)
export PATH="$HOME/.rbenv/bin:$PATH"

# Bundler
alias be='bundle exec'
alias bi='bundle install'
alias bu='bundle update'
alias bo='bundle open'

# Rails
alias rs='bin/rails server'
alias rc='bin/rails console'
alias rr='bin/rails routes'
alias rdb='bin/rails db:migrate'
alias rdbc='bin/rails db:create'
alias rdbr='bin/rails db:rollback'
alias rdbs='bin/rails db:seed'
alias rdbreset='bin/rails db:drop db:create db:migrate db:seed'
alias rt='bin/rails test'
alias rspec='bundle exec rspec'
alias rgc='bin/rails generate controller'
alias rgm='bin/rails generate model'
alias rgmig='bin/rails generate migration'
alias rlog='tail -f log/development.log'

# ==============================================================================
# Docker
# ==============================================================================

alias d='docker'
alias di='docker images'
alias dps='docker ps'
alias dpsa='docker ps -a'
alias drm='docker rm'
alias drmi='docker rmi'
alias dexec='docker exec -it'
alias dlogs='docker logs -f'
alias dstop='docker stop $(docker ps -q)'
alias dclean='docker system prune -f'
alias dcleanall='docker system prune -af --volumes'

alias dc='docker compose'
alias dcu='docker compose up'
alias dcud='docker compose up -d'
alias dcd='docker compose down'
alias dcr='docker compose restart'
alias dcl='docker compose logs -f'
alias dcb='docker compose build'
alias dce='docker compose exec'
alias dcp='docker compose pull'

alias dcrs='docker compose run --rm web bin/rails server'
alias dcrc='docker compose run --rm web bin/rails console'
alias dcrdb='docker compose run --rm web bin/rails db:migrate'

# ==============================================================================
# Kubernetes
# ==============================================================================

alias k='kubectl'
alias kgp='kubectl get pods'
alias kgpa='kubectl get pods --all-namespaces'
alias kgs='kubectl get services'
alias kgd='kubectl get deployments'
alias kgn='kubectl get nodes'
alias kdp='kubectl describe pod'
alias kds='kubectl describe service'
alias kdd='kubectl describe deployment'
alias kl='kubectl logs -f'
alias kex='kubectl exec -it'
alias kaf='kubectl apply -f'
alias kdf='kubectl delete -f'
alias kctx='kubectl config current-context'
alias kns='kubectl config set-context --current --namespace'
alias kroll='kubectl rollout restart deployment'
alias kwatch='watch -n 2 kubectl get pods'

kuse() { kubectl config use-context "$1"; }
kall() { kubectl get all -n "${1:-default}"; }

# ==============================================================================
# fzf
# ==============================================================================

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
export FZF_DEFAULT_OPTS='--height 40% --layout=reverse --border'

# ==============================================================================
# Local overrides — not tracked in Git
# ==============================================================================

[ -f ~/.zshrc.local ] && source ~/.zshrc.local
