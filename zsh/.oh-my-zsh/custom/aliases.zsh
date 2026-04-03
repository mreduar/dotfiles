# Shell
alias brc="source ~/.zshrc"
alias newalias="vs ~/.oh-my-zsh/custom/aliases.zsh"
alias c="clear"
alias where="which"
alias nr="npm run"
alias dotfiles="vs ~/dotfiles"

# Laravel / Sail
alias sail="vendor/bin/sail"
alias art="sail artisan"
alias up='sail up -d'
alias dev="sail up -d && sail npm run dev"
alias fix="sail bin duster fix"
alias lint="sail bin duster lint"
alias langs="sail npm run vue-i18n-extract report && sail npm run vue-i18n-extract report && sail artisan translatable:export de,en,es,fr,ko,it,nl,pt,tr"
alias tinker='art tinker'
alias srebuild="docker compose down && sail build --no-cache && sail up -d && sail composer install && sail npm install && sail npm run dev"

# Git
alias gs="git status"
alias gf="git fetch"
alias wta="git worktree add"
alias wtr="git worktree remove"
alias nah="git reset --hard HEAD && git clean -df"
alias gitmainormaster='printf "%s\n" $(git branch --format "%(refname:short)" --sort=-committerdate --list master main) main | head -n 1'
alias main='git checkout $(gitmainormaster)'

# Testing
alias p='./vendor/bin/sail bin pest'
alias pc='./vendor/bin/sail bin pest --coverage'
alias stan='./vendor/bin/sail bin phpstan analyse'

# Branch cleanup
alias prune-branches='npx git-removed-branches --prune'
alias cleanBranchs='prune-branches'
alias cleanBranches='prune-branches'
alias clearBranchs='prune-branches'
alias clearBranches='prune-branches'

# Stripe
alias stripe-webhook='stripe listen --forward-to http://manyrequests.localhost/stripe/webhook'
alias stripe-internal-webhook='stripe listen --forward-to http://manyrequests.localhost/stripe/internal-webhook'

# Tools
alias tm="task-master"
alias codexx="codex --yolo"
alias cso="vscli open --command vs . --behavior detect"
alias rp="npx tsx src/bin/cli.ts"
alias clauded='claude --dangerously-skip-permissions'
alias vs="vscli open"

# Game modding
alias ni='cd /mnt/d/Juegos/Bots/ni\ v0.0.68/addon/ && vs .'
alias apep='cd /mnt/d/Juegos/Bots/Apep\ wotlk/rotations && vs .'

# Python (auto venv)
alias pip='smartvenv && pip'
alias python='smartvenv && python'
alias pip3='smartvenv && pip3'
