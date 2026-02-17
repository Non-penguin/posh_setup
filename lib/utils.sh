#!/bin/bash
# utils.sh — ログ出力、OS/Arch検出、コマンドチェック

# ログ関数
log_info()  { echo "[INFO]  $*"; }
log_warn()  { echo "[WARN]  $*" >&2; }
log_error() { echo "[ERROR] $*" >&2; }

# OS検出 (linux / darwin)
detect_os() {
    local os
    os="$(uname -s | tr '[:upper:]' '[:lower:]')"
    case "$os" in
        linux)  echo "linux" ;;
        darwin) echo "darwin" ;;
        *)
            log_error "未対応のOS: $os"
            return 1
            ;;
    esac
}

# アーキテクチャ検出 (amd64 / arm64)
detect_arch() {
    local arch
    arch="$(uname -m)"
    case "$arch" in
        x86_64)          echo "amd64" ;;
        aarch64|arm64)   echo "arm64" ;;
        *)
            log_error "未対応のアーキテクチャ: $arch"
            return 1
            ;;
    esac
}

# コマンド存在チェック
check_command() {
    command -v "$1" &>/dev/null
}

# 必須コマンドの確認・インストール
ensure_command() {
    local cmd="$1"
    if check_command "$cmd"; then
        return 0
    fi

    log_warn "$cmd が見つかりません。インストールを試みます..."

    local os
    os="$(detect_os)" || return 1

    case "$os" in
        linux)
            if check_command apt; then
                sudo apt update && sudo apt install -y "$cmd"
            elif check_command yum; then
                sudo yum install -y "$cmd"
            elif check_command pacman; then
                sudo pacman -S --noconfirm "$cmd"
            else
                log_error "パッケージマネージャが見つかりません。$cmd を手動でインストールしてください。"
                return 1
            fi
            ;;
        darwin)
            if check_command brew; then
                brew install "$cmd"
            else
                log_error "Homebrew が見つかりません。$cmd を手動でインストールしてください。"
                return 1
            fi
            ;;
    esac

    if ! check_command "$cmd"; then
        log_error "$cmd のインストールに失敗しました。"
        return 1
    fi

    log_info "$cmd をインストールしました。"
}

# HTTP ダウンロード (curl優先、wgetフォールバック)
download_file() {
    local url="$1"
    local output="$2"

    if check_command curl; then
        curl -fsSL "$url" -o "$output"
    elif check_command wget; then
        wget -q "$url" -O "$output"
    else
        log_error "curl も wget も見つかりません。いずれかをインストールしてください。"
        return 1
    fi
}
