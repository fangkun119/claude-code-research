# Agent  Skills 完整指南：模块化功能扩展与架构详解

## 1. Agent  Skills 概述与核心价值

### 1.1 什么是 Agent  Skills

**Agent  Skills 是扩展 Claude 功能的模块化能力系统。**
* 具体来说，每个  Skill  包含指令、元数据和可选资源（脚本、模板）
* Claude 在相关时会自动使用这些资源
* 通过基于文件系统的架构实现可重用性

### 1.2 为什么使用  Skills

**Skills 是可重用的、基于文件系统的专业知识资源。**

* **核心功能**：
  * 为 Claude 提供特定领域的专业知识：工作流、上下文和最佳实践
  * 将通用代理转变为专家
  * 按需加载，无需在多个对话中重复提供相同的指导

* **与传统提示的优势对比**：
  * 提示是对话级别的一次性任务指令
  *  Skills 是可重用的、持久化的专业能力
  *  Skills 支持组合构建复杂工作流

* **主要优势包括**：
  * **专业化 Claude**：为特定领域的任务定制功能
  * **减少重复**：创建一次，自动使用
  * **组合功能**：结合  Skills 构建复杂工作流

<Note>
  值得注意的是，有关 Agent  Skills 的架构和实际应用的深入讨论，请阅读我们的工程博客：[使用 Agent  Skills 为真实世界装备代理](https://www.anthropic.com/engineering/equipping-agents-for-the-real-world-with-agent-skills)。
</Note>

## 2. 使用  Skills

**Anthropic 提供两种类型的  Skills：预构建的 Agent  Skills 和自定义  Skills。**

* **共同特征**：
  * 两者的工作方式相同
  * Claude 在与您的请求相关时会自动使用它们

* **预构建的 Agent  Skills**：
  * 可供 claude.ai 上的所有用户使用
  * 通过 Claude API 使用
  * 涵盖常见文档任务：PowerPoint、Excel、Word、PDF
  * 请参阅[可用  Skills](#available-skills) 部分了解完整列表

* **自定义  Skills**：
  * 让您打包领域专业知识和组织知识
  * 在 Claude 的所有产品中都可用：
    * 在 Claude Code 中创建它们
    * 通过 API 上传它们
    * 或在 claude.ai 设置中添加它们
  * 支持组织级共享和个性化定制

<Note>
  **开始使用指南**：

  * **对于预构建的 Agent  Skills**：请参阅[快速入门教程](/zh-CN/docs/agents-and-tools/agent-skills/quickstart)，开始在 API 中使用 PowerPoint、Excel、Word 和 PDF skills
  * **对于自定义  Skills**：请参阅 [Agent  Skills 食谱](https://github.com/anthropics/claude-cookbooks/tree/main/skills)，了解如何创建您自己的  Skills
</Note>

## 3.  Skills 如何工作

**Skills 利用 Claude 的虚拟机环境提供超越提示的高级功能。**

* **核心技术原理**：
  *  Skills 在具有文件系统访问权限的虚拟机中运行
  * 支持包含指令、可执行代码和参考资料的目录结构
  * 采用类似新团队成员入职指南的组织方式

* **渐进式披露机制**：
  * Claude 按需分阶段加载信息
  * 避免预先消耗上下文
  * 确保在任何给定时间只有相关内容占据上下文窗口

### 3.1 三种  Skill  内容类型与加载级别

**Skills 采用三级渐进式加载架构，优化资源使用效率。**

* **第 1 级：元数据（始终加载）**
  * 内容类型：指令
  *  Skill  的 YAML 前置数据提供发现信息：
  ```yaml
  ---
  name: pdf-processing
  description: 从 PDF 文件中提取文本和表格、填充表单、合并文档。在处理 PDF 文件或用户提及 PDF、表单或文档提取时使用。
  ---
  ```
  * Claude 在启动时加载此元数据并包含在系统提示中
  * 轻量级方法支持安装多个  Skills 而不产生上下文成本

* **第 2 级：指令（触发时加载）**
  * 内容类型：指令
  * SKILL.md 的主体包含程序知识：工作流、最佳实践和指导
  * 当用户请求与  Skill  描述匹配的内容时触发加载
  * 只有触发后内容才会进入上下文窗口

* **第 3 级：资源和代码（按需加载）**
  * 内容类型：指令、代码和资源
  *  Skills 可以捆绑多种材料：
    ```
    pdf-skill/
    ├── SKILL.md (主要指令)
    ├── FORMS.md (表单填充指南)
    ├── REFERENCE.md (详细 API 参考)
    └── scripts/
        └── fill_form.py (实用脚本)
    ```
  * 各组件的功能：
    * **指令**：包含专业指导和工作流的其他 markdown 文件
    * **代码**：Claude 通过 bash 运行的可执行脚本，提供确定性操作而不消耗上下文
    * **资源**：参考资料，如数据库架构、API 文档、模板或示例
  * Claude 仅在引用时访问这些文件

### 3.2 加载效率对比分析

**渐进式披露架构显著提升资源利用效率。**

| 级别            | 加载时间       | 令牌成本               | 内容                                 |
| ------------- | ---------- | ------------------ | ---------------------------------- |
| **第 1 级：元数据** | 始终（启动时）    | 每个  Skill  约 100 个令牌 | YAML 前置数据中的 `name` 和 `description` |
| **第 2 级：指令**  | 触发  Skill  时 | 不到 5k 个令牌          | 包含指令和指导的 SKILL.md 主体               |
| **第 3 级+：资源** | 按需         | 实际上无限制             | 通过 bash 执行的捆绑文件，不将内容加载到上下文中        |

### 3.3  Skills 架构优势

**基于文件系统的模型提供多项核心技术优势。**

* **按需文件访问**：
  * Claude 仅读取每个特定任务所需的文件
  *  Skill  可以包含数十个参考文件，但只加载任务需要的文件
  * 未使用的文件保留在文件系统上，消耗零令牌

* **高效的脚本执行**：
  * 当 Claude 运行 `validate_form.py` 时，脚本代码永远不会加载到上下文窗口
  * 仅脚本的输出（如"验证通过"或特定错误消息）消耗令牌
  * 比让 Claude 即时生成等效代码高效得多

* **捆绑内容没有实际限制**：
  * 文件在访问前不消耗上下文
  *  Skills 可以包含全面的 API 文档、大型数据集、广泛的示例
  * 对于未使用的捆绑内容没有上下文成本

### 3.4  Skills 架构图

<img src="https://mintcdn.com/anthropic-claude-docs/4Bny2bjzuGBK7o00/images/agent-skills-architecture.png?fit=max&auto=format&n=4Bny2bjzuGBK7o00&q=85&s=44c5eab950e209f613a5a47f712550dc" alt="Agent  Skills 架构 - 显示  Skills 如何与代理的配置和虚拟机集成" data-og-width="2048" width="2048" data-og-height="1153" height="1153" data-path="images/agent-skills-architecture.png" data-optimize="true" data-opv="3" srcset="https://mintcdn.com/anthropic-claude-docs/4Bny2bjzuGBK7o00/images/agent-skills-architecture.png?w=280&fit=max&auto=format&n=4Bny2bjzuGBK7o00&q=85&s=fc06568b957c9c3617ea341548799568 280w, https://mintcdn.com/anthropic-claude-docs/4Bny2bjzuGBK7o00/images/agent-skills-architecture.png?w=560&fit=max&auto=format&n=4Bny2bjzuGBK7o00&q=85&s=5569fe72706deda67658467053251837 560w, https://mintcdn.com/anthropic-claude-docs/4Bny2bjzuGBK7o00/images/agent-skills-architecture.png?w=840&fit=max&auto=format&n=4Bny2bjzuGBK7o00&q=85&s=83c04e9248de7082971d623f835c2184 840w, https://mintcdn.com/anthropic-claude-docs/4Bny2bjzuGBK7o00/images/agent-skills-architecture.png?w=1100&fit=max&auto=format&n=4Bny2bjzuGBK7o00&q=85&s=d8e1900f8992d435088a565e098fd32a 1100w, https://mintcdn.com/anthropic-claude-docs/4Bny2bjzuGBK7o00/images/agent-skills-architecture.png?w=1650&fit=max&auto=format&n=4Bny2bjzuGBK7o00&q=85&s=b03b4a5df2a08f4be86889e6158975ee 1650w, https://mintcdn.com/anthropic-claude-docs/4Bny2bjzuGBK7o00/images/agent-skills-architecture.png?w=2500&fit=max&auto=format&n=4Bny2bjzuGBK7o00&q=85&s=b9cab267c168f6a480ba946b6558115c 2500w" />

**该架构图展示了以下关键组件：**

* **Skills 如何与代理的配置和虚拟机集成**
* **基于文件系统的渐进式披露机制**
* **虚拟机环境中的文件访问和代码执行**
* **按需加载的三级内容架构**

### 3.5 示例：PDF 处理 skill 加载流程

**以下是 Claude 加载和使用 PDF 处理 skill 的完整流程：**

1. **启动**：系统提示包括：`PDF 处理 - 从 PDF 文件中提取文本和表格、填充表单、合并文档`
2. **用户请求**：「从此 PDF 中提取文本并总结」
3. **Claude 调用**：`bash: read pdf-skill/SKILL.md` → 指令加载到上下文中
4. **Claude 确定**：不需要表单填充，因此不读取 FORMS.md
5. **Claude 执行**：使用 SKILL.md 中的指令完成任务

<img src="https://mintcdn.com/anthropic-claude-docs/4Bny2bjzuGBK7o00/images/agent-skills-context-window.png?fit=max&auto=format&n=4Bny2bjzuGBK7o00&q=85&s=0127e014bfc3dd3c86567aad8609111b" alt=" Skills 加载到上下文窗口 - 显示 skill 元数据和内容的渐进式加载" data-og-width="2048" width="2048" data-og-height="1154" height="1154" data-path="images/agent-skills-context-window.png" data-optimize="true" data-opv="3" srcset="https://mintcdn.com/anthropic-claude-docs/4Bny2bjzuGBK7o00/images/agent-skills-context-window.png?w=280&fit=max&auto=format&n=4Bny2bjzuGBK7o00&q=85&s=a17315d47b7c5a85b389026b70676e98 280w, https://mintcdn.com/anthropic-claude-docs/4Bny2bjzuGBK7o00/images/agent-skills-context-window.png?w=560&fit=max&auto=format&n=4Bny2bjzuGBK7o00&q=85&s=267349b063954588d4fae2650cb90cd8 560w, https://mintcdn.com/anthropic-claude-docs/4Bny2bjzuGBK7o00/images/agent-skills-context-window.png?w=840&fit=max&auto=format&n=4Bny2bjzuGBK7o00&q=85&s=0864972aba7bcb10bad86caf82cb415f 840w, https://mintcdn.com/anthropic-claude-docs/4Bny2bjzuGBK7o00/images/agent-skills-context-window.png?w=1100&fit=max&auto=format&n=4Bny2bjzuGBK7o00&q=85&s=631d661cbadcbdb62fd0935b91bd09f8 1100w, https://mintcdn.com/anthropic-claude-docs/4Bny2bjzuGBK7o00/images/agent-skills-context-window.png?w=1650&fit=max&auto=format&n=4Bny2bjzuGBK7o00&q=85&s=c1f80d0e37c517eb335db83615483ae0 1650w, https://mintcdn.com/anthropic-claude-docs/4Bny2bjzuGBK7o00/images/agent-skills-context-window.png?w=2500&fit=max&auto=format&n=4Bny2bjzuGBK7o00&q=85&s=4b6d0f1baf011ff9b49de501d8d83cc7 2500w" />

**该图表清楚显示动态加载的四个阶段：**

1. 预加载系统提示和 skill 元数据的默认状态
2. Claude 通过 bash 读取 SKILL.md 触发 skill
3. Claude 根据需要可选地读取其他捆绑文件，如 FORMS.md
4. Claude 继续执行任务

**最终效果是**，这种动态加载确保只有相关的 skill 内容占据上下文窗口。

## 4.  Skills 工作的地方

**Skills 在 Claude 的多个产品平台中提供一致的功能体验。**

### 4.1 Claude API

**Claude API 完整支持预构建和自定义  Skills。**

* **核心功能**：
  * 支持预构建的 Agent  Skills 和自定义  Skills
  * 两者的工作方式相同
  * 在 `container` 参数中指定相关的 `skill_id` 以及代码执行工具

* **前提条件**：
  * 需要三个 beta 标头：
    * `code-execution-2025-08-25` -  Skills 在代码执行容器中运行
    * `skills-2025-10-02` - 启用  Skills 功能
    * `files-api-2025-04-14` - 上传/下载文件到/从容器所需

* **使用方式**：
  * 通过引用其 `skill_id`（例如 `pptx`、`xlsx`）使用预构建的 Agent  Skills
  * 通过  Skills API（`/v1/skills` 端点）创建和上传您自己的  Skills
  * 自定义  Skills 在组织范围内共享

### 4.2 Claude Code

**Claude Code 专注于自定义  Skills 的文件系统支持。**

* **核心特性**：
  * 仅支持自定义  Skills
  * 创建包含 SKILL.md 文件的目录形式的  Skills
  * Claude 自动发现并使用它们
  * 基于文件系统，不需要 API 上传

### 4.3 Claude Agent SDK

**Claude Agent SDK 通过基于文件系统的配置支持自定义  Skills。**

* **实现方式**：
  * 在 `.claude/skills/` 中创建包含 SKILL.md 文件的目录形式的  Skills
  * 通过在 `allowed_tools` 配置中包含 `" Skill "` 来启用  Skills
  * SDK 运行时会自动发现  Skills 中的  Skills

### 4.4 Claude.ai

**Claude.ai 提供最灵活的  Skills 使用体验。**

* **预构建的 Agent  Skills**：
  * 这些  Skills 在您创建文档时已在后台工作
  * Claude 使用它们而不需要任何设置
  * 即开即用的用户体验

* **自定义  Skills**：
  * 通过设置 > 功能将您自己的  Skills 作为 zip 文件上传
  * 在启用代码执行的 Pro、Max、Team 和 Enterprise 计划上可用
  * 自定义  Skills 对每个用户是个人化的
  * 不在组织范围内共享，管理员无法集中管理

* **学习资源**：
  * [什么是  Skills？](https://support.claude.com/en/articles/12512176-what-are-skills)
  * [在 Claude 中使用  Skills](https://support.claude.com/en/articles/12512180-using-skills-in-claude)
  * [如何创建自定义  Skills](https://support.claude.com/en/articles/12512198-creating-custom-skills)
  * [使用  Skills 教 Claude 您的工作方式](https://support.claude.com/en/articles/12580051-teach-claude-your-way-of-working-using-skills)

## 5.  Skill  结构

**每个  Skill  都需要标准化的结构和必需的元数据组件。**

### 5.1 基本文件结构

**核心文件是带有 YAML 前置数据的 `SKILL.md` 文件：**

```yaml
---
name: your-skill-name
description: 简要描述此  Skill  的功能以及何时使用它
---

# 您的  Skill  名称

## 指令
[Claude 要遵循的清晰、分步指导]

## 示例
[使用此  Skill  的具体示例]
```

### 5.2 必需字段规范

**两个字段是必需的：`name` 和 `description`**

* **`name` 字段要求**：
  * 最多 64 个字符
  * 只能包含小写字母、数字和连字符
  * 不能包含 XML 标签
  * 不能包含保留字：「anthropic」、「claude」

* **`description` 字段要求**：
  * 必须非空
  * 最多 1024 个字符
  * 不能包含 XML 标签
  * 应包括  Skill  的功能以及 Claude 何时应使用它

**要获取完整的创作指导**，请参阅[最佳实践指南](/zh-CN/docs/agents-and-tools/agent-skills/best-practices)。

## 6. 安全考虑

**Skills 的强大功能需要严格的安全实践和风险管理。**

### 6.1 基本安全原则

**核心安全建议是仅从受信任的来源使用  Skills。**

* **推荐来源**：
  * 您自己创建的  Skills
  * 从 Anthropic 获得的  Skills

* **安全风险理解**：
  *  Skills 通过指令和代码为 Claude 提供新功能
  * 虽然这使它们功能强大，但也意味着恶意  Skill  可能指导 Claude 以有害方式调用工具或执行代码

<Warning>
  **安全警告**：如果您必须使用来自不受信任或未知来源的  Skill ，请格外谨慎并在使用前彻底审计它。根据 Claude 在执行  Skill  时拥有的访问权限，恶意  Skills 可能导致数据泄露、未授权系统访问或其他安全风险。
</Warning>

### 6.2 关键安全考虑

**全面的安全检查清单包括以下关键方面：**

* **彻底审计**：
  * 查看  Skill  中捆绑的所有文件：SKILL.md、脚本、图像和其他资源
  * 寻找异常模式，如意外的网络调用、文件访问模式或与  Skill  声称的目的不匹配的操作

* **外部来源有风险**：
  * 从外部 URL 获取数据的  Skills 特别有风险
  * 获取的内容可能包含恶意指令
  * 即使是可信的  Skills，如果其外部依赖项随时间变化也可能被破坏

* **工具滥用**：
  * 恶意  Skills 可以以有害方式调用工具（文件操作、bash 命令、代码执行）

* **数据泄露**：
  * 具有敏感数据访问权限的  Skills 可能被设计为向外部系统泄露信息

* **像安装软件一样对待**：
  * 仅从受信任的来源使用  Skills
  * 在将  Skills 集成到具有敏感数据或关键操作访问权限的生产系统时要特别小心

## 7. 可用  Skills

### 7.1 预构建的 Agent  Skills

**以下预构建的 Agent  Skills 可立即使用：**

* **PowerPoint (pptx)**：
  * 创建演示文稿
  * 编辑幻灯片
  * 分析演示文稿内容

* **Excel (xlsx)**：
  * 创建电子表格
  * 分析数据
  * 生成带图表的报告

* **Word (docx)**：
  * 创建文档
  * 编辑内容
  * 格式化文本

* **PDF (pdf)**：
  * 生成格式化的 PDF 文档和报告

**可用平台**：这些  Skills 在 Claude API 和 claude.ai 上可用。

**要开始使用**：请参阅[快速入门教程](/zh-CN/docs/agents-and-tools/agent-skills/quickstart)开始在 API 中使用它们。

### 7.2 自定义  Skills 示例

**要获取完整示例**：有关自定义  Skills 的完整示例，请参阅 [ Skills 食谱](https://github.com/anthropics/claude-cookbooks/tree/main/skills)。

## 8. 限制和约束

**了解这些限制有助于您有效规划  Skills 部署。**

### 8.1 跨平台可用性限制

**重要限制：自定义  Skills 不会跨平台同步。**

* **具体表现**：
  * 上传到一个平台的  Skills 不会自动在其他平台上可用
  * 上传到 Claude.ai 的  Skills 必须单独上传到 API
  * 通过 API 上传的  Skills 在 Claude.ai 上不可用
  * Claude Code  Skills 基于文件系统，与 Claude.ai 和 API 分离

* **管理要求**：
  * 需要为要使用  Skills 的每个平台单独管理和上传  Skills
  * 增加了维护成本和复杂性

### 8.2 共享范围差异

**Skills 根据使用位置有不同的共享模型：**

* **Claude.ai**：
  * 仅限个人用户
  * 每个团队成员必须单独上传
  * 不支持组织级集中管理

* **Claude API**：
  * 工作区范围
  * 所有工作区成员可以访问上传的  Skills
  * 支持组织级共享

* **Claude Code**：
  * 个人（`~/.claude/skills/`）或基于项目（`.claude/skills/`）
  * 支持个人和项目级别的  Skills 管理

**当前限制**：Claude.ai 目前不支持自定义  Skills 的集中管理员管理或组织范围分发。

### 8.3 运行时环境约束

**Skills 在受控的代码执行容器中运行：**

* **无网络访问**：
  *  Skills 无法进行外部 API 调用
  * 无法访问互联网
  * 确保数据安全和隔离

* **无运行时包安装**：
  * 仅预安装的包可用
  * 无法在执行期间安装新包
  * 需要预先规划依赖项

* **仅预配置的依赖项**：
  * 要了解可用包的列表，检查[代码执行工具文档](/zh-CN/docs/agents-and-tools/tool-use/code-execution-tool)

**规划建议**：规划您的  Skills 在这些约束范围内工作。

## 9. 后续步骤

**开始使用 Agent  Skills 的多种学习路径：**

<CardGroup cols={2}>
  <Card title="开始使用 Agent  Skills" icon="graduation-cap" href="/zh-CN/docs/agents-and-tools/agent-skills/quickstart">
    创建您的第一个  Skill 
  </Card>

  <Card title="API 指南" icon="code" href="/zh-CN/api/skills-guide">
    使用 Claude API 的  Skills
  </Card>

  <Card title="在 Claude Code 中使用  Skills" icon="terminal" href="/zh-CN/docs/claude-code/skills">
    在 Claude Code 中创建和管理自定义  Skills
  </Card>

  <Card title="在 Agent SDK 中使用  Skills" icon="cube" href="/zh-CN/api/agent-sdk/skills">
    在 TypeScript 和 Python 中以编程方式使用  Skills
  </Card>

  <Card title="创作最佳实践" icon="lightbulb" href="/zh-CN/docs/agents-and-tools/agent-skills/best-practices">
    编写 Claude 可以有效使用的  Skills
  </Card>
</CardGroup>