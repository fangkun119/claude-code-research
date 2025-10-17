# Claude  Skill 创作最佳实践指南

## 1. 核心原则与创作理念

### 1.1 简洁性原则：最大化上下文效率

**上下文窗口是有限资源， Skill 设计必须极致简洁**。 Skill 与 Claude 需要了解的所有其他内容共享上下文窗口，包括：

* 系统提示
* 对话历史
* 其他 Skill 的元数据
* 您的实际请求

** Skill 令牌成本虽无直接费用，但必须严格控制**。具体表现为：
* 启动时只有 Skill 元数据（名称和描述）被预加载
* Claude 仅在 Skill 相关时才读取 SKILL.md
* SKILL.md 简洁性至关重要，每个令牌都会与对话历史竞争

**默认假设 Claude 已经足够聪明**。需要质疑每一条信息：
* "Claude 真的需要这个解释吗？"
* "我能假设 Claude 知道这个吗？"
* "这段落值得它的令牌成本吗？"

**简洁示例对比**：

*好的简洁示例（约 50 个令牌）*：
````markdown
## 提取 PDF 文本
使用 pdfplumber 进行文本提取：
```python
import pdfplumber
with pdfplumber.open("file.pdf") as pdf:
    text = pdf.pages[0].extract_text()
```
````

*过于冗长示例（约 150 个令牌）*：
```markdown
## 提取 PDF 文本
PDF（便携式文档格式）文件是一种常见的文件格式，包含文本、图像和其他内容。要从 PDF 中提取文本，您需要使用一个库。有许多库可用于 PDF 处理，但我们建议使用 pdfplumber，因为它易于使用且能处理大多数情况。首先，您需要使用 pip 安装它。然后您可以使用下面的代码...
```

### 1.2 自由度设置：精确匹配任务需求

**根据任务脆弱性和可变性精确设置自由度**。三种自由度层次：

**高自由度**（基于文本的说明）：
* 适用场景：
  * 多种方法都有效
  * 决策取决于上下文
  * 启发式方法指导方法
* 示例：
```markdown
## 代码审查流程
1. 分析代码结构和组织
2. 检查潜在的错误或边界情况
3. 建议改进可读性和可维护性
4. 验证是否遵守项目约定
```

**中等自由度**（伪代码或带参数的脚本）：
* 适用场景：
  * 存在首选模式
  * 某些变化可以接受
  * 配置影响行为
* 示例：
````markdown
## 生成报告
使用此模板并根据需要自定义：
```python
def generate_report(data, format="markdown", include_charts=True):
    # 处理数据
    # 以指定格式生成输出
    # 可选地包含可视化
```
````

**低自由度**（特定脚本，很少或没有参数）：
* 适用场景：
  * 操作脆弱且容易出错
  * 一致性至关重要
  * 必须遵循特定序列
* 示例：
````markdown
## 数据库迁移
运行完全相同的脚本：
```bash
python scripts/migrate.py --verify --backup
```
不要修改命令或添加其他标志。
````

**类比理解**：将 Claude 视为探索路径的机器人
* 两侧都是悬崖的狭窄桥：只有一种安全方式，需要具体护栏（低自由度），如数据库迁移
* 没有危险的开放田野：许多路径都能成功，给出一般方向（高自由度），如代码审查

### 1.3 多模型测试策略

** Skill 有效性完全取决于底层模型**。必须使用计划使用的所有模型测试 Skill ：

**各模型测试重点**：
* **Claude Haiku**（快速、经济）： Skill 是否提供足够指导？
* **Claude Sonnet**（平衡）： Skill 是否清晰高效？
* **Claude Opus**（强大推理）： Skill 是否避免过度解释？

**跨模型兼容性要求**：
* Opus 完美有效的内容可能需要为 Haiku 提供更多细节
* 针对所有模型都能很好工作的说明进行优化

## 2.  Skill 结构与元数据配置

### 2.1 YAML 前置事项要求

**YAML 前置事项必须包含两个核心字段**：

`name` 字段要求：
* 最多 64 个字符
* 只能包含小写字母、数字和连字符
* 不能包含 XML 标签
* 不能包含保留字："anthropic"、"claude"

`description` 字段要求：
* 必须非空
* 最多 1024 个字符
* 不能包含 XML 标签
* 应描述 Skill 的功能和使用时机

### 2.2 命名约定与最佳实践

**使用一致的命名模式使 Skill 更容易引用和讨论**。建议使用动名词形式（动词 + -ing）：

*好的命名示例（动名词形式）*：
* `processing-pdfs`
* `analyzing-spreadsheets`
* `managing-databases`
* `testing-code`
* `writing-documentation`

