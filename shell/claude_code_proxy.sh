#!/usr/bin/env bash

if [ -z "${BASH_VERSION:-}" ]; then
    return 0
fi

codex_proxy_for_claudecode_root() {
    local source_path root_dir

    source_path="${BASH_SOURCE[0]:-$0}"
    root_dir="$(cd -- "$(dirname -- "$source_path")/.." && pwd)"
    printf '%s\n' "$root_dir"
}

codex_proxy_repo_dir() {
    local root_dir

    if [ -n "${CLI_PROXYAPI_DIR:-}" ]; then
        printf '%s\n' "$CLI_PROXYAPI_DIR"
        return 0
    fi

    root_dir="$(codex_proxy_for_claudecode_root)"
    if [ -e "$root_dir/CLIProxyAPI" ]; then
        printf '%s\n' "$root_dir/CLIProxyAPI"
    else
        printf '%s\n' "$root_dir/../CLIProxyAPI"
    fi
}

cc_proxy_backup_claude_env() {
    if [ -z "${CC_PROXY_ORIG_ANTHROPIC_API_KEY+x}" ]; then
        CC_PROXY_ORIG_ANTHROPIC_API_KEY="${ANTHROPIC_API_KEY-}"
    fi
    if [ -z "${CC_PROXY_ORIG_ANTHROPIC_BASE_URL+x}" ]; then
        CC_PROXY_ORIG_ANTHROPIC_BASE_URL="${ANTHROPIC_BASE_URL-}"
    fi
    if [ -z "${CC_PROXY_ORIG_ANTHROPIC_AUTH_TOKEN+x}" ]; then
        CC_PROXY_ORIG_ANTHROPIC_AUTH_TOKEN="${ANTHROPIC_AUTH_TOKEN-}"
    fi
    if [ -z "${CC_PROXY_ORIG_ANTHROPIC_DEFAULT_OPUS_MODEL+x}" ]; then
        CC_PROXY_ORIG_ANTHROPIC_DEFAULT_OPUS_MODEL="${ANTHROPIC_DEFAULT_OPUS_MODEL-}"
    fi
    if [ -z "${CC_PROXY_ORIG_ANTHROPIC_DEFAULT_SONNET_MODEL+x}" ]; then
        CC_PROXY_ORIG_ANTHROPIC_DEFAULT_SONNET_MODEL="${ANTHROPIC_DEFAULT_SONNET_MODEL-}"
    fi
    if [ -z "${CC_PROXY_ORIG_ANTHROPIC_DEFAULT_HAIKU_MODEL+x}" ]; then
        CC_PROXY_ORIG_ANTHROPIC_DEFAULT_HAIKU_MODEL="${ANTHROPIC_DEFAULT_HAIKU_MODEL-}"
    fi
    if [ -z "${CC_PROXY_ORIG_ANTHROPIC_MODEL+x}" ]; then
        CC_PROXY_ORIG_ANTHROPIC_MODEL="${ANTHROPIC_MODEL-}"
    fi
    if [ -z "${CC_PROXY_ORIG_ANTHROPIC_SMALL_FAST_MODEL+x}" ]; then
        CC_PROXY_ORIG_ANTHROPIC_SMALL_FAST_MODEL="${ANTHROPIC_SMALL_FAST_MODEL-}"
    fi
}

