#!/bin/bash
# download.sh — Oh My Posh 本体とテーマのダウンロード

INSTALL_DIR="$HOME/.local/bin"
THEME_DIR="$HOME/.poshthemes"
GITHUB_RELEASE="https://github.com/JanDeDobbeleer/oh-my-posh/releases/latest/download"

# Oh My Posh 本体のインストール
install_oh_my_posh() {
    local os arch binary_name

    os="$(detect_os)"   || return 1
    arch="$(detect_arch)" || return 1
    binary_name="posh-${os}-${arch}"

    log_info "Oh My Posh をダウンロード中... (${os}/${arch})"

    mkdir -p "$INSTALL_DIR"

    if ! download_file "${GITHUB_RELEASE}/${binary_name}" "${INSTALL_DIR}/oh-my-posh"; then
        log_error "Oh My Posh のダウンロードに失敗しました。"
        return 1
    fi

    chmod +x "${INSTALL_DIR}/oh-my-posh"
    log_info "Oh My Posh を ${INSTALL_DIR}/oh-my-posh にインストールしました。"

    # PATH に含まれていなければ警告
    if [[ ":$PATH:" != *":${INSTALL_DIR}:"* ]]; then
        log_warn "${INSTALL_DIR} が PATH に含まれていません。シェル設定で追加されます。"
    fi
}

# テーマファイルの一括ダウンロード
download_themes() {
    local zip_path="${THEME_DIR}/themes.zip"

    log_info "テーマファイルをダウンロード中..."

    mkdir -p "$THEME_DIR"

    if ! download_file "${GITHUB_RELEASE}/themes.zip" "$zip_path"; then
        log_error "テーマのダウンロードに失敗しました。"
        return 1
    fi

    unzip -o "$zip_path" -d "$THEME_DIR" >/dev/null
    chmod u+rw "$THEME_DIR"/*.omp.* 2>/dev/null
    rm -f "$zip_path"

    log_info "テーマを ${THEME_DIR} に展開しました。"
}
