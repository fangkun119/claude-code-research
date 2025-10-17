# Claude Code Agent  Skills：创建、管理和共享模块化AI能力的完整指南

> 创建、管理和共享 Skill 以扩展Claude在Claude Code中的能力。

## 1. 概述与基础概念

### 1.1 Agent  Skills简介

**本指南的核心目的是**向您展示如何在Claude Code中创建、使用和管理Agent  Skills。

**具体来说**， Skills具备以下核心特征：
*  Skills是模块化功能，通过包含指令、脚本和资源的组织文件夹扩展Claude的功能
* 支持个人、项目和插件三种不同的 Skill 类型
* 通过模型自动调用机制，无需用户显式触发

### 1.2 前置条件

**使用Agent  Skills需要满足以下基本要求**：
* Claude Code版本1.0或更高版本
* 对[Claude Code](/en/docs/claude-code/quickstart)的基本熟悉

### 1.3 什么是Agent  Skills？

#### 1.3.1 核心定义与组成

**从本质上讲**，Agent  Skills将专业知识打包成可发现的功能。

**具体构成包括**：
* 一个`SKILL.md`文件，包含Claude在相关时读取的指令
* 可选的支持文件，如脚本和模板
* 模块化的组织结构，便于管理和复用

#### 1.3.2  Skill 调用方式

**Skills采用独特的模型调用机制**：
*  Skills是**模型调用的**—Claude根据您的请求和 Skill 的描述自主决定何时使用它们
* **与此不同**，斜杠命令是**用户调用的**（您显式输入`/command`来触发它们）
* 这种机制使 Skill 使用更加智能和自然

#### 1.3.3 主要优势

**因此，Agent  Skills具备以下核心优势**：
* **为您的特定工作流扩展Claude的能力**，实现个性化定制
* **通过git在团队间共享专业知识**，促进知识沉淀和传播
* **从而减少重复提示**，提高工作效率
* **最终为复杂任务组合多个 Skills**，构建强大的工作流

**进一步了解**，请访问[Agent  Skills概述](/en/docs/agents-and-tools/agent-skills/overview)。

