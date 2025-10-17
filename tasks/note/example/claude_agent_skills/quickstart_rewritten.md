# 在 API 中开始使用 Agent  Skills

> 学习如何使用 Agent  Skills 在 10 分钟内使用 Claude API 创建文档。

**本教程的核心价值**：通过 Agent  Skills，您可以在 10 分钟内快速创建专业文档，无需手动操作。主要收获包括：
* 掌握 PowerPoint 演示文稿的自动创建方法
* 学会启用和配置 Agent  Skills 的完整流程
* 了解文件生成和下载的技术细节

## 前置条件

**开始前的必要准备**：确保您具备以下三个基础条件：

* [Anthropic API 密钥](https://console.anthropic.com/settings/keys)
* Python 3.7+ 或已安装 curl
* 对进行 API 请求的基本熟悉

## 什么是 Agent  Skills？

**Agent  Skills 的核心优势**：通过预构建的专业 Skill 模块，大幅扩展 Claude 的文档处理能力。具体功能包括：

* **PowerPoint (pptx)**：创建和编辑演示文稿
* **Excel (xlsx)**：创建和分析电子表格
* **Word (docx)**：创建和编辑文档
* **PDF (pdf)**：生成 PDF 文档

<Note>
  **想要创建自定义  Skills？** 请查看 [Agent  Skills Cookbook](https://github.com/anthropics/claude-cookbooks/tree/main/skills) 以获取使用特定领域专业知识构建您自己的  Skills 的示例。
</Note>

## 步骤 1：列出可用的  Skills

**第一步的核心目标**：通过  Skills API 获取所有可用的 Anthropic 管理的  Skills 列表。

### 实现方法

**支持三种编程语言的实现方式**：

<CodeGroup>

  ```python Python theme={null}
  import anthropic

  client = anthropic.Anthropic()

  # List Anthropic-managed  Skills
  skills = client.beta.skills.list(
      source="anthropic",
      betas=["skills-2025-10-02"]
  )

  for skill in skills.data:
      print(f"{skill.id}: {skill.display_title}")
  ```

  ```typescript TypeScript theme={null}
  import Anthropic from '@anthropic-ai/sdk';

  const client = new Anthropic();

  # List Anthropic-managed  Skills
  const skills = await client.beta.skills.list({
    source: 'anthropic',
    betas: ['skills-2025-10-02']
  });

  for (const skill of skills.data) {
    console.log(`${skill.id}: ${skill.display_title}`);
  }
  ```

  ```bash Shell theme={null}
  curl "https://api.anthropic.com/v1/skills?source=anthropic" \
    -H "x-api-key: $ANTHROPIC_API_KEY" \
    -H "anthropic-version: 2023-06-01" \
    -H "anthropic-beta: skills-2025-10-02"
  ```
</CodeGroup>

### 执行结果

**API 调用将返回四种核心  Skills**：
* `pptx`：PowerPoint 演示文稿创建
* `xlsx`：Excel 电子表格处理
* `docx`：Word 文档编辑
* `pdf`：PDF 文档生成

**渐进式披露机制的第一层**：
* API 仅返回  Skills 的元数据（名称和描述）
* Claude 在启动时加载此元数据以了解可用功能
* 避免加载完整说明，提高系统效率

## 步骤 2：创建演示文稿

**第二步的核心价值**：通过实际案例演示 Agent  Skills 的工作原理，以可再生能源演示文稿为例。

### 技术实现要点

**关键配置参数包括**：

<CodeGroup>

  ```python Python theme={null}
  import anthropic

  client = anthropic.Anthropic()

  # Create a message with the PowerPoint  Skill 
  response = client.beta.messages.create(
      model="claude-sonnet-4-5-20250929",
      max_tokens=4096,
      betas=["code-execution-2025-08-25", "skills-2025-10-02"],
      container={
          "skills": [
              {
                  "type": "anthropic",
                  "skill_id": "pptx",
                  "version": "latest"
              }
          ]
      },
      messages=[{
          "role": "user",
          "content": "Create a presentation about renewable energy with 5 slides"
      }],
      tools=[{
          "type": "code_execution_20250825",
          "name": "code_execution"
      }]
  )

  print(response.content)
  ```

  ```typescript TypeScript theme={null}
  import Anthropic from '@anthropic-ai/sdk';

  const client = new Anthropic();

  # Create a message with the PowerPoint  Skill 
  const response = await client.beta.messages.create({
    model: 'claude-sonnet-4-5-20250929',
    max_tokens: 4096,
    betas: ['code-execution-2025-08-25', 'skills-2025-10-02'],
    container: {
      skills: [
        {
          type: 'anthropic',
          skill_id: 'pptx',
          version: 'latest'
        }
      ]
    },
    messages: [{
      role: 'user',
      content: 'Create a presentation about renewable energy with 5 slides'
    }],
    tools: [{
      type: 'code_execution_20250825',
      name: 'code_execution'
    }]
  });

  console.log(response.content);
  ```

  ```bash Shell theme={null}
  curl https://api.anthropic.com/v1/messages \
    -H "x-api-key: $ANTHROPIC_API_KEY" \
    -H "anthropic-version: 2023-06-01" \
    -H "anthropic-beta: code-execution-2025-08-25,skills-2025-10-02" \
    -H "content-type: application/json" \
    -d '{
      "model": "claude-sonnet-4-5-20250929",
      "max_tokens": 4096,
      "container": {
        "skills": [
          {
            "type": "anthropic",
            "skill_id": "pptx",
            "version": "latest"
          }
        ]
      },
      "messages": [{
        "role": "user",
        "content": "Create a presentation about renewable energy with 5 slides"
      }],
      "tools": [{
        "type": "code_execution_20250825",
        "name": "code_execution"
      }]
    }'
  ```
</CodeGroup>

### 核心参数解析

**container 配置的关键要素**：
* **`container.skills`**：指定 Claude 可以使用的  Skills 类型
* **`type: "anthropic"`**：标识为 Anthropic 官方管理的  Skill 
* **`skill_id: "pptx"`**：PowerPoint  Skill  的唯一标识符
* **`version: "latest"`**：使用最新发布的  Skill  版本
* **`tools`**：启用代码执行功能（ Skill  运行必需）
* **Beta 标头**：必须同时启用 `code-execution-2025-08-25` 和 `skills-2025-10-02`

### 智能匹配机制

**渐进式披露的第二层**：
* Claude 自动分析用户请求与可用  Skill  的匹配度
* 基于任务需求（演示文稿创建）确定 PowerPoint  Skill  为最佳选择
* 动态加载  Skill  的完整说明和执行代码
* 在代码执行容器中完成文件创建

## 步骤 3：下载创建的文件

**第三步的核心价值**：掌握从代码执行容器中获取生成文件的完整流程。

### 文件处理机制

**生成的文件存储特点**：
* 文件在隔离的代码执行容器中创建
* API 响应包含文件 ID 引用信息
* 需要通过 Files API 进行文件下载

### 下载实现方法

**三种编程语言的完整实现**：

<CodeGroup>

  ```python Python theme={null}
  # Extract file ID from response
  file_id = None
  for block in response.content:
      if block.type == 'tool_use' and block.name == 'code_execution':
          # File ID is in the tool result
          for result_block in block.content:
              if hasattr(result_block, 'file_id'):
                  file_id = result_block.file_id
                  break

  if file_id:
      # Download the file
      file_content = client.beta.files.download(
          file_id=file_id,
          betas=["files-api-2025-04-14"]
      )

      # Save to disk
      with open("renewable_energy.pptx", "wb") as f:
          file_content.write_to_file(f.name)

      print(f"Presentation saved to renewable_energy.pptx")
  ```

  ```typescript TypeScript theme={null}
  // Extract file ID from response
  let fileId: string | null = null;
  for (const block of response.content) {
    if (block.type === 'tool_use' && block.name === 'code_execution') {
      // File ID is in the tool result
      for (const resultBlock of block.content) {
        if ('file_id' in resultBlock) {
          fileId = resultBlock.file_id;
          break;
        }
      }
    }
  }

  if (fileId) {
    // Download the file
    const fileContent = await client.beta.files.download(fileId, {
      betas: ['files-api-2025-04-14']
    });

    // Save to disk
    const fs = require('fs');
    fs.writeFileSync('renewable_energy.pptx', Buffer.from(await fileContent.arrayBuffer()));

    console.log('Presentation saved to renewable_energy.pptx');
  }
  ```

  ```bash Shell theme={null}
  # Extract file_id from response (using jq)
  FILE_ID=$(echo "$RESPONSE" | jq -r '.content[] | select(.type=="tool_use" and .name=="code_execution") | .content[] | select(.file_id) | .file_id')

  # Download the file
  curl "https://api.anthropic.com/v1/files/$FILE_ID/content" \
    -H "x-api-key: $ANTHROPIC_API_KEY" \
    -H "anthropic-version: 2023-06-01" \
    -H "anthropic-beta: files-api-2025-04-14" \
    --output renewable_energy.pptx

  echo "Presentation saved to renewable_energy.pptx"
  ```
</CodeGroup>

<Note>
  **如需详细了解**，有关处理生成文件的完整详细信息，请参阅 [代码执行工具文档](/zh-CN/docs/agents-and-tools/tool-use/code-execution-tool#retrieve-generated-files)。
</Note>

## 尝试更多示例

**掌握基础后的进阶实践**：通过不同类型的文档创建，全面了解 Agent  Skills 的应用场景。

### Excel 电子表格创建

**核心配置调整**：将 `skill_id` 从 `pptx` 改为 `xlsx`

<CodeGroup>

  ```python Python theme={null}
  response = client.beta.messages.create(
      model="claude-sonnet-4-5-20250929",
      max_tokens=4096,
      betas=["code-execution-2025-08-25", "skills-2025-10-02"],
      container={
          "skills": [
              {
                  "type": "anthropic",
                  "skill_id": "xlsx",
                  "version": "latest"
              }
          ]
      },
      messages=[{
          "role": "user",
          "content": "Create a quarterly sales tracking spreadsheet with sample data"
      }],
      tools=[{
          "type": "code_execution_20250825",
          "name": "code_execution"
      }]
  )
  ```

  ```typescript TypeScript theme={null}
  const response = await client.beta.messages.create({
    model: 'claude-sonnet-4-5-20250929',
    max_tokens: 4096,
    betas: ['code-execution-2025-08-25', 'skills-2025-10-02'],
    container: {
      skills: [
        {
          type: 'anthropic',
          skill_id: 'xlsx',
          version: 'latest'
        }
      ]
    },
    messages: [{
      role: 'user',
      content: 'Create a quarterly sales tracking spreadsheet with sample data'
    }],
    tools: [{
      type: 'code_execution_20250825',
      name: 'code_execution'
    }]
  });
  ```

  ```bash Shell theme={null}
  curl https://api.anthropic.com/v1/messages \
    -H "x-api-key: $ANTHROPIC_API_KEY" \
    -H "anthropic-version: 2023-06-01" \
    -H "anthropic-beta: code-execution-2025-08-25,skills-2025-10-02" \
    -H "content-type: application/json" \
    -d '{
      "model": "claude-sonnet-4-5-20250929",
      "max_tokens": 4096,
      "container": {
        "skills": [
          {
            "type": "anthropic",
            "skill_id": "xlsx",
            "version": "latest"
          }
        ]
      },
      "messages": [{
        "role": "user",
        "content": "Create a quarterly sales tracking spreadsheet with sample data"
      }],
      "tools": [{
        "type": "code_execution_20250825",
        "name": "code_execution"
      }]
    }'
  ```
</CodeGroup>

### Word 文档创建

**核心配置调整**：将 `skill_id` 改为 `docx`

<CodeGroup>

  ```python Python theme={null}
  response = client.beta.messages.create(
      model="claude-sonnet-4-5-20250929",
      max_tokens=4096,
      betas=["code-execution-2025-08-25", "skills-2025-10-02"],
      container={
          "skills": [
              {
                  "type": "anthropic",
                  "skill_id": "docx",
                  "version": "latest"
              }
          ]
      },
      messages=[{
          "role": "user",
          "content": "Write a 2-page report on the benefits of renewable energy"
      }],
      tools=[{
          "type": "code_execution_20250825",
          "name": "code_execution"
      }]
  )
  ```

  ```typescript TypeScript theme={null}
  const response = await client.beta.messages.create({
    model: 'claude-sonnet-4-5-20250929',
    max_tokens: 4096,
    betas: ['code-execution-2025-08-25', 'skills-2025-10-02'],
    container: {
      skills: [
        {
          type: 'anthropic',
          skill_id: 'docx',
          version: 'latest'
        }
      ]
    },
    messages: [{
      role: 'user',
      content: 'Write a 2-page report on the benefits of renewable energy'
    }],
    tools: [{
      type: 'code_execution_20250825',
      name: 'code_execution'
    }]
  });
  ```

  ```bash Shell theme={null}
  curl https://api.anthropic.com/v1/messages \
    -H "x-api-key: $ANTHROPIC_API_KEY" \
    -H "anthropic-version: 2023-06-01" \
    -H "anthropic-beta: code-execution-2025-08-25,skills-2025-10-02" \
    -H "content-type: application/json" \
    -d '{
      "model": "claude-sonnet-4-5-20250929",
      "max_tokens": 4096,
      "container": {
        "skills": [
          {
            "type": "anthropic",
            "skill_id": "docx",
            "version": "latest"
          }
        ]
      },
      "messages": [{
        "role": "user",
        "content": "Write a 2-page report on the benefits of renewable energy"
      }],
      "tools": [{
        "type": "code_execution_20250825",
        "name": "code_execution"
      }]
    }'
  ```
</CodeGroup>

### PDF 文档生成

**核心配置调整**：将 `skill_id` 改为 `pdf`

<CodeGroup>

  ```python Python theme={null}
  response = client.beta.messages.create(
      model="claude-sonnet-4-5-20250929",
      max_tokens=4096,
      betas=["code-execution-2025-08-25", "skills-2025-10-02"],
      container={
          "skills": [
              {
                  "type": "anthropic",
                  "skill_id": "pdf",
                  "version": "latest"
              }
          ]
      },
      messages=[{
          "role": "user",
          "content": "Generate a PDF invoice template"
      }],
      tools=[{
          "type": "code_execution_20250825",
          "name": "code_execution"
      }]
  )
  ```

  ```typescript TypeScript theme={null}
  const response = await client.beta.messages.create({
    model: 'claude-sonnet-4-5-20250929',
    max_tokens: 4096,
    betas: ['code-execution-2025-08-25', 'skills-2025-10-02'],
    container: {
      skills: [
        {
          type: 'anthropic',
          skill_id: 'pdf',
          version: 'latest'
        }
      ]
    },
    messages: [{
      role: 'user',
      content: 'Generate a PDF invoice template'
    }],
    tools: [{
      type: 'code_execution_20250825',
      name: 'code_execution'
    }]
  });
  ```

  ```bash Shell theme={null}
  curl https://api.anthropic.com/v1/messages \
    -H "x-api-key: $ANTHROPIC_API_KEY" \
    -H "anthropic-version: 2023-06-01" \
    -H "anthropic-beta: code-execution-2025-08-25,skills-2025-10-02" \
    -H "content-type: application/json" \
    -d '{
      "model": "claude-sonnet-4-5-20250929",
      "max_tokens": 4096,
      "container": {
        "skills": [
          {
            "type": "anthropic",
            "skill_id": "pdf",
            "version": "latest"
          }
        ]
      },
      "messages": [{
        "role": "user",
        "content": "Generate a PDF invoice template"
      }],
      "tools": [{
        "type": "code_execution_20250825",
        "name": "code_execution"
      }]
    }'
  ```
</CodeGroup>

## 后续步骤

**完成基础学习后的进阶路径**：六个核心方向帮助您深入掌握 Agent  Skills 生态系统。

<CardGroup cols={2}>
  <Card title="API 指南" icon="book" href="/zh-CN/api/skills-guide">
    使用 Claude API 的  Skills
  </Card>

  <Card title="创建自定义  Skills" icon="code" href="/zh-CN/api/skills/create-skill">
    上传您自己的  Skills 用于专门任务
  </Card>

  <Card title="创作指南" icon="pen" href="/zh-CN/docs/agents-and-tools/agent-skills/best-practices">
    学习编写有效  Skills 的最佳实践
  </Card>

  <Card title="在 Claude Code 中使用  Skills" icon="terminal" href="/zh-CN/docs/claude-code/skills">
    了解 Claude Code 中的  Skills
  </Card>

  <Card title="在 Agent SDK 中使用  Skills" icon="cube" href="/zh-CN/api/agent-sdk/skills">
    在 TypeScript 和 Python 中以编程方式使用  Skills
  </Card>

  <Card title="Agent  Skills Cookbook" icon="book-open" href="https://github.com/anthropics/anthropic-cookbook/blob/main/skills/README.md">
    探索示例  Skills 和实现模式
  </Card>
</CardGroup>