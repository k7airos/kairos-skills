# herdr：每次回到提示符时，把「目录 · 分支」推给侧栏（仅在 herdr 窗格内生效）
# 追加到 ~/.zshrc 末尾之前先备份，并让用户确认。
if [[ "$HERDR_ENV" == 1 && -x "$HOME/.config/herdr/report-location.sh" ]]; then
  _herdr_report_location() { "$HOME/.config/herdr/report-location.sh" >/dev/null 2>&1 &! }
  autoload -Uz add-zsh-hook
  add-zsh-hook precmd _herdr_report_location
fi