*可接受的替代方案*：
* 名词短语：`pdf-processing`、`spreadsheet-analysis`
* 面向行动：`process-pdfs`、`analyze-spreadsheets`

*严格避免的命名*：
* 模糊的名称：`helper`、`utils`、`tools`
* 过于通用：`documents`、`data`、`files`
* 保留字：`anthropic-helper`、`claude-tools`
*  Skill 集合中的不一致模式

**一致命名的好处**：
* 在文档和对话中更容易引用 Skill 
* 一目了然地理解 Skill 功能
* 更容易组织和搜索多个 Skill 
* 维护专业、统一的 Skill 库

### 2.3 描述编写技巧

**`description` 字段是 Skill 发现的关键**，必须包括功能和使用时机：

**始终用第三人称编写**：
* 好的："处理 Excel 文件并生成报告"
* 避免："我可以帮助您处理 Excel 文件"
* 避免："您可以使用此功能处理 Excel 文件"

**描述必须具体并包含关键术语**。每个 Skill 只有一个描述字段，对 Skill 选择至关重要。

*有效的描述示例*：

**PDF 处理 Skill **：
```yaml
description: 从 PDF 文件中提取文本和表格、填充表单、合并文档。在处理 PDF 文件或用户提及 PDF、表单或文档提取时使用。
```

**Excel 分析 Skill **：
```yaml
description: 分析 Excel 电子表格、创建数据透视表、生成图表。在分析 Excel 文件、电子表格、表格数据或 .xlsx 文件时使用。
```

**Git 提交助手 Skill **：
```yaml
description: 通过分析 git 差异生成描述性提交消息。当用户要求帮助编写提交消息或审查暂存更改时使用。
```

*严格避免的模糊描述*：
```yaml
description: 帮助处理文档
```
```yaml
description: 处理数据
```
```yaml
description: 对文件进行各种操作
```

## 3. 渐进式披露模式设计

### 3.1 分层信息架构

**SKILL.md 应作为概述，指向详细材料**，类似入职指南的目录。

*实用指导*：
* 保持 SKILL.md 正文在 500 行以下以获得最佳性能
* 接近限制时将内容拆分为单独的文件
* 使用有效的模式组织说明、代码和资源

### 3.2 视觉化 Skill 架构演进

**基本 Skill 结构**：仅包含一个 SKILL.md 文件，包含元数据和说明：

<img src="https://mintcdn.com/anthropic-claude-docs/4Bny2bjzuGBK7o00/images/agent-skills-simple-file.png?fit=max&auto=format&n=4Bny2bjzuGBK7o00&q=85&s=87782ff239b297d9a9e8e1b72ed72db9" alt="显示 YAML 前置事项和 markdown 正文的简单 SKILL.md 文件" data-og-width="2048" width="2048" data-og-height="1153" height="1153" data-path="images/agent-skills-simple-file.png" data-optimize="true" data-opv="3" srcset="https://mintcdn.com/anthropic-claude-docs/4Bny2bjzuGBK7o00/images/agent-skills-simple-file.png?w=280&fit=max&auto=format&n=4Bny2bjzuGBK7o00&q=85&s=c61cc33b6f5855809907f7fda94cd80e 280w, https://mintcdn.com/anthropic-claude-docs/4Bny2bjzuGBK7o00/images/agent-skills-simple-file.png?w=560&fit=max&auto=format&n=4Bny2bjzuGBK7o00&q=85&s=90d2c0c1c76b36e8d485f49e0810dbfd 560w, https://mintcdn.com/anthropic-claude-docs/4Bny2bjzuGBK7o00/images/agent-skills-simple-file.png?w=840&fit=max&auto=format&n=4Bny2bjzuGBK7o00&q=85&s=ad17d231ac7b0bea7e5b4d58fb4aeabb 840w, https://mintcdn.com/anthropic-claude-docs/4Bny2bjzuGBK7o00/images/agent-skills-simple-file.png?w=1100&fit=max&auto=format&n=4Bny2bjzuGBK7o00&q=85&s=f5d0a7a3c668435bb0aee9a3a8f8c329 1100w, https://mintcdn.com/anthropic-claude-docs/4Bny2bjzuGBK7o00/images/agent-skills-simple-file.png?w=1650&fit=max&auto=format&n=4Bny2bjzuGBK7o00&q=85&s=0e927c1af9de5799cfe557d12249f6e6 1650w, https://mintcdn.com/anthropic-claude-docs/4Bny2bjzuGBK7o00/images/agent-skills-simple-file.png?w=2500&fit=max&auto=format&n=4Bny2bjzuGBK7o00&q=85&s=46bbb1a51dd4c8202a470ac8c80a893d 2500w" />

