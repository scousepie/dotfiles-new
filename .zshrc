# Prompt configuration
# virtual environment prompt setup
function virtual_env_prompt () {
	REPLY=${VIRTUAL_ENV+[${VIRTUAL_ENV:t}]}
}

grml_theme_add_token virtual-env -f virtual_env_prompt '%F{007}' '%f'

function config_env_prompt () {
    REPLY=${CONFIG_ENV+(${CONFIG_ENV:t}) }
}
grml_theme_add_token config-env -f config_env_prompt '%F{007}' '%f'

zstyle ':prompt:grml:left:items:host' pre '%B%F{070}'
zstyle ':prompt:grml:left:items:path' pre '%B%F{240}'
zstyle ':prompt:grml:left:setup' items rc config-env change-root host path newline virtual-env percent
zstyle ':prompt:grml:right:setup' items vcs


# Git based dotfiles setup start
function _config_activate {
    export GIT_DIR=$HOME/.cfg/
    export GIT_WORK_TREE=$HOME
    CONFIG_ENV="config"
}

function _config_deactivate {
    unset GIT_DIR GIT_WORK_TREE CONFIG_ENV
}

function config {
    if [[ -n "$1" ]]; then
        _config_activate
        git $@
        _config_deactivate
        return
    elif [[ -z "${CONFIG_ENV}" ]]; then
        _config_activate
    else
        _config_deactivate
    fi
}
# git based dotfiles setup end


# Enable or disable python virtual env
function chpwd_auto_python_venv() {
    local venv_dir
    local cur_dir="${PWD}"
    while [[ "${cur_dir}" != / ]]; do
        if [[ -f "${cur_dir}/venv/bin/activate" ]]; then
            venv_dir="${cur_dir}/venv"
            break
        fi
        # :P does `realpath(3)`
        # :h removes 1 trailing pathname component
        cur_dir="${cur_dir:P:h}"
    done
    if [[ -z "${VIRTUAL_ENV}" ]] && [[ -n "${venv_dir}" ]]; then
        # we found venv dir that is not yet activated
        source "${venv_dir}"/bin/activate
    elif [[ -z "${venv_dir}" ]] && [[ -n "${VIRTUAL_ENV}" ]]; then
        # we have activated virtual env but we cant find venv folder anymore
        deactivate
    fi
}
chpwd_functions+=(chpwd_auto_python_venv)


#alias config='/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'
#alias config='git --git-dir=/home/neil/.dotfiles/ --work-tree=/home/neil'
alias mkvenv='python -m venv venv && cd .. && cd -'
alias lla='command ls -a --color=auto -v'
alias mirror='sudo reflector --country GB --age 6 --protocol https --protocol http --sort rate --save /etc/pacman.d/mirrorlist'
alias hist='history 1 | grep '
#alias vi='vim '
#alias zerotest='zmv -n '(<1->)(*).(mp4|srt|html)' '${(l:3::0:)1}$2.$3''
#alias zero-add=zmv '(<1->).*' '${(l:3::0:)1}.*'

HISTFILE=~/.histfile
HISTSIZE=10000
SAVEHIST=10000
