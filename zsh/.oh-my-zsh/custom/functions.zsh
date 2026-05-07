# Commit everything with auto issue prefix from branch name
function commit() {
    local commitMessage
    local -a opts

    if [[ "$1" == -* ]]; then
        commitMessage="wip"
        opts=("$@")
    else
        commitMessage="$1"
        shift
        opts=("$@")
    fi

    git add .
    git status

    if [ "$commitMessage" = "" ]; then
        commitMessage="wip"
    fi

    if [ -n "$(getIssueName)" ]; then
        commitMessage="$(getIssueName): $commitMessage"
    fi

    git commit -a -m "$commitMessage" "${opts[@]}"
}

# Get the issue name from the branch name
function getIssueName() {
    local branch="$(git rev-parse --abbrev-ref HEAD 2>/dev/null)"
    if [ -z "$branch" ] || [ "$branch" = "HEAD" ]; then
        echo ""
        return
    fi
    local jira="$(echo "$branch" | grep -Eo '[A-Z][A-Z0-9]+-[0-9]+' | head -n1)"
    if [ -n "$jira" ]; then
        echo "$jira"
        return
    fi
    # Zsh-compatible array split by / - _
    local parts=("${(@s:/:)branch}")
    local subparts=()
    for part in "${parts[@]}"; do
        subparts+=("${(@s:-:)part}")
    done
    local finalparts=()
    for part in "${subparts[@]}"; do
        finalparts+=("${(@s:_:)part}")
    done
    for part in "${finalparts[@]}"; do
        if [[ "$part" =~ ^[0-9]+$ ]]; then
            echo "$part"
            return
        fi
    done
    echo ""
}

# Git branch detection
function gitmainormaster() {
    local branch=$(git branch --list --format="%(refname:short)" main master | head -1)
    echo "${branch:-main}"
}

function gitdevordev() {
    local branch=$(git branch --list --format="%(refname:short)" development develop dev | head -1)
    echo "${branch:-development}"
}

# Sail wrapper: ensure Traefik is up before `sail up`
function sail() {
    if [[ "$1" == "up" ]]; then
        docker compose -f "$HOME/traefik/docker-compose.yml" up -d >/dev/null
    fi
    if [[ -f ./vendor/bin/sail ]]; then
        ./vendor/bin/sail "$@"
    else
        command sail "$@"
    fi
}

# Auto-create and activate python venv
smartvenv() {
    local venv_path="venv"
    if [ ! -d "$venv_path" ]; then
        echo "Creando venv en $venv_path..."
        python3 -m venv "$venv_path"
    fi
    if [ -z "$VIRTUAL_ENV" ] || [ "$VIRTUAL_ENV" != "$(pwd)/$venv_path" ]; then
        source "$venv_path/bin/activate"
        echo "Venv activado en $(pwd)/$venv_path"
    fi
}