**高级 Skill 架构**：随着 Skill 增长，可以捆绑 Claude 仅在需要时加载的其他内容：

<img src="https://mintcdn.com/anthropic-claude-docs/4Bny2bjzuGBK7o00/images/agent-skills-bundling-content.png?fit=max&auto=format&n=4Bny2bjzuGBK7o00&q=85&s=a5e0aa41e3d53985a7e3e43668a33ea3" alt="捆绑其他参考文件，如 reference.md 和 forms.md。" data-og-width="2048" width="2048" data-og-height="1327" height="1327" data-path="images/agent-skills-bundling-content.png" data-optimize="true" data-opv="3" srcset="https://mintcdn.com/anthropic-claude-docs/4Bny2bjzuGBK7o00/images/agent-skills-bundling-content.png?w=280&fit=max&auto=format&n=4Bny2bjzuGBK7o00&q=85&s=f8a0e73783e99b4a643d79eac86b70a2 280w, https://mintcdn.com/anthropic-claude-docs/4Bny2bjzuGBK7o00/images/agent-skills-bundling-content.png?w=560&fit=max&auto=format&n=4Bny2bjzuGBK7o00&q=85&s=dc510a2a9d3f14359416b706f067904a 560w, https://mintcdn.com/anthropic-claude-docs/4Bny2bjzuGBK7o00/images/agent-skills-bundling-content.png?w=840&fit=max&auto=format&n=4Bny2bjzuGBK7o00&q=85&s=82cd6286c966303f7dd914c28170e385 840w, https://mintcdn.com/anthropic-claude-docs/4Bny2bjzuGBK7o00/images/agent-skills-bundling-content.png?w=1100&fit=max&auto=format&n=4Bny2bjzuGBK7o00&q=85&s=56f3be36c77e4fe4b523df209a6824c6 1100w, https://mintcdn.com/anthropic-claude-docs/4Bny2bjzuGBK7o00/images/agent-skills-bundling-content.png?w=1650&fit=max&auto=format&n=4Bny2bjzuGBK7o00&q=85&s=d22b5161b2075656417d56f41a74f3dd 1650w, https://mintcdn.com/anthropic-claude-docs/4Bny2bjzuGBK7o00/images/agent-skills-bundling-content.png?w=2500&fit=max&auto=format&n=4Bny2bjzuGBK7o00&q=85&s=3dd4bdd6850ffcc96c6c45fcb0acd6eb 2500w" />

*完整的 Skill 目录结构示例*：
```
pdf/
├── SKILL.md              # 主要说明（触发时加载）
├── FORMS.md              # 表单填充指南（根据需要加载）
├── reference.md          # API 参考（根据需要加载）
├── examples.md           # 使用示例（根据需要加载）
└── scripts/
    ├── analyze_form.py   # 实用脚本（执行，不加载）
    ├── fill_form.py      # 表单填充脚本
    └── validate.py       # 验证脚本
```

### 3.3 渐进式披露模式实例

**模式 1：高级指南与参考**：
````markdown
---
name: pdf-processing
description: 从 PDF 文件中提取文本和表格、填充表单、合并文档。在处理 PDF 文件或用户提及 PDF、表单或文档提取时使用。
---

# PDF 处理

## 快速开始
使用 pdfplumber 提取文本：
```python
import pdfplumber
with pdfplumber.open("file.pdf") as pdf:
    text = pdf.pages[0].extract_text()
```

## 高级功能
**表单填充**：参阅 [FORMS.md](FORMS.md) 获取完整指南
**API 参考**：参阅 [REFERENCE.md](REFERENCE.md) 获取所有方法
**示例**：参阅 [EXAMPLES.md](EXAMPLES.md) 获取常见模式
````
Claude 仅在需要时加载 FORMS.md、REFERENCE.md 或 EXAMPLES.md。

**模式 2：特定领域组织**：
对于多领域 Skill ，按领域组织内容避免加载无关上下文。当用户询问销售指标时，Claude 只需要读取销售相关架构，保持令牌使用低且上下文集中。

*领域组织示例*：
```
bigquery-skill/
├── SKILL.md (概述和导航)
└── reference/
    ├── finance.md (收入、计费指标)
    ├── sales.md (机会、管道)
    ├── product.md (API 使用、功能)
    └── marketing.md (活动、归因)
```

**模式 3：条件详情**：
显示基本内容，链接到高级内容：
```markdown
# DOCX 处理

## 创建文档
使用 docx-js 创建新文档。参阅 [DOCX-JS.md](DOCX-JS.md)。

## 编辑文档
对于简单编辑，直接修改 XML。
**对于跟踪更改**：参阅 [REDLINING.md](REDLINING.md)
**对于 OOXML 详情**：参阅 [OOXML.md](OOXML.md)
```

