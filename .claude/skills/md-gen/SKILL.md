---
name: md-gen
description: 从 PDF、PPT、DOCX、DOC 文件生成 Markdown 文档。使用 markitdown 工具将各种文档格式转换为 Markdown。在需要将 PDF、PowerPoint、Word 文档转换为 Markdown 格式时使用。
allowed-tools:
  - Bash
---

# Markdown 文档生成

将 PDF、PPT、DOCX、DOC 文件转换为 Markdown 格式。

## 快速开始

```bash
# 1. 安装 markitdown（如果尚未安装）
bash .claude/skills/md-gen/script/install_markitdown_venv.sh

# 2. 激活虚拟环境
source .venv/bin/activate

# 3. 转换文档
markitdown your-document.pdf > your-document.md
```

## 设置环境

### 安装环境

```bash
bash .claude/skills/md-gen/script/install_markitdown_venv.sh
```

### 激活环境

markitdown 安装在虚拟环境中，使用时需要激活环境：

```bash
source .venv/bin/activate
```

## 支持的文件格式

- PDF 文件：`.pdf`
- PowerPoint 文件：`.ppt`, `.pptx`
- Word 文件：`.doc`, `.docx`

## 使用方法

### 基本转换

```bash
# 激活虚拟环境
source .venv/bin/activate

# 转换 PDF 文件
markitdown path-to-file.pdf > path-to-file.md

# 转换 Word 文件
markitdown path-to-file.doc > path-to-file.md
markitdown path-to-file.docx > path-to-file.md

# 转换 PowerPoint 文件
markitdown path-to-file.ppt > path-to-file.md
markitdown path-to-file.pptx > path-to-file.md
```

### 批量转换

```bash
# 激活虚拟环境
source .venv/bin/activate

# 转换当前目录下所有 PDF 文件
for file in *.pdf; do
    markitdown "$file" > "${file%.pdf}.md"
done

# 转换当前目录下所有 Word 文件
for file in *.docx; do
    markitdown "$file" > "${file%.docx}.md"
done
```

## 输出文件命名

输出文件名与输入文件名相同，扩展名改为 `.md`。例如：
- `document.pdf` → `document.md`
- `presentation.pptx` → `presentation.md`
- `report.docx` → `report.md`

## 注意事项

1. 确保 markitdown 已正确安装（运行 setup.sh）
2. 输出文件将覆盖同名的现有 Markdown 文件
3. 转换质量取决于原始文档的格式和内容复杂度
4. 对于扫描的 PDF，可能需要额外的 OCR 处理