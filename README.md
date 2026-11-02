# Xuan 的博客

一个用 **Hugo + PaperMod + GitHub Pages** 搭起来的静态博客：文章是 Markdown，推送后由 GitHub Actions 自动编译成网页并发布。

- 站点地址（配置里）：`https://duplicatename10086.github.io/`
- 主题：[PaperMod](https://github.com/adityatelange/hugo-PaperMod)（已放在 `themes/PaperMod`，不需要再拉 submodule）
- 发布方式：GitHub Desktop 推送，或直接在 GitHub 网页上改 Markdown
- 本地预览：`.\scripts\preview.ps1`

> **当前用户名：`duplicatename10086`**
>
> 仓库名需要是 `duplicatename10086.github.io`，站点地址才是 `https://duplicatename10086.github.io/`。
> 如果以后换用户名，按下面的[“换用户名”](#换用户名)重新改。

---

## 1. 日常发布：用 GitHub Desktop

这个仓库已经创建并上线，不需要再新建：

- 仓库：<https://github.com/duplicatename10086/duplicatename10086.github.io>
- 站点：<https://duplicatename10086.github.io/>
- Pages 的 Source 已设为 **GitHub Actions**，每次 push 到 `main` 会自动构建发布。

### 1.1 在这台电脑打开

1. 打开 GitHub Desktop，登录 `duplicatename10086`。
2. 菜单 **File → Add Local Repository…**
3. 选择 `D:\xuan-blog-session\xuan-blog`（里面已有 `.git` 和远程地址）。
4. 如果左侧历史记录能看到 `init blog`，说明仓库已接上，不用再点 Publish。

### 1.2 发布一篇新文章

1. 改 `content/posts/` 里的 Markdown，或按第 2 节在网页上写。
2. 回到 GitHub Desktop，左下角 Summary 填一句说明（如 `new post`）。
3. 点 **Commit to main**。
4. 点顶部 **Push origin**。
5. 打开仓库的 **Actions**，等 `Deploy Hugo site to Pages` 变绿，约 1 分钟。
6. 刷新 <https://duplicatename10086.github.io/>。

> 如果换电脑：在 GitHub Desktop 里用 **File → Clone repository** 克隆这个仓库，不要再用 “Add Local Repository” 指向不存在的本地目录。

---

## 2. 以后怎么写文章

### 方式 A：直接在 GitHub 网页写（最省事）

1. 打开仓库里的 `content/posts/` 目录
2. 右上角 **Add file → Create new file**
3. 文件名例如 `my-first-note.md`
4. 粘贴下面的模板，改标题和正文
5. 点 **Commit changes…**，等 Actions 跑完就上线

```toml
+++
title = "文章标题"
date = 2026-11-02
draft = false
summary = "一句话摘要，会显示在列表里"
tags = ["随笔"]

[cover]
  image = "images/covers/hello.png"
  alt = "封面图说明"
+++

正文从这里开始，用 Markdown 写。
```

几个注意点：

- `draft = false` 才会发布；`true` 是草稿。
- `date` 用 `YYYY-MM-DD`，列表按它排序。
- `tags` 会生成标签页。
- `cover.image` 可以复用 `assets/images/covers/` 里的图，也可以换成自己的图。
- 正文里的图片：先上传到 `static/images/`，再用 `![说明](/images/文件名.png)` 引用。

### 方式 B：本地写，再推送

需要先装 Hugo extended：

```powershell
winget install Hugo.Hugo.Extended
# 或者：scoop install hugo-extended
```

验证：

```powershell
hugo version
# 输出里应该带 +extended
```

新建文章：

```powershell
hugo new content posts/my-first-note.md
```

本地预览（会热更新）：

```powershell
.\scripts\preview.ps1
```

脚本会优先使用 PATH 里的 `hugo`，找不到就用项目同级的 `..\tools\hugo\hugo.exe`；并用 `--renderToMemory` 预览，不会覆盖 `public/`。也可以直接 `hugo server -D`。

打开 <http://localhost:1313>。改完文章后，用 GitHub Desktop 提交、推送即可。

---

## 3. 换用户名（以后可选）

当前已设置为 `duplicatename10086`。如果以后要换：

### 方法一：运行脚本

在 `xuan-blog` 目录打开 PowerShell：

```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\set-username.ps1 -Username 你的新用户名
```

脚本会把：

- `hugo.toml` 里的 `baseURL`
- `hugo.toml` 和 `content/about.md` 里的 GitHub 链接
- `content/about.md` 里的 `@用户名` 链接文字

替换成新用户名。之后把 GitHub 仓库名也改成 `你的新用户名.github.io`。

> 脚本按当前的 `duplicatename10086` 查找替换；改完一次后，如果还要再改，先把脚本里的旧用户名同步成新的。

### 方法二：手动改

打开 `hugo.toml`，改这一行：

```toml
baseURL = 'https://你的新用户名.github.io/'
```

以及 `[params.socialIcons]` 里的 GitHub 链接和 `content/about.md` 里的 GitHub 链接。

> 仓库名必须是 `你的新用户名.github.io`，站点才会在根路径。  
> 如果你故意用项目仓库（例如 `blog`），地址是 `https://你的新用户名.github.io/blog/`；工作流会自动按 Pages 的实际地址覆盖 `baseURL`，但本地预览时建议把 `baseURL` 也改成带 `/blog/` 的完整地址。

---

## 4. 本地预览与构建

```powershell
# 开发服务器，改文件自动刷新（不会覆盖 public/）
.\scripts\preview.ps1

# 只构建，不启动服务器；产物在 public/
hugo --minify
```

站点配置在 `hugo.toml`，主要项：

| 配置 | 作用 |
| --- | --- |
| `baseURL` | 站点根地址，结尾必须有 `/` |
| `title` | 浏览器标题和页头文字 |
| `theme` | 固定为 `PaperMod` |
| `[params.homeInfoParams]` | 首页大标题、简介、引用 |
| `[params.socialIcons]` | 页脚社交图标 |
| `[params.label]` | 左上角头像 + `XUAN` 字样 |
| `[menu]` | 顶部导航 |

---

## 5. 自定义域名（可选）

1. 在域名服务商添加 CNAME 记录，指向 `你的用户名.github.io`
2. 仓库 **Settings → Pages → Custom domain** 填域名并保存
3. 勾选 **Enforce HTTPS**（证书自动签发，免费）

工作流里的 `actions/configure-pages` 会把 `baseURL` 自动设为 Pages 的实际地址，所以换域名后一般不用再改 `hugo.toml`。

---

## 6. 常见问题

| 现象 | 原因 / 解决 |
| --- | --- |
| 页面能打开但没样式 | `baseURL` 写错，或结尾少了 `/`。本地用 `hugo server` 预览；线上工作流会用 Pages 实际地址覆盖 |
| Actions 报错找不到主题 | 主题已直接放在 `themes/PaperMod`，确认这个目录被提交了；不需要 submodule |
| Actions 成功但访问 404 | Pages 的 Source 没选 **GitHub Actions**；或仓库不是 Public；或仓库名和用户名不一致 |
| 推送要密码 | 用 GitHub Desktop 登录，或创建 Personal Access Token 代替密码 |
| 国内访问慢 | 可以把仓库同步到 Cloudflare Pages / Vercel，构建命令 `hugo --minify`，输出目录 `public` |
| 搜索没结果 | 搜索依赖构建生成的 `index.json`；等线上构建完成后再试，本地 `hugo server` 也可能有延迟 |
| 改了文章没更新 | 看 Actions 是否成功；CDN 缓存通常 1 分钟内刷新 |

---

## 7. 目录结构

```text
xuan-blog/
├─ .github/workflows/hugo.yml   # 自动构建 + 发布到 Pages
├─ archetypes/default.md        # 新文章模板
├─ assets/
│  ├─ css/extended/custom.css   # 自定义样式（主题之后加载）
│  └─ images/                   # 头像、封面源图
├─ content/
│  ├─ posts/                    # 文章
│  ├─ about.md                  # 关于页
│  ├─ archives.md               # 归档页
│  └─ search.md                 # 搜索页
├─ scripts/
│  ├─ set-username.ps1          # 一键改用户名
│  └─ preview.ps1               # 本地预览（不会覆盖 public/）
├─ static/
│  ├─ images/                   # 头像、默认 OG 图
│  └─ favicon*.png              # 站点图标
├─ themes/PaperMod/             # 主题（已内置）
├─ hugo.toml                    # 站点配置
└─ README.md
```

---

## 8. 发布前检查清单

- [ ] `hugo.toml` 的 `baseURL` 和 GitHub 用户名一致，结尾有 `/`
- [ ] 仓库是 **Public**
- [ ] 仓库名是 `用户名.github.io`（或接受 `/blog/` 子路径）
- [ ] **Settings → Pages → Source** 已选 **GitHub Actions**
- [ ] Actions 里 `Deploy Hugo site to Pages` 是绿色
- [ ] 首页、文章页、关于页、标签页都能打开
- [ ] 手机上看一眼，封面和导航没有溢出

---

主题基于 [PaperMod](https://github.com/adityatelange/hugo-PaperMod)（MIT），由 [Hugo](https://gohugo.io/) 生成，GitHub Pages 托管。
