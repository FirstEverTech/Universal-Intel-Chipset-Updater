# 星标历史图（Star History Graph）—— 配置

1. 创建 `.github/workflows/star-history.yml` —— 从 `FirstEverTech/Universal-Intel-Chipset-Updater` 复制
2. 创建 `.github/scripts/generate_star_history.py` —— 从同一仓库复制
3. 创建 `assets/.gitkeep` —— 空文件

**Actions → Generate Star History → Run workflow（运行工作流）**

添加到 `README.md`：
![Star History](assets/star-history.svg)

无需任何配置——仓库会通过 `github.repository` 自动识别。