### 3.4 文件引用最佳实践

**避免深层嵌套引用**：
* 原因：当从其他引用文件引用时，Claude 可能部分读取文件，导致信息不完整
* 原则：保持引用距离 SKILL.md 一级，确保 Claude 能读取完整文件

*不好的嵌套示例*：
```markdown
# SKILL.md
参阅 [advanced.md](advanced.md)...

# advanced.md
参阅 [details.md](details.md)...

# details.md
这是实际信息...
```

*好的扁平化示例*：
```markdown
# SKILL.md
**基本使用**：[SKILL.md 中的说明]
**高级功能**：参阅 [advanced.md](advanced.md)
**API 参考**：参阅 [reference.md](reference.md)
**示例**：参阅 [examples.md](examples.md)
```

**使用目录结构化较长的参考文件**：
* 对于超过 100 行的参考文件，在顶部包含目录
* 确保 Claude 即使部分读取也能看到完整信息范围

*目录结构示例*：
```markdown
# API 参考

## 内容
- 身份验证和设置
- 核心方法（创建、读取、更新、删除）
- 高级功能（批量操作、webhooks）
- 错误处理模式
- 代码示例

## 身份验证和设置
...

## 核心方法
...
```

## 4. 工作流设计与反馈循环

### 4.1 复杂任务工作流化

**将复杂操作分解为清晰的顺序步骤**。对于特别复杂的工作流，提供清单让 Claude 复制到响应中并跟踪进度。

**示例 1：研究综合工作流（无代码 Skill ）**：
````markdown
## 研究综合工作流
复制此清单并跟踪您的进度：
```
研究进度：
- [ ] 步骤 1：阅读所有源文档
- [ ] 步骤 2：识别关键主题
- [ ] 步骤 3：交叉参考声明
- [ ] 步骤 4：创建结构化摘要
- [ ] 步骤 5：验证引用
```

**步骤 1：阅读所有源文档**
查看 `sources/` 目录中的每个文档。记下主要论点和支持证据。

**步骤 2：识别关键主题**
寻找跨源的模式。哪些主题重复出现？源在哪里一致或不一致？

**步骤 3：交叉参考声明**
对于每个主要声明，验证它出现在源材料中。记下哪个源支持每个点。

**步骤 4：创建结构化摘要**
按主题组织发现。包括：
- 主要声明
- 来自源的支持证据
- 相互矛盾的观点（如果有）

**步骤 5：验证引用**
检查每个声明是否引用了正确的源文档。如果引用不完整，返回步骤 3。
````

**示例 2：PDF 表单填充工作流（有代码 Skill ）**：
````markdown
## PDF 表单填充工作流
复制此清单并在完成项目时检查：
```
任务进度：
- [ ] 步骤 1：分析表单（运行 analyze_form.py）
- [ ] 步骤 2：创建字段映射（编辑 fields.json）
- [ ] 步骤 3：验证映射（运行 validate_fields.py）
- [ ] 步骤 4：填充表单（运行 fill_form.py）
- [ ] 步骤 5：验证输出（运行 verify_output.py）
```

**步骤 1：分析表单**
运行：`python scripts/analyze_form.py input.pdf`
这提取表单字段及其位置，保存到 `fields.json`。

**步骤 2：创建字段映射**
编辑 `fields.json` 为每个字段添加值。

**步骤 3：验证映射**
运行：`python scripts/validate_fields.py fields.json`
在继续之前修复任何验证错误。

**步骤 4：填充表单**
运行：`python scripts/fill_form.py input.pdf fields.json output.pdf`

**步骤 5：验证输出**
运行：`python scripts/verify_output.py output.pdf`
如果验证失败，返回步骤 2。
````

### 4.2 反馈循环机制设计

**常见模式：运行验证器 → 修复错误 → 重复**。此模式大大提高输出质量。

**示例 1：风格指南合规性（无代码 Skill ）**：
```markdown
## 内容审查流程
1. 按照 STYLE_GUIDE.md 中的指南起草您的内容
2. 根据清单审查：
   - 检查术语一致性
   - 验证示例遵循标准格式
   - 确认所有必需部分都存在
3. 如果发现问题：
   - 用特定部分参考记录每个问题
   - 修改内容
   - 再次审查清单
4. 仅当满足所有要求时才继续
5. 完成并保存文档
```

