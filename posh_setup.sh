#!/bin/bash

echo "🚀 Oh My Posh の自動セットアップを開始します..."

# OSとアーキテクチャの自動検出を追加
OS_TYPE=$(uname -s | tr '[:upper:]' '[:lower:]')
ARCH_TYPE=$(uname -m)

case "$ARCH_TYPE" in
    x86_64) ARCH_TYPE="amd64" ;;
    aarch64|arm64) ARCH_TYPE="arm64" ;;
esac

# 依存パッケージの確認 (unzip) 微修正
if ! command -v unzip &> /dev/null; then
    echo "📦 unzip が見つかりません。インストールしています..."
    if [ "$OS_TYPE" = "linux" ] && command -v apt &> /dev/null; then
        sudo apt update && sudo apt install -y unzip
    fi
fi

# Oh My Posh 本体のインストール
echo "📥 Oh My Posh ($OS_TYPE-$ARCH_TYPE) をダウンロード中..."
sudo curl -L "https://github.com/JanDeDobbeleer/oh-my-posh/releases/latest/download/posh-${OS_TYPE}-${ARCH_TYPE}" -o /usr/local/bin/oh-my-posh
sudo chmod +x /usr/local/bin/oh-my-posh

# テーマ用フォルダの作成とダウンロード
echo "🎨 テーマファイルを一括ダウンロード中..."
mkdir -p ~/.poshthemes
curl -L https://github.com/JanDeDobbeleer/oh-my-posh/releases/latest/download/themes.zip -o ~/.poshthemes/themes.zip
unzip -o ~/.poshthemes/themes.zip -d ~/.poshthemes
chmod u+rw ~/.poshthemes/*.omp.*
rm ~/.poshthemes/themes.zip

# シェルの設定ファイルへの追記 (Bash または Zsh)
# 現在のシェルを特定
TARGET_RC=""
if [ -n "$ZSH_VERSION" ] || [ -f "$HOME/.zshrc" ]; then
    TARGET_RC="$HOME/.zshrc"
    SHELL_TYPE="zsh"
else
    TARGET_RC="$HOME/.bashrc"
    SHELL_TYPE="bash"
fi

echo "📝 $TARGET_RC に設定を追記しています..."

# 重複追記を防ぐチェック
if ! grep -q "oh-my-posh init" "$TARGET_RC"; then
    echo "" >> "$TARGET_RC"
    echo "# Oh My Posh Setup" >> "$TARGET_RC"
    echo "eval \"\$(oh-my-posh init $SHELL_TYPE --config ~/.poshthemes/jandedobbeleer.omp.json)\"" >> "$TARGET_RC"
    echo "✅ 設定を追記しました。"
else
    echo "⚠️ 既に設定が記述されているため、追記をスキップしました。"
fi

echo "---"
echo "✨ セットアップが完了しました！"
echo "💡 次のコマンドを実行して設定を反映させてください:"
echo "source $TARGET_RC"
echo ""
echo "❗ 忘れないで！ VS CodeやWindows Terminalで「Nerd Font」を設定してください。"