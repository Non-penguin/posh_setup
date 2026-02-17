# Oh My Posh Auto Installer

Oh My Posh のセットアップを自動化するスクリプトです。

## 対応環境

- **OS**: Linux (amd64/arm64), macOS (amd64/arm64)
- **シェル**: Bash, Zsh, Fish
- **パッケージマネージャ**: apt, yum, pacman, Homebrew

## ファイル構成

```
├── install.sh              # エントリポイント
├── lib/
│   ├── utils.sh            # ログ、OS/Arch検出、コマンドチェック
│   ├── download.sh         # Oh My Posh 本体 + テーマのDL
│   └── shell_config.sh     # シェルRC設定 (bash/zsh/fish)
└── README.md
```

## 使い方

```bash
# 1. リポジトリをクローン
git clone https://github.com/<your-username>/oh-my-posh-install.git
cd oh-my-posh-install

# 2. 実行権限を付与して実行
chmod +x install.sh
./install.sh

# 3. 設定を反映
source ~/.bashrc   # bash の場合
source ~/.zshrc    # zsh の場合
# fish の場合は新しいシェルを開く
```

## 注意事項

- Oh My Posh は `~/.local/bin/` にインストールされます (sudo 不要)
- テーマは `~/.poshthemes/` に展開されます
- 表示を正しくするには [Nerd Font](https://www.nerdfonts.com/) のインストールが必要です