**示例 2：文档编辑流程（有代码 Skill ）**：
```markdown
## 文档编辑流程
1. 对 `word/document.xml` 进行编辑
2. **立即验证**：`python ooxml/scripts/validate.py unpacked_dir/`
3. 如果验证失败：
   - 仔细查看错误消息
   - 修复 XML 中的问题
   - 再次运行验证
4. **仅在验证通过时继续**
5. 重建：`python ooxml/scripts/pack.py unpacked_dir/ output.docx`
6. 测试输出文档
```

## 5. 内容编写与常见模式

### 5.1 内容指南

**避免时间敏感信息**。不要包含会过时的信息：

*不好的时间敏感示例*：
```markdown
如果您在 2025 年 8 月之前执行此操作，请使用旧 API。
2025 年 8 月之后，使用新 API。
```

*好的时间处理示例*：
```markdown
## 当前方法
使用 v2 API 端点：`api.example.com/v2/messages`

## 旧模式
<details>
<summary>旧版 v1 API（已弃用 2025-08）</summary>
v1 API 使用：`api.example.com/v1/messages`
此端点不再受支持。
</details>
```

**使用一致的术语**。选择一个术语并在整个 Skill 中使用：

*好的一致性示例*：
* 始终"API 端点"
* 始终"字段"
* 始终"提取"

*不好的不一致示例*：
* 混合"API 端点"、"URL"、"API 路由"、"路径"
* 混合"字段"、"框"、"元素"、"控件"
* 混合"提取"、"拉取"、"获取"、"检索"

### 5.2 常见模式应用

**模板模式**：为输出格式提供模板，将严格程度与需求匹配。

*严格要求模板（如 API 响应）*：
````markdown
## 报告结构
始终使用此精确的模板结构：
```markdown
# [分析标题]

## 执行摘要
[关键发现的一段概述]

## 关键发现
- 带有支持数据的发现 1
- 带有支持数据的发现 2
- 带有支持数据的发现 3

## 建议
1. 具体可行的建议
2. 具体可行的建议
```
````

*灵活指导模板（当适应有用时）*：
````markdown
## 报告结构
这是一个合理的默认格式，但根据分析使用您的最佳判断：
```markdown
# [分析标题]

## 执行摘要
[概述]

## 关键发现
[根据您发现的内容调整部分]

## 建议
[根据具体背景定制]
```
根据特定分析类型根据需要调整部分。
````

**示例模式**：提供输入/输出对，帮助 Claude 理解所需风格和细节程度。

````markdown
## 提交消息格式
按照这些示例生成提交消息：

**示例 1：**
输入：使用 JWT 令牌添加用户身份验证
输出：
```
feat(auth): 实现基于 JWT 的身份验证

添加登录端点和令牌验证中间件
```

**示例 2：**
输入：修复日期在报告中显示不正确的错误
输出：
```
fix(reports): 修正时区转换中的日期格式

在报告生成中一致使用 UTC 时间戳
```

**示例 3：**
输入：更新依赖项并重构错误处理
输出：
```
chore: 更新依赖项并重构错误处理

- 将 lodash 升级到 4.17.21
- 跨端点标准化错误响应格式
```

遵循此风格：type(scope): 简短描述，然后详细说明。
````

**条件工作流模式**：通过决策点指导 Claude：
```markdown
## 文档修改工作流
1. 确定修改类型：
   **创建新内容？** → 遵循下面的"创建工作流"
   **编辑现有内容？** → 遵循下面的"编辑工作流"

2. 创建工作流：
   - 使用 docx-js 库
   - 从头开始构建文档
   - 导出为 .docx 格式

3. 编辑工作流：
   - 解包现有文档
   - 直接修改 XML
   - 每次更改后验证
   - 完成时重新打包
```

## 6. 评估与迭代开发

### 6.1 评估驱动的开发方法

**首先构建评估**。在编写大量文档之前创建评估，确保 Skill 解决真实问题而不是记录想象的问题。

**评估驱动的开发流程**：
1. **识别差距**：在没有 Skill 的情况下对代表性任务运行 Claude，记录具体的失败或缺失的上下文
2. **创建评估**：构建三个场景来测试这些差距
3. **建立基线**：测量没有 Skill 的 Claude 的性能
4. **编写最少说明**：创建足够的内容来解决差距并通过评估
5. **迭代**：执行评估、与基线比较并改进

**评估结构示例**：
```json
{
  "skills": ["pdf-processing"],
  "query": "从此 PDF 文件中提取所有文本并将其保存到 output.txt",
  "files": ["test-files/document.pdf"],
  "expected_behavior": [
    "使用适当的 PDF 处理库或命令行工具成功读取 PDF 文件",
    "从文档中的所有页面提取文本内容，不遗漏任何页面",
    "将提取的文本保存到名为 output.txt 的文件中，格式清晰易读"
  ]
}
```

