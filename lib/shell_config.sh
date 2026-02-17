#!/bin/bash
# shell_config.sh — シェル検出とRC設定

INSTALL_DIR="$HOME/.local/bin"
THEME_DIR="$HOME/.poshthemes"
DEFAULT_THEME="jandedobbeleer.omp.json"

# 現在のシェルを検出
detect_shell() {
    local shell_name
    shell_name="$(basename "$SHELL")"
    case "$shell_name" in
        bash|zsh|fish) echo "$shell_name" ;;
        *)
            log_warn "未対応のシェル: $shell_name (bashとして扱います)"
            echo "bash"
            ;;
    esac
}

# シェルのRCファイルパスを返す
get_rc_file() {
    local shell_type="$1"
    case "$shell_type" in
        bash) echo "$HOME/.bashrc" ;;
        zsh)  echo "$HOME/.zshrc" ;;
        fish) echo "$HOME/.config/fish/config.fish" ;;
    esac
}

# Oh My Posh の init 行を生成
generate_init_line() {
    local shell_type="$1"
    local theme_path="${THEME_DIR}/${DEFAULT_THEME}"

    case "$shell_type" in
        bash|zsh)
            echo "eval \"\$(${INSTALL_DIR}/oh-my-posh init ${shell_type} --config ${theme_path})\""
            ;;
        fish)
            echo "${INSTALL_DIR}/oh-my-posh init fish --config ${theme_path} | source"
            ;;
    esac
}

# PATH追加行を生成
generate_path_line() {
    local shell_type="$1"
    case "$shell_type" in
        bash|zsh)
            echo "export PATH=\"${INSTALL_DIR}:\$PATH\""
            ;;
        fish)
            echo "fish_add_path ${INSTALL_DIR}"
            ;;
    esac
}

# シェル設定を追記
configure_shell() {
    local shell_type rc_file init_line path_line

    shell_type="$(detect_shell)"
    rc_file="$(get_rc_file "$shell_type")"
    init_line="$(generate_init_line "$shell_type")"
    path_line="$(generate_path_line "$shell_type")"

    log_info "${rc_file} に設定を追記しています..."

    # fish の場合、ディレクトリがなければ作成
    if [[ "$shell_type" == "fish" ]]; then
        mkdir -p "$(dirname "$rc_file")"
    fi

    # RCファイルがなければ作成
    touch "$rc_file"

    # PATH が RC ファイルに記述されていなければ追加
    if ! grep -q "${INSTALL_DIR}" "$rc_file" 2>/dev/null; then
        log_info "${INSTALL_DIR} を PATH に追加しています..."
        {
            echo ""
            echo "# Oh My Posh PATH"
            echo "$path_line"
        } >> "$rc_file"
    fi

    # 重複追記を防ぐ
    if grep -q "oh-my-posh init" "$rc_file" 2>/dev/null; then
        log_warn "既に Oh My Posh の設定が記述されているため、init行の追記をスキップしました。"
        return 0
    fi

    {
        echo ""
        echo "# Oh My Posh Setup"
        echo "$init_line"
    } >> "$rc_file"

    log_info "設定を追記しました。(シェル: ${shell_type})"
}
