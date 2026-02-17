#!/bin/bash
set -euo pipefail

# スクリプトのディレクトリを基準にlibを読み込む
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/lib/utils.sh"
source "${SCRIPT_DIR}/lib/download.sh"
source "${SCRIPT_DIR}/lib/shell_config.sh"

main() {
    log_info "Oh My Posh の自動セットアップを開始します..."

    # 1. 依存コマンドの確認
    ensure_command unzip

    # 2. Oh My Posh 本体のインストール
    install_oh_my_posh

    # 3. テーマのダウンロード
    download_themes

    # 4. シェル設定の追記
    configure_shell

    # 5. 完了メッセージ
    echo "---"
    log_info "セットアップが完了しました!"

    local shell_type rc_file
    shell_type="$(detect_shell)"
    rc_file="$(get_rc_file "$shell_type")"

    echo ""
    echo "次のコマンドを実行して設定を反映させてください:"
    echo "  source ${rc_file}"
    echo ""
    echo "Nerd Font を VS Code や Windows Terminal に設定することを忘れないでください。"
    echo "  https://www.nerdfonts.com/"
}

main "$@"