### 6.2 与 Claude 协作的迭代开发

**最有效的 Skill 开发流程涉及 Claude 本身**。与 Claude A 实例合作创建将由 Claude B 实例使用的 Skill 。

**创建新 Skill 流程**：
1. **在没有 Skill 的情况下完成任务**：与 Claude A 使用常规提示解决问题，注意重复提供的信息
2. **识别可重用模式**：识别对类似未来任务有用的上下文
3. **要求 Claude A 创建 Skill **：要求创建 Skill 来捕获使用模式
4. **审查简洁性**：检查 Claude A 没有添加不必要解释
5. **改进信息架构**：要求 Claude A 更有效地组织内容
6. **在类似任务上测试**：使用 Skill 与 Claude B 进行相关用例
7. **根据观察迭代**：如果 Claude B 遇到困难，返回 Claude A 提供具体信息

**迭代现有 Skill 流程**：
1. **在真实工作流中使用 Skill **：给 Claude B 实际任务而不是测试场景
2. **观察 Claude B 的行为**：注意困难、成功或意外选择
3. **返回 Claude A 进行改进**：分享当前 SKILL.md 并描述观察
4. **审查 Claude A 的建议**：考虑重新组织、使用更强语言或重构工作流
5. **应用并测试更改**：使用改进更新 Skill 并再次测试
6. **根据使用情况重复**：继续观察-改进-测试循环

**收集团队反馈**：
1. 与队友分享 Skill 并观察使用
2. 询问 Skill 激活情况、说明清晰度、缺失内容
3. 合并反馈解决使用模式中的盲点

### 6.3  Skill 使用观察与优化

**观察 Claude 如何导航 Skill **。注意：
* **意外的探索路径**：Claude 是否以预期外的顺序读取文件？
* **错过的连接**：Claude 是否未能遵循对重要文件的引用？
* **对某些部分的过度依赖**：如果 Claude 反复读取同一文件，考虑是否应该在主 SKILL.md 中
* **忽略的内容**：如果 Claude 从不访问捆绑文件，可能不必要或信号不良

根据这些观察而不是假设进行迭代。 Skill 元数据中的 "name" 和 "description" 特别关键，确保它们清楚描述 Skill 的功能和使用时机。

## 7. 高级开发技巧

### 7.1 可执行代码 Skill 

**解决，不要推卸**。编写 Skill 脚本时处理错误条件而不是推卸给 Claude。

*好的错误处理示例*：
```python
def process_file(path):
    """处理文件，如果不存在则创建它。"""
    try:
        with open(path) as f:
            return f.read()
    except FileNotFoundError:
        # 创建具有默认内容的文件而不是失败
        print(f"文件 {path} 未找到，创建默认值")
        with open(path, 'w') as f:
            f.write('')
        return ''
    except PermissionError:
        # 提供替代方案而不是失败
        print(f"无法访问 {path}，使用默认值")
        return ''
```

*不好的推卸示例*：
```python
def process_file(path):
    # 只是失败并让 Claude 弄清楚
    return open(path).read()
```

**配置参数应该被证明和记录**，避免"巫毒常数"：

*好的自文档化示例*：
```python
# HTTP 请求通常在 30 秒内完成
# 更长的超时考虑了慢速连接
REQUEST_TIMEOUT = 30

# 三次重试平衡可靠性与速度
# 大多数间歇性故障在第二次重试时解决
MAX_RETRIES = 3
```

*不好的魔法数字示例*：
```python
TIMEOUT = 47  # 为什么是 47？
RETRIES = 5   # 为什么是 5？
```

**提供实用脚本**。即使 Claude 可以编写脚本，预制脚本也提供优势：

*实用脚本的优势*：
* 比生成的代码更可靠
* 节省令牌（无需在上下文中包含代码）
* 节省时间（无需代码生成）
* 确保跨使用的一致性