cc_proxy_restore_claude_env() {
    if [ "${CC_PROXY_ORIG_ANTHROPIC_API_KEY+x}" = x ]; then
        if [ -n "$CC_PROXY_ORIG_ANTHROPIC_API_KEY" ]; then
            export ANTHROPIC_API_KEY="$CC_PROXY_ORIG_ANTHROPIC_API_KEY"
        else
            unset ANTHROPIC_API_KEY
        fi
        unset CC_PROXY_ORIG_ANTHROPIC_API_KEY
    fi
    if [ "${CC_PROXY_ORIG_ANTHROPIC_BASE_URL+x}" = x ]; then
        if [ -n "$CC_PROXY_ORIG_ANTHROPIC_BASE_URL" ]; then
            export ANTHROPIC_BASE_URL="$CC_PROXY_ORIG_ANTHROPIC_BASE_URL"
        else
            unset ANTHROPIC_BASE_URL
        fi
        unset CC_PROXY_ORIG_ANTHROPIC_BASE_URL
    fi
    if [ "${CC_PROXY_ORIG_ANTHROPIC_AUTH_TOKEN+x}" = x ]; then
        if [ -n "$CC_PROXY_ORIG_ANTHROPIC_AUTH_TOKEN" ]; then
            export ANTHROPIC_AUTH_TOKEN="$CC_PROXY_ORIG_ANTHROPIC_AUTH_TOKEN"
        else
            unset ANTHROPIC_AUTH_TOKEN
        fi
        unset CC_PROXY_ORIG_ANTHROPIC_AUTH_TOKEN
    fi
    if [ "${CC_PROXY_ORIG_ANTHROPIC_DEFAULT_OPUS_MODEL+x}" = x ]; then
        if [ -n "$CC_PROXY_ORIG_ANTHROPIC_DEFAULT_OPUS_MODEL" ]; then
            export ANTHROPIC_DEFAULT_OPUS_MODEL="$CC_PROXY_ORIG_ANTHROPIC_DEFAULT_OPUS_MODEL"
        else
            unset ANTHROPIC_DEFAULT_OPUS_MODEL
        fi
        unset CC_PROXY_ORIG_ANTHROPIC_DEFAULT_OPUS_MODEL
    fi
    if [ "${CC_PROXY_ORIG_ANTHROPIC_DEFAULT_SONNET_MODEL+x}" = x ]; then
        if [ -n "$CC_PROXY_ORIG_ANTHROPIC_DEFAULT_SONNET_MODEL" ]; then
            export ANTHROPIC_DEFAULT_SONNET_MODEL="$CC_PROXY_ORIG_ANTHROPIC_DEFAULT_SONNET_MODEL"
        else
            unset ANTHROPIC_DEFAULT_SONNET_MODEL
        fi
        unset CC_PROXY_ORIG_ANTHROPIC_DEFAULT_SONNET_MODEL
    fi
    if [ "${CC_PROXY_ORIG_ANTHROPIC_DEFAULT_HAIKU_MODEL+x}" = x ]; then
        if [ -n "$CC_PROXY_ORIG_ANTHROPIC_DEFAULT_HAIKU_MODEL" ]; then
            export ANTHROPIC_DEFAULT_HAIKU_MODEL="$CC_PROXY_ORIG_ANTHROPIC_DEFAULT_HAIKU_MODEL"
        else
            unset ANTHROPIC_DEFAULT_HAIKU_MODEL
        fi
        unset CC_PROXY_ORIG_ANTHROPIC_DEFAULT_HAIKU_MODEL
    fi
    if [ "${CC_PROXY_ORIG_ANTHROPIC_MODEL+x}" = x ]; then
        if [ -n "$CC_PROXY_ORIG_ANTHROPIC_MODEL" ]; then
            export ANTHROPIC_MODEL="$CC_PROXY_ORIG_ANTHROPIC_MODEL"
        else
            unset ANTHROPIC_MODEL
        fi
        unset CC_PROXY_ORIG_ANTHROPIC_MODEL
    fi
    if [ "${CC_PROXY_ORIG_ANTHROPIC_SMALL_FAST_MODEL+x}" = x ]; then
        if [ -n "$CC_PROXY_ORIG_ANTHROPIC_SMALL_FAST_MODEL" ]; then
            export ANTHROPIC_SMALL_FAST_MODEL="$CC_PROXY_ORIG_ANTHROPIC_SMALL_FAST_MODEL"
        else
            unset ANTHROPIC_SMALL_FAST_MODEL
        fi
        unset CC_PROXY_ORIG_ANTHROPIC_SMALL_FAST_MODEL
    fi
}

cc_proxy_set_claude_env() {
    cc_proxy_backup_claude_env
    export CLAUDE_PROXY_ACTIVE=1
    export ANTHROPIC_BASE_URL="http://127.0.0.1:8317"
    export ANTHROPIC_AUTH_TOKEN="cc-proxy-local"
    export ANTHROPIC_DEFAULT_OPUS_MODEL="gpt-5.4"
    export ANTHROPIC_DEFAULT_SONNET_MODEL="gpt-5.4"
    export ANTHROPIC_DEFAULT_HAIKU_MODEL="gpt-5.4-mini"
    export ANTHROPIC_MODEL="gpt-5.4"
    export ANTHROPIC_SMALL_FAST_MODEL="gpt-5.4-mini"
    unset ANTHROPIC_API_KEY
}

cc_proxy_unset_claude_env() {
    unset CLAUDE_PROXY_ACTIVE
    cc_proxy_restore_claude_env
}

cc_proxy_find_running_pid() {
    local repo_dir listener_pids pid cmd

    repo_dir="$(codex_proxy_repo_dir)"
    listener_pids="$(lsof -tiTCP:8317 -sTCP:LISTEN 2>/dev/null)"
    pid="${listener_pids%%$'\n'*}"
    if [ -z "$pid" ]; then
        return 1
    fi

    cmd="$(ps -p "$pid" -o args= 2>/dev/null)"
    case "$cmd" in
        *"$repo_dir/cli-proxy-api"*"--config"*"$repo_dir/config.yaml"*)
            printf '%s\n' "$pid"
            return 0
            ;;
    esac

    return 2
}