<Note>
  **要深入了解**Agent  Skills的架构和实际应用，请阅读我们的工程博客：[Equipping agents for the real world with Agent  Skills](https://www.anthropic.com/engineering/equipping-agents-for-the-real-world-with-agent-skills)。
</Note>

## 2. 创建Agent  Skills

### 2.1 基本存储结构

**Skills的基础存储原则很简单**：
*  Skills存储为包含`SKILL.md`文件的目录
* 支持附加文件和脚本的灵活组织

### 2.2 个人 Skills

#### 2.2.1 存储位置

**个人 Skills在您的所有项目中都可用**：
* **因此**，将它们存储在`~/.claude/skills/`中：

```bash  theme={null}
mkdir -p ~/.claude/skills/my-skill-name
```

#### 2.2.2 使用场景

**使用个人 Skills适用于以下场景**：
* 您的个人工作流和偏好
* 您正在开发的实验性 Skills
* 个人生产力工具

### 2.3 项目 Skills

#### 2.3.1 存储位置

**项目 Skills与您的团队共享**：
* **因此**，将它们存储在项目内的`.claude/skills/`中：

```bash  theme={null}
mkdir -p .claude/skills/my-skill-name
```

#### 2.3.2 使用场景

**使用项目 Skills适用于以下需求**：
* 团队工作流和约定
* 项目特定专业知识
* 共享实用程序和脚本

#### 2.3.3 团队协作特性

**因为**项目 Skills被检入git，**所以**自动对团队成员可用，实现了知识的自然传播。

### 2.4 插件 Skills

**插件 Skills提供了第三种 Skill 来源**：
*  Skills也可以来自[Claude Code插件](/en/docs/claude-code/plugins)
* **具体来说**，插件可能捆绑在插件安装时自动可用的 Skills
* **由此可见**，这些 Skills与个人和项目 Skills的工作方式相同

## 3. 编写SKILL.md文件

### 3.1 基本格式要求

**创建SKILL.md需要遵循标准格式**：

```yaml  theme={null}
---
name: your-skill-name
description: Brief description of what this  Skill  does and when to use it
---

# Your  Skill  Name

## Instructions
Provide clear, step-by-step guidance for Claude.

## Examples
Show concrete examples of using this  Skill .
```

### 3.2 字段要求

**SKILL.md包含以下必需字段**：
* `name`：**必须**仅使用小写字母、数字和连字符（最多64个字符）
* `description`：简要说明 Skill 的功能以及何时使用它（最多1024个字符）

#### 3.2.1 描述字段的重要性

**description字段对于Claude发现何时使用您的 Skill **至关重要**。

**具体来说**，描述应该包含以下要素：
*  Skill 的具体功能
* Claude何时应该使用它
* 用户可能提及的关键术语

**获取更多指导**，请参考[最佳实践指南](/en/docs/agents-and-tools/agent-skills/best-practices)中的完整作者指导，包括验证规则。

## 4. 添加支持文件

### 4.1 目录结构

** Skill 支持灵活的文件组织结构**：

```
my-skill/
├── SKILL.md (required)
├── reference.md (optional documentation)
├── examples.md (optional examples)
├── scripts/
│   └── helper.py (optional utility)
└── templates/
    └── template.txt (optional template)
```

### 4.2 文件引用方式

**从SKILL.md中引用支持文件的方法**：

````markdown  theme={null}
For advanced usage, see [reference.md](reference.md).

Run the helper script:
```bash
python scripts/helper.py input.txt
```
````

### 4.3 加载机制

**Claude采用智能的按需加载机制**：
* **因为**Claude仅在需要时读取这些文件，**所以**使用渐进式披露来有效管理上下文
* 这种机制确保了性能优化和资源合理使用

## 5. 工具访问权限控制

### 5.1 使用allowed-tools限制工具访问

**allowed-tools字段提供了精细的权限控制**：

```yaml  theme={null}
---
name: safe-file-reader
description: Read files without making changes. Use when you need read-only file access.
allowed-tools: Read, Grep, Glob
---

# Safe File Reader

This  Skill  provides read-only file access.

## Instructions
1. Use Read to view file contents
2. Use Grep to search within files
3. Use Glob to find files by pattern
```

### 5.2 应用场景

**当此 Skill 激活时**，Claude只能使用指定的工具（Read、Grep、Glob），无需请求许可。

**这种机制适用于以下重要场景**：
* **因为**不应修改文件的只读 Skills，确保数据安全
* **所以**范围有限的 Skills（例如，仅数据分析，无文件写入），防止意外操作
* **因此**您希望限制功能的安全敏感工作流，保护系统安全

### 5.3 权限模型

**标准权限模型的工作方式**：
* **如果**未指定`allowed-tools`，Claude将按照标准权限模型正常请求使用工具的权限
* 这种设计保持了灵活性和安全性的平衡

<Note>
  **值得注意的是**，`allowed-tools`仅在Claude Code中的 Skills受支持。
</Note>

## 6. 查看可用 Skills

### 6.1  Skill 来源

**从技术角度**，Claude从三个来源自动发现 Skills：
* 个人 Skills：`~/.claude/skills/`
* 项目 Skills：`.claude/skills/`
* 插件 Skills：与已安装插件捆绑

### 6.2 查看所有可用 Skills

**要查看所有可用 Skills**，直接询问Claude：

```
What  Skills are available?
```

或

```
List all available  Skills
```

**这将显示**来自所有来源的所有 Skills，包括插件 Skills，提供完整的 Skill 概览。

### 6.3 检查特定 Skill 

**要检查特定 Skill **，您也可以检查文件系统：

```bash  theme={null}
# List personal  Skills
ls ~/.claude/skills/

# List project  Skills (if in a project directory)
ls .claude/skills/

# View a specific  Skill 's content
cat ~/.claude/skills/my-skill/SKILL.md
```

## 7. 测试 Skills

### 7.1 测试方法

**创建 Skill 后**，通过询问与您的描述匹配的问题来测试它。

**以**如果您的描述提到"PDF文件"**为例**：

```
Can you help me extract text from this PDF?
```

### 7.2 自动激活机制

**因为**Claude自主决定使用您的 Skill （如果它与请求匹配），**所以**您不需要显式调用它。

**由此可见**， Skill 基于您问题的上下文自动激活，提供了自然的交互体验。

## 8. 调试 Skills

### 8.1 常见问题排查

**如果**Claude不使用您的 Skill ，请检查这些常见问题：

#### 8.1.1 使描述具体化

**描述的具体性直接影响 Skill 的发现**：

**太模糊**（会导致发现困难）：
```yaml  theme={null}
description: Helps with documents
```

**具体**（提高发现准确性）：
```yaml  theme={null}
description: Extract text and tables from PDF files, fill forms, merge documents. Use when working with PDF files or when the user mentions PDFs, forms, or document extraction.
```

**在描述中**，您应该包含以下关键要素：
*  Skill 的具体功能
* 使用场景说明
* 用户可能提及的关键术语

#### 8.1.2 验证文件路径

**正确的文件路径是 Skill 加载的基础**：

**个人 Skills**：`~/.claude/skills/skill-name/SKILL.md`
**项目 Skills**：`.claude/skills/skill-name/SKILL.md`

**要检查**文件是否存在：

```bash  theme={null}
# Personal
ls ~/.claude/skills/my-skill/SKILL.md

# Project
ls .claude/skills/my-skill/SKILL.md
```

#### 8.1.3 检查YAML语法

**因为**无效的YAML会阻止 Skill 加载，**所以**需要验证前置内容：

```bash  theme={null}
cat SKILL.md | head -n 10
```

**确保**满足以下YAML格式要求：
* 第1行有开头的`---`
* Markdown内容前有结尾的`---`
* 有效的YAML语法（无制表符，正确的缩进）

#### 8.1.4 查看错误

**以调试模式**运行Claude Code以查看 Skill 加载错误：

```bash  theme={null}
claude --debug
```

## 9. 与团队共享 Skills

### 9.1 推荐方法

**通过插件分发 Skills是最推荐的方法**。

**要通过插件共享 Skills**，需要执行以下步骤：
1. **首先**，在`skills/`目录中创建带有 Skills的插件
2. **然后**，将插件添加到市场
3. **最后**，团队成员安装插件

**获取完整指导**，请参阅[将 Skills添加到您的插件](/en/docs/claude-code/plugins#add-skills-to-your-plugin)。

### 9.2 直接通过项目仓库共享

#### 9.2.1 第1步：将 Skill 添加到您的项目

**创建项目 Skill 的基本操作**：

```bash  theme={null}
mkdir -p .claude/skills/team-skill
# Create SKILL.md
```

#### 9.2.2 第2步：提交到git

**将 Skill 纳入版本控制**：

```bash  theme={null}
git add .claude/skills/
git commit -m "Add team  Skill  for PDF processing"
git push
```

#### 9.2.3 第3步：团队成员自动获取 Skills

**团队协作的自动同步机制**：
* **当**团队成员拉取最新更改时， Skills立即可用：

```bash  theme={null}
git pull
claude  #  Skills are now available
```

## 10. 更新 Skills

### 10.1 直接编辑方法

**更新 Skill 内容的方法很直接**：

```bash  theme={null}
# Personal  Skill 
code ~/.claude/skills/my-skill/SKILL.md

# Project  Skill 
code .claude/skills/my-skill/SKILL.md
```

### 10.2 更新生效时间

**理解 Skill 更新的生效时机很重要**：
* **因为**更改在下次启动Claude Code时生效，**所以**如果Claude Code已在运行，请重新启动它以加载更新
* 这种设计确保了配置的一致性和可预测性

## 11. 删除 Skills

### 11.1 删除操作

**要**删除 Skill 目录，请执行以下操作：

```bash  theme={null}
# Personal
rm -rf ~/.claude/skills/my-skill

# Project
rm -rf .claude/skills/my-skill
git commit -m "Remove unused  Skill "
```

## 12. 最佳实践

### 12.1 保持 Skills专注

#### 12.1.1 单一能力原则

**从设计原则出发**，一个 Skill 应该解决一个功能。

**推荐的专注型 Skill 示例**：
* "PDF表单填写"
* "Excel数据分析"
* "Git提交消息"

**避免的宽泛型 Skill 示例**：
* "文档处理"（拆分为单独的 Skills）
* "数据工具"（按数据类型或操作拆分）

### 12.2 编写清晰的描述

#### 12.2.1 帮助Claude发现使用时机

**通过**在描述中包含特定触发器，**可以**帮助Claude发现何时使用 Skills。

**清晰描述的示例**：
```yaml  theme={null}
description: Analyze Excel spreadsheets, create pivot tables, and generate charts. Use when working with Excel files, spreadsheets, or analyzing tabular data in .xlsx format.
```

**模糊描述的问题示例**：
```yaml  theme={null}
description: For files
```

### 12.3 与团队测试

**建议**让团队成员使用 Skills并提供反馈，重点关注以下方面：
*  Skill 在预期时是否激活？
* 指令是否清晰？
* 是否有缺失的示例或边缘情况？

### 12.4 记录 Skill 版本

**为了便于维护**，您可以在SKILL.md内容中记录 Skill 版本以跟踪随时间的变化。

**具体来说**，添加版本历史部分：

```markdown  theme={null}
# My  Skill 

## Version History
- v2.0.0 (2025-10-01): Breaking changes to API
- v1.1.0 (2025-09-15): Added new features
- v1.0.0 (2025-09-01): Initial release
```

**这个例子清楚地表明**，这有助于团队成员了解版本之间的变化。

## 13. 故障排除

### 13.1 Claude不使用我的 Skill 

#### 13.1.1 症状与检查

**症状**：您提出了相关问题，但Claude不使用您的 Skill 。

**检查**：描述是否足够具体？

**因为**模糊的描述使发现变得困难，**所以**您需要包含以下关键要素：
*  Skill 的具体功能
* 使用场景说明
* 用户可能提及的关键术语

**对比示例**：

**太通用**（难以准确匹配）：
```yaml  theme={null}
description: Helps with data
```

**具体**（提高匹配准确性）：
```yaml  theme={null}
description: Analyze Excel spreadsheets, generate pivot tables, create charts. Use when working with Excel files, spreadsheets, or .xlsx files.
```

#### 13.1.2 YAML验证

**检查**：YAML是否有效？

**要**运行验证以检查语法错误：

```bash  theme={null}
# View frontmatter
cat .claude/skills/my-skill/SKILL.md | head -n 15

# Check for common issues
# - Missing opening or closing ---
# - Tabs instead of spaces
# - Unquoted strings with special characters
```

#### 13.1.3 位置检查

**检查**： Skill 是否在正确的位置？

```bash  theme={null}
# Personal  Skills
ls ~/.claude/skills/*/SKILL.md

# Project  Skills
ls .claude/skills/*/SKILL.md
```

### 13.2  Skill 有错误

#### 13.2.1 症状与依赖检查

**症状**： Skill 加载但工作不正确。

**检查**：依赖项是否可用？

**因为**当需要时，Claude将自动安装所需的依赖项（或请求许可安装它们），**所以**这通常不是主要问题。

#### 13.2.2 权限检查

**检查**：脚本是否有执行权限？

```bash  theme={null}
chmod +x .claude/skills/my-skill/scripts/*.py
```

#### 13.2.3 路径检查

**检查**：文件路径是否正确？

**在所有路径中**使用前斜杠（Unix样式）：

**正确**：`scripts/helper.py`
**错误**：`scripts\helper.py`（Windows样式）

### 13.3 多个 Skills冲突

#### 13.3.1 症状与解决

**症状**：Claude使用错误的 Skill 或在相似 Skills之间似乎混淆。

**在描述中要具体**：通过在描述中使用不同的触发术语来帮助Claude选择正确的 Skill 。

**避免这种模糊的描述方式**：

```yaml  theme={null}
#  Skill  1
description: For data analysis

#  Skill  2
description: For analyzing data
```

**采用这种具体的描述方式**：

```yaml  theme={null}
#  Skill  1
description: Analyze sales data in Excel files and CRM exports. Use for sales reports, pipeline analysis, and revenue tracking.

#  Skill  2
description: Analyze log files and system metrics data. Use for performance monitoring, debugging, and system diagnostics.
```

## 14. 示例

### 14.1 简单 Skill （单文件）

**基础的单文件 Skill 结构**：

```
commit-helper/
└── SKILL.md
```

**完整的SKILL.md内容**：

```yaml  theme={null}
---
name: generating-commit-messages
description: Generates clear commit messages from git diffs. Use when writing commit messages or reviewing staged changes.
---

# Generating Commit Messages

## Instructions

1. Run `git diff --staged` to see changes
2. I'll suggest a commit message with:
   - Summary under 50 characters
   - Detailed description
   - Affected components

## Best practices

- Use present tense
- Explain what and why, not how
```

### 14.2 带工具权限的 Skill 

**带权限控制的 Skill 结构**：

```
code-reviewer/
└── SKILL.md
```

**带权限限制的SKILL.md内容**：

```yaml  theme={null}
---
name: code-reviewer
description: Review code for best practices and potential issues. Use when reviewing code, checking PRs, or analyzing code quality.
allowed-tools: Read, Grep, Glob
---

# Code Reviewer

## Review checklist

1. Code organization and structure
2. Error handling
3. Performance considerations
4. Security concerns
5. Test coverage

## Instructions

1. Read the target files using Read tool
2. Search for patterns using Grep
3. Find related files using Glob
4. Provide detailed feedback on code quality
```

### 14.3 多文件 Skill 

**复杂的多文件 Skill 结构**：

```
pdf-processing/
├── SKILL.md
├── FORMS.md
├── REFERENCE.md
└── scripts/
    ├── fill_form.py
    └── validate.py
```

**多文件 Skill 的SKILL.md内容**：

````yaml  theme={null}
---
name: pdf-processing
description: Extract text, fill forms, merge PDFs. Use when working with PDF files, forms, or document extraction. Requires pypdf and pdfplumber packages.
---

# PDF Processing

## Quick start

Extract text:
```python
import pdfplumber
with pdfplumber.open("doc.pdf") as pdf:
    text = pdf.pages[0].extract_text()
```

For form filling, see [FORMS.md](FORMS.md).
For detailed API reference, see [REFERENCE.md](REFERENCE.md).

## Requirements

Packages must be installed in your environment:
```bash
pip install pypdf pdfplumber
```
````

<Note>
  **在描述中**列出所需的包。**因为**在Claude可以使用它们之前，包必须安装在您的环境中。
</Note>

**由此可见**，Claude仅在需要时加载附加文件，确保了性能优化。

## 15. 后续步骤

**继续学习Agent  Skills的以下资源**：

<CardGroup cols={2}>
  <Card title="Authoring best practices" icon="lightbulb" href="/en/docs/agents-and-tools/agent-skills/best-practices">
    编写Claude可以有效使用的 Skills
  </Card>

  <Card title="Agent  Skills overview" icon="book" href="/en/docs/agents-and-tools/agent-skills/overview">
    了解 Skills如何在Claude产品中工作
  </Card>

  <Card title="Use  Skills in the Agent SDK" icon="cube" href="/en/api/agent-sdk/skills">
    使用TypeScript和Python以编程方式使用 Skills
  </Card>

  <Card title="Get started with Agent  Skills" icon="rocket" href="/en/docs/agents-and-tools/agent-skills/quickstart">
    创建您的第一个 Skill 
  </Card>
</CardGroup>