<img src="https://mintcdn.com/anthropic-claude-docs/4Bny2bjzuGBK7o00/images/agent-skills-executable-scripts.png?fit=max&auto=format&n=4Bny2bjzuGBK7o00&q=85&s=4bbc45f2c2e0bee9f2f0d5da669bad00" alt="将可执行脚本与说明文件捆绑在一起" data-og-width="2048" width="2048" data-og-height="1154" height="1154" data-path="images/agent-skills-executable-scripts.png" data-optimize="true" data-opv="3" srcset="https://mintcdn.com/anthropic-claude-docs/4Bny2bjzuGBK7o00/images/agent-skills-executable-scripts.png?w=280&fit=max&auto=format&n=4Bny2bjzuGBK7o00&q=85&s=9a04e6535a8467bfeea492e517de389f 280w, https://mintcdn.com/anthropic-claude-docs/4Bny2bjzuGBK7o00/images/agent-skills-executable-scripts.png?w=560&fit=max&auto=format&n=4Bny2bjzuGBK7o00&q=85&s=e49333ad90141af17c0d7651cca7216b 560w, https://mintcdn.com/anthropic-claude-docs/4Bny2bjzuGBK7o00/images/agent-skills-executable-scripts.png?w=840&fit=max&auto=format&n=4Bny2bjzuGBK7o00&q=85&s=954265a5df52223d6572b6214168c428 840w, https://mintcdn.com/anthropic-claude-docs/4Bny2bjzuGBK7o00/images/agent-skills-executable-scripts.png?w=1100&fit=max&auto=format&n=4Bny2bjzuGBK7o00&q=85&s=2ff7a2d8f2a83ee8af132b29f10150fd 1100w, https://mintcdn.com/anthropic-claude-docs/4Bny2bjzuGBK7o00/images/agent-skills-executable-scripts.png?w=1650&fit=max&auto=format&n=4Bny2bjzuGBK7o00&q=85&s=48ab96245e04077f4d15e9170e081cfb 1650w, https://mintcdn.com/anthropic-claude-docs/4Bny2bjzuGBK7o00/images/agent-skills-executable-scripts.png?w=2500&fit=max&auto=format&n=4Bny2bjzuGBK7o00&q=85&s=0301a6c8b3ee879497cc5b5483177c90 2500w" />

*重要区别*：在说明中明确说明 Claude 是否应该：
* **执行脚本**（最常见）："运行 `analyze_form.py` 来提取字段"
* **作为参考读取**（对于复杂逻辑）："参阅 `analyze_form.py` 了解字段提取算法"

*实用脚本示例*：
````markdown
## 实用脚本

**analyze_form.py**：从 PDF 中提取所有表单字段
```bash
python scripts/analyze_form.py input.pdf > fields.json
```
输出格式：
```json
{
  "field_name": {"type": "text", "x": 100, "y": 200},
  "signature": {"type": "sig", "x": 150, "y": 500}
}
```

**validate_boxes.py**：检查重叠的边界框
```bash
python scripts/validate_boxes.py fields.json
# 返回："OK"或列出冲突
```

**fill_form.py**：将字段值应用于 PDF
```bash
python scripts/fill_form.py input.pdf fields.json output.pdf
```
````

**使用视觉分析**：当输入可以呈现为图像时，让 Claude 分析它们：
````markdown
## 表单布局分析
1. 将 PDF 转换为图像：
   ```bash
   python scripts/pdf_to_images.py form.pdf
   ```
2. 分析每个页面图像以识别表单字段
3. Claude 可以在视觉上看到字段位置和类型
````

**创建可验证的中间输出**。"计划-验证-执行"模式通过让 Claude 首先创建计划，然后使用脚本验证来及早捕获错误。

*为什么此模式有效*：
* **及早捕获错误**：验证在更改应用前发现问题
* **机器可验证**：脚本提供客观验证
* **可逆计划**：Claude 可以迭代计划而不接触原件
* **清晰调试**：错误消息指向特定问题

### 7.2 依赖管理与运行时环境

**打包依赖项**。 Skill 在代码执行环境中运行，具有特定于平台的限制：

* **claude.ai**：可以从 npm 和 PyPI 安装包并从 GitHub 存储库拉取
* **Anthropic API**：没有网络访问权限，没有运行时包安装

在 SKILL.md 中列出所需包，并验证它们在代码执行工具文档中可用。

**运行时环境**。 Skill 在具有文件系统访问、bash 命令和代码执行能力的环境中运行。

*Claude 如何访问 Skill *：
1. **元数据预加载**：启动时，所有 Skill  YAML 前置事项中的名称和描述被加载到系统提示中
2. **按需读取文件**：Claude 在需要时使用 bash 读取工具访问 SKILL.md 和其他文件
3. **高效执行脚本**：实用脚本可以通过 bash 执行，而无需将其完整内容加载到上下文中
4. **大文件无上下文惩罚**：参考文件、数据或文档在实际读取前不消耗上下文令牌

*文件系统设计原则*：
* **文件路径很重要**：使用正斜杠（`reference/guide.md`），而不是反斜杠
* **描述性地命名文件**：使用指示内容的名称
* **为发现组织**：按域或功能组织目录
* **捆绑综合资源**：包括完整的 API 文档、广泛的示例、大型数据集
* **对确定性操作优先使用脚本**：编写 `validate_form.py` 而不是要求 Claude 生成验证代码
* **明确执行意图**：清楚说明是执行还是作为参考读取
* **测试文件访问模式**：通过真实请求测试验证 Claude 可以导航目录结构

