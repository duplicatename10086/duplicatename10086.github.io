+++
title = '用 Hugo + GitHub Pages 搭一个博客'
date = 2026-11-02T08:20:00+08:00
draft = false
summary = '从零到上线：Hugo 建站、PaperMod 主题、GitHub Actions 自动发布，以及几个最容易踩的坑。'
tags = ['Hugo', 'GitHub Pages', '教程']
ShowToc = true
tocopen = false

[cover]
  image = 'images/covers/hugo.png'
  alt = 'Hugo 与 GitHub Pages 封面'
+++

这篇记录这个博客本身是怎么搭起来的。整体链路很短：

```text
Markdown 文章 → Hugo 生成静态 HTML → git push → GitHub Actions → GitHub Pages 上线
```

跟着做一遍，大约半小时。下面以 Windows 为例，macOS / Linux 的命令会单独标注。

## 1. 安装 Hugo

Windows 推荐用 winget：

```powershell
winget install Hugo.Hugo.Extended
```

macOS：

```bash
brew install hugo
```

验证：

```bash
hugo version
```

输出里带 `+extended` 最好。PaperMod 的一些图片处理功能需要 extended 版本。

## 2. 创建站点

```bash
hugo new site my-blog
cd my-blog
git init
```

目录结构大概是这样：

```text
my-blog/
├── archetypes/       # 新文章的模板
├── content/          # Markdown 正文
├── layouts/          # 自定义模板（可覆盖主题）
├── static/           # 原样复制的静态文件
├── themes/           # 主题
└── hugo.toml         # 站点配置
```

## 3. 安装 PaperMod

官方推荐用 submodule：

```bash
git submodule add https://github.com/adityatelange/hugo-PaperMod themes/PaperMod
```

但如果你主要用 GitHub Desktop，submodule 偶尔会让人困惑：克隆下来主题目录是空的。  
这个博客的做法是**直接把主题文件放进仓库**，少一层依赖，GitHub Desktop 也不用额外操作。

如果要更新主题，重新下载一次覆盖 `themes/PaperMod` 即可。

## 4. 最小配置

`hugo.toml` 里至少要有这些：

```toml
baseURL = 'https://你的用户名.github.io/'
locale = 'zh-cn'
title = '我的博客'
theme = 'PaperMod'

[params]
  description = '记录学习与生活'
  defaultTheme = 'auto'
  ShowReadingTime = true
  ShowCodeCopyButtons = true
```

> **注意**：`baseURL` 结尾一定要有 `/`。写错的话，CSS 和图片会加载不出来，页面退化成纯文本——这是最常见的一个坑。

Hugo 新版用 `locale` 代替旧的 `languageCode`。如果你的 Hugo 版本较老，把 `locale` 换成 `languageCode`。

## 5. 写第一篇文章

```bash
hugo new content posts/hello.md
```

打开生成的文件，把 `draft` 改成 `false`：

```toml
+++
title = '你好，世界'
date = 2026-11-01T20:00:00+08:00
draft = false
tags = ['随笔']
+++

我的第一篇博客。
```

本地预览：

```bash
hugo server -D
```

浏览器打开 `http://localhost:1313`。改文件会自动刷新，`-D` 表示连草稿一起显示。

## 6. 推送到 GitHub

在 GitHub 新建仓库，仓库名用：

```text
你的用户名.github.io
```

这样站点地址就是 `https://你的用户名.github.io/`。如果仓库叫 `blog`，地址会变成 `https://你的用户名.github.io/blog/`，`baseURL` 也要跟着加 `/blog/`。

用 GitHub Desktop 的话：

1. `File → Add Local Repository`，选中 `my-blog` 文件夹；
2. 左上角 `Publish repository`；
3. 仓库名填 `你的用户名.github.io`，取消勾选 `Keep this code private`；
4. 点 `Publish repository`。

用命令行的话：

```bash
git add .
git commit -m "init blog"
git branch -M main
git remote add origin https://github.com/你的用户名/你的用户名.github.io.git
git push -u origin main
```

## 7. 配置自动构建

在仓库里新建 `.github/workflows/hugo.yml`：

```yaml
name: Deploy Hugo site to Pages

on:
  push:
    branches: [main]
  workflow_dispatch:

permissions:
  contents: read
  pages: write
  id-token: write

concurrency:
  group: pages
  cancel-in-progress: false

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
        with:
          submodules: recursive
      - uses: actions/configure-pages@v5
        id: pages
      - uses: peaceiris/actions-hugo@v3
        with:
          hugo-version: '0.169.0'
          extended: true
      - name: Build
        env:
          BASE_URL: ${{ steps.pages.outputs.base_url }}
        run: hugo --minify --gc --baseURL "${BASE_URL%/}/"
      - uses: actions/upload-pages-artifact@v3
        with:
          path: ./public

  deploy:
    runs-on: ubuntu-latest
    needs: build
    environment:
      name: github-pages
      url: ${{ steps.deployment.outputs.page_url }}
    steps:
      - uses: actions/deploy-pages@v4
        id: deployment
```

这里的 `configure-pages` 会把 Pages 的实际地址输出成 `base_url`，构建时覆盖 Hugo 的 `baseURL`——所以项目仓库、用户站、自定义域名都能自适应，不必每次手改配置。

然后去仓库：

```text
Settings → Pages → Build and deployment → Source
```

选择 **GitHub Actions**。

推送之后，Actions 会自动跑一次。等一分钟左右，访问 `https://你的用户名.github.io/` 就能看到页面。

## 8. 日常写作流程

```bash
hugo new content posts/文章名.md
# 写
hugo server -D
# 预览没问题后
git add .
git commit -m "post: 文章名"
git push
```

GitHub Desktop 里就是 `Commit to main` → `Push origin`，效果一样。

## 常见坑

| 现象 | 原因 | 解决 |
| --- | --- | --- |
| 页面没有样式 | `baseURL` 写错，或结尾少了 `/` | 改成 `https://用户名.github.io/` |
| 主题目录是空的 | submodule 没拉下来 | `git submodule update --init --recursive` |
| Actions 找不到主题 | checkout 时没拉 submodule | 加 `submodules: recursive` |
| 404 | 仓库名和 `baseURL` 不一致 | 检查是否多了 `/blog/` 子路径 |
| 推送要密码 | GitHub 不再支持密码推送 | 用 GitHub Desktop，或 Personal Access Token |
| 国内访问慢 | GitHub Pages 的 CDN 在境外 | 可以再加一个 Cloudflare Pages 部署 |

## 最后

博客搭好只是开始。真正难的是持续写，以及接受“暂时写得不够好”。

先把第一篇发出去，剩下的再慢慢来。