cc_proxy_start() {
    local repo_dir bin_path config_path pid_file log_file running_pid find_status

    repo_dir="$(codex_proxy_repo_dir)"
    bin_path="$repo_dir/cli-proxy-api"
    config_path="$repo_dir/config.yaml"
    pid_file="$repo_dir/cc-proxy.pid"
    log_file="$repo_dir/cc-proxy.log"

    running_pid="$(cc_proxy_find_running_pid)"
    find_status=$?
    if [ "$find_status" -eq 0 ]; then
        printf '%s\n' "$running_pid" > "$pid_file"
        cc_proxy_set_claude_env
        echo "CC_PROXY is already running (PID $running_pid)"
        echo "Logs: $log_file"
        return 0
    elif [ "$find_status" -eq 2 ]; then
        echo "Port 8317 is already in use by another process"
        return 1
    fi

    if [ -f "$pid_file" ]; then
        local pid
        pid="$(cat "$pid_file")"
        if [ -n "$pid" ] && kill -0 "$pid" 2>/dev/null; then
            cc_proxy_set_claude_env
            echo "CC_PROXY is already running (PID $pid)"
            return 0
        fi
    fi

    if [ ! -x "$bin_path" ]; then
        echo "Missing binary: $bin_path"
        return 1
    fi

    nohup "$bin_path" --config "$config_path" > "$log_file" 2>&1 &
    echo $! > "$pid_file"
    cc_proxy_set_claude_env
    echo "CC_PROXY started (PID $!)"
    echo "Logs: $log_file"
}

cc_proxy_stop() {
    local repo_dir pid_file

    repo_dir="$(codex_proxy_repo_dir)"
    pid_file="$repo_dir/cc-proxy.pid"

    if [ -f "$pid_file" ]; then
        local pid
        pid="$(cat "$pid_file")"
        if [ -n "$pid" ] && kill "$pid" 2>/dev/null; then
            rm -f "$pid_file"
            cc_proxy_unset_claude_env
            echo "CC_PROXY stopped"
            return 0
        fi
    fi

    pkill -f "$repo_dir/cli-proxy-api --config $repo_dir/config.yaml" 2>/dev/null && {
        rm -f "$pid_file"
        cc_proxy_unset_claude_env
        echo "CC_PROXY stopped"
        return 0
    }

    cc_proxy_unset_claude_env
    echo "CC_PROXY is not running"
    return 1
}

cc_proxy_status() {
    local repo_dir pid_file log_file pid

    repo_dir="$(codex_proxy_repo_dir)"
    pid_file="$repo_dir/cc-proxy.pid"
    log_file="$repo_dir/cc-proxy.log"

    if [ -f "$pid_file" ]; then
        pid="$(cat "$pid_file")"
        if [ -n "$pid" ] && kill -0 "$pid" 2>/dev/null; then
            echo "CC_PROXY is running (PID $pid)"
            echo "Logs: $log_file"
            if [ "${CLAUDE_PROXY_ACTIVE:-}" = "1" ]; then
                echo "Claude proxy env: armed (opus/sonnet=gpt-5.4, haiku=gpt-5.4-mini)"
            else
                echo "Claude proxy env: not armed"
            fi
            return 0
        fi

        echo "CC_PROXY is not running (stale PID file: $pid_file)"
        return 1
    fi

    echo "CC_PROXY is not running"
    return 1
}

alias CC_PROXY='cc_proxy_start'
alias CC_PROXY_STOP='cc_proxy_stop'
alias CC_PROXY_STATUS='cc_proxy_status'

HELP() {
    local reset bold cyan green yellow dim root_dir repo_dir

    if [ -t 1 ]; then
        reset=$'\033[0m'
        bold=$'\033[1m'
        cyan=$'\033[36m'
        green=$'\033[32m'
        yellow=$'\033[33m'
        dim=$'\033[2m'
    fi

    root_dir="$(codex_proxy_for_claudecode_root)"
    repo_dir="$(codex_proxy_repo_dir)"

    printf '%b%s%b\n' "${bold}${cyan}" 'codex_proxy_for_claudecode' "$reset"
    printf '%b\n' "${dim}Root: ${root_dir}${reset}"
    printf '%b\n' "${dim}CLIProxyAPI: ${repo_dir}${reset}"
    printf '%b\n' "${dim}Run ./scripts/bootstrap.sh to refresh the symlink.${reset}"
    printf '\n'
    printf '%b%s%b\n' "${bold}${green}" 'Aliases' "$reset"
    printf '  %b%-16s%b %s\n' "$yellow" 'CC_PROXY' "$reset" 'Start the proxy'
    printf '  %b%-16s%b %s\n' "$yellow" 'CC_PROXY_STOP' "$reset" 'Stop the proxy'
    printf '  %b%-16s%b %s\n' "$yellow" 'CC_PROXY_STATUS' "$reset" 'Show status'
}