### 7.3 MCP 工具集成

**MCP 工具参考**。如果 Skill 使用 MCP（模型上下文协议）工具，始终使用完全限定的工具名称：

*格式*：`ServerName:tool_name`

*示例*：
```markdown
使用 BigQuery:bigquery_schema 工具检索表架构。
使用 GitHub:create_issue 工具创建问题。
```

其中：
* `BigQuery` 和 `GitHub` 是 MCP 服务器名称
* `bigquery_schema` 和 `create_issue` 是这些服务器中的工具名称

**避免假设工具已安装**。不要假设包可用：

*不好的假设示例*：
````markdown
使用 pdf 库来处理文件。
````

*好的明确示例*：
````markdown
安装所需的包：`pip install pypdf`
然后使用它：
```python
from pypdf import PdfReader
reader = PdfReader("file.pdf")
```
````

## 8. 技术规范与质量检查

### 8.1 技术说明

**YAML 前置事项要求**。SKILL.md 前置事项需要 `name` 和 `description` 字段：

* `name`：最多 64 个字符，仅小写字母/数字/连字符，无 XML 标签，无保留字
* `description`：最多 1024 个字符，非空，无 XML 标签

**令牌预算**。保持 SKILL.md 正文在 500 行以下以获得最佳性能。如果内容超过此限制，使用渐进式披露模式将其拆分为单独的文件。

### 8.2 要避免的反模式

**避免 Windows 风格的路径**。始终使用正斜杠在文件路径中：

* ✓ 好的：`scripts/helper.py`、`reference/guide.md`
* ✗ 避免：`scripts\helper.py`、`reference\guide.md`

Unix 风格的路径在所有平台上都有效，而 Windows 风格的路径在 Unix 系统上会导致错误。

**避免提供太多选项**。除非必要，否则不要呈现多种方法：

*不好的太多选择示例*：
````markdown
您可以使用 pypdf、或 pdfplumber、或 PyMuPDF、或 pdf2image、或...
````

*好的提供默认值示例*：
````markdown
使用 pdfplumber 进行文本提取：
```python
import pdfplumber
```
对于需要 OCR 的扫描 PDF，改用 pdf2image 与 pytesseract。
````

### 8.3 有效 Skill 清单

**在分享 Skill 之前验证**：

*核心质量*：
* [ ] 描述具体并包含关键术语
* [ ] 描述包括 Skill 的功能和使用时机
* [ ] SKILL.md 正文在 500 行以下
* [ ] 其他详情在单独的文件中（如果需要）
* [ ] 没有时间敏感信息（或在"旧模式"部分中）
* [ ] 整个 Skill 中术语一致
* [ ] 示例具体，不抽象
* [ ] 文件引用一级深
* [ ] 适当使用渐进式披露
* [ ] 工作流有清晰的步骤

*代码和脚本*：
* [ ] 脚本解决问题而不是推卸给 Claude
* [ ] 错误处理明确且有帮助
* [ ] 没有"巫毒常数"（所有值都有理由）
* [ ] 所需的包在说明中列出并验证为可用
* [ ] 脚本有清晰的文档
* [ ] 没有 Windows 风格的路径（所有正斜杠）
* [ ] 关键操作的验证/验证步骤
* [ ] 包含质量关键任务的反馈循环

*测试*：
* [ ] 至少创建了三个评估
* [ ] 使用 Haiku、Sonnet 和 Opus 进行了测试
* [ ] 使用真实使用场景进行了测试
* [ ] 合并了团队反馈（如果适用）

## 9. 后续步骤

<CardGroup cols={2}>
  <Card title="开始使用代理 Skill " icon="rocket" href="/zh-CN/docs/agents-and-tools/agent-skills/quickstart">
    创建您的第一个 Skill 
  </Card>

  <Card title="在 Claude Code 中使用 Skill " icon="terminal" href="/zh-CN/docs/claude-code/skills">
    在 Claude Code 中创建和管理 Skill 
  </Card>

  <Card title="在代理 SDK 中使用 Skill " icon="cube" href="/zh-CN/api/agent-sdk/skills">
    在 TypeScript 和 Python 中以编程方式使用 Skill 
  </Card>

  <Card title="使用 API 使用 Skill " icon="code" href="/zh-CN/api/skills-guide">
    以编程方式上传和使用 Skill 
  </Card>
</CardGroup>