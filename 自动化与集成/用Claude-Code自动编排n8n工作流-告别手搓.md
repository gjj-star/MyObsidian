## Claude Code + n8n 创建工作流

n8n 工作流没有被淘汰，它成为了智能体的底层执行搭档。在 hesamsheikh/awesome-openclaw-usecases 的 GitHub 仓库中，展示了 **OpenClaw** 结合 **n8n** 进行工作流编排的具体工程实例。
n8n 也在持续迭代，其云端付费版本内置了 AI 工作流生成功能。在开源社区中，开发者通过 n8n MCP 和 n8n Skills 协议，让 Claude Code 或 OpenCode 这种终端智能体自主完成工作流的创建与修改。

**GitHub仓库地址：`czlonkowski/n8n-mcp`， `czlonkowski/n8n-skills`。**

以下是如何在 Claude Code 和 OpenCode 中集成 n8n MCP 与 n8n Skills，并让智能体生成自动化工作流。

## 环境准备与依赖安装

### n8n 安装
安装 n8n 有两种主流方式，分别是 npm 全局安装和 Docker 容器部署。

**npm 安装：**
确保你的机器上安装了Node.js。
```bash
npm install -g n8n
```

安装好后，先设置这几个环境变量，解锁n8n的隐藏节点和限制功能。
```bash
# 取消所有限制, 所有节点都可用
setx NODES_EXCLUDE "[]"
# 开启 execute command
setx N8N_ENABLE_EXECUTE_COMMAND "true"
setx N8N_BLOCK_ENV_VARS_IN_EXECUTE_COMMAND "false"
# 允许 community packages 使用系统能力
setx N8N_COMMUNITY_PACKAGES_ALLOW_TOOL_USAGE "true"
# 增强能力
setx N8N_RUNNERS_ENABLED "true"
setx N8N_ENFORCE_SETTINGS_FILE_PERMISSIONS "true"
```
然后关闭命令行重开，输入n8n回车，就可以开启工作流面板。

**Docker 部署：**

下载并安装 **Docker Desktop**。
然后在一个空文件夹中创建`compose.yaml`文件，输入以下内容保存：
```yaml
services:
  n8n:
    image: docker.n8n.io/n8nio/n8n
    container_name: n8n
    user: root
    restart: unless-stopped
    ports:
      - "5678:5678"
    environment:
      - TZ=Asia/Shanghai
      - GENERIC_TIMEZONE=Asia/Shanghai
      - N8N_RUNNERS_ENABLED=true
      - N8N_ENFORCE_SETTINGS_FILE_PERMISSIONS=true

      # ===== 关键：解锁文件系统写入权限 =====
      - N8N_BLOCK_FS_WRITE_ACCESS=false

      # ===== 解锁所有节点 =====
      - NODES_EXCLUDE=[]

      # ===== 解锁代码能力 =====
      - NODE_FUNCTION_ALLOW_BUILTIN=*
      - NODE_FUNCTION_ALLOW_EXTERNAL=*

      # ===== 允许社区节点 =====
      - N8N_UNVERIFIED_PACKAGES_ENABLED=true

    volumes:
      - n8n_data:/home/node/.n8n
      # ===== 关键：挂载本地硬盘目录 =====
      # 建议使用正斜杠，避免 Windows 转义字符坑
      - "D:/repo/daily-info:/data"

volumes:
  n8n_data:
```
然后在当前文件夹打开命令行工具，输入`docker-compose up -d`回车即可。

也可以通过Docker Desktop中的搜索功能，搜索n8n来安装，更简单。但我上面的yaml中解锁了隐藏节点和特殊权限，更推荐用yaml的方式安装。
安装后，打开`http://localhost:5678/`即可访问n8n页面。

### n8n 前置配置

n8n 服务启动后，需要完成两项前置操作：

1. **生成 n8n API 密钥**：在设置面板中创建 API 凭证并记录 Secret，后续配置 MCP 协议时会调用这个密钥。
2. **创建 Credential**：n8n MCP 仅负责编排工作流拓扑结构，不会自动生成底层业务凭证。这里需要手动创建一个 OpenAI 凭证，填入 API Key 和 Base URL。如果工作流涉及 Notion 等第三方应用，需要同步建立对应的 Credential 实例。

### Claude Code 部署与模型转接

使用 npm 安装 Claude Code CLI 工具：

```bash
npm install -g @anthropic-ai/claude-code
```

Anthropic 官方接口存在严格的区域限制。通过设置环境变量，可以将底层模型转接至 OpenRouter 提供的兼容端点，**也可使用DeepSeek/GLM等兼容Anthropic的模型**。
比如：
*   **智谱 GLM 兼容Anthropic的 ase URL**: `https://open.bigmodel.cn/api/anthropic`
*   **DeepSeek 兼容Anthropic的 Base URL**: `https://api.deepseek.com/anthropic`

Windows配置方式如下（cmd）：
```bash
setx ANTHROPIC_BASE_URL "https://openrouter.ai/api"
setx ANTHROPIC_MODEL "moonshotai/kimi-k2.5"
setx ANTHROPIC_AUTH_TOKEN "你的API Key"
setx ANTHROPIC_API_KEY ""
```
Mac配置方式（Terminal）：
```bash
echo 'export ANTHROPIC_BASE_URL="https://openrouter.ai/api"' >> ~/.zshrc
echo 'export ANTHROPIC_MODEL="minimax/minimax-m2.7"' >> ~/.zshrc
echo 'export ANTHROPIC_AUTH_TOKEN="你的API Key"' >> ~/.zshrc
echo 'export ANTHROPIC_API_KEY=""' >> ~/.zshrc
source ~/.zshrc
```

ANTHROPIC_API_KEY 必须强制置空，是为了防止触发原生 Anthropic 鉴权拦截。

### MCP 与 Skills 配置

**配置 Skills**：在计算机用户目录的 .claude 文件夹内创建 skills 目录（例如 `C:\Users\用户名\.claude\skills`），将 n8n Skills 文件放入这个目录，智能体会在启动时加载这些约束规则。

**配置 MCP**：在用户目录编辑 .claude.json 文件，声明 n8n MCP 服务器的运行参数和环境变量。

```json
{
  "mcpServers": {
    "n8n-mcp": {
      "command": "npx",
      "args": [
        "-y",
        "n8n-mcp@latest"
      ],
      "env": {
        "MCP_MODE": "stdio",
        "N8N_API_URL": "http://localhost:5678",
        "N8N_API_KEY": "你刚才在n8n中创建的api密钥",
        "WEBHOOK_SECURITY_MODE": "moderate",
        "LOG_LEVEL": "error",
        "DISABLE_CONSOLE_OUTPUT": "true"
      }
    }
  }
}
```

### OpenCode 部署路线

如果倾向于图形化交互，可以下载安装 OpenCode 的桌面端应用程序。
Skill安装路径：`C:\Users\用户名\.config\opencode\skills`
MCP配置：`C:\Users\用户名\.config\opencode\opencode.json`
```json
"n8n-mcp": {
  "type": "local",
  "command": [
	"npx",
	"-y",
	"n8n-mcp@latest"
  ],
  "environment": {
	"MCP_MODE": "stdio",
	"N8N_API_URL": "http://localhost:5678",
	"N8N_API_KEY": "你刚才在n8n中创建的api密钥",
	"WEBHOOK_SECURITY_MODE": "moderate",
	"LOG_LEVEL": "error",
	"DISABLE_CONSOLE_OUTPUT": "true"
  }
}
```

## 连接验证与连通性测试

在智能体终端或输入框中发送指令，验证 MCP 协议与 n8n 实例的交互状态。

```markdown
执行以下探测任务：

1. 列出你目前从 n8n-mcp 服务器获取到的所有可用工具（Tools）。
2. 调用 n8n_health_check（如果可用）或者使用 search_nodes 搜索一下 'PostgreSQL' 节点。
3. 列出你所拥有的n8n相关skills。
4. 尝试读取我本地 n8n 实例的系统版本信息。

如果你能看到工具列表并成功返回了搜索结果或版本号，说明连接已连通，明确告诉我。
```

## 实战：构建 AI 资讯处理工作流

接下来通过自然语言指令，让智能体创建一个具体的学术数据处理的工作流。业务逻辑包含：拉取谷歌DeepMind最新论文、调用 AI 节点翻译、格式化输出并保存本地。

输入指令：


```markdown
任务：在本地 n8n 中构建并部署『AI 论文情报站』自动化工作流。

业务逻辑要求：
- 触发：手动触发工作流
- 数据采集：使用谷歌deepmind的RSS订阅地址：https://deepmind.google/blog/rss.xml。获取最新的10条论文数据。
- AI 处理：使用 OpenAI 节点对每篇论文的 title 和 description 进行学术翻译。在 JSON 结构中显式指定 OpenAI 节点的 Credential ID 为：[你的OpenAI凭证ID]。通过表达式手动指定模型名称为：google/gemini-3-flash-preview。提示词要求 AI 将内容翻译为专业的中文学术语言。
- 数据聚合与格式化：使用对应节点，将 10 篇论文的翻译结果聚合并整理，包含：论文名称、摘要、原始链接、发布日期。
- 保存到n8n内置DataTables：把整理好的数据，保存到n8n 内置 Data Tables中。

交付规范：
- 必须先调用工具：在编写 JSON 前，请先调用 n8n-mcp_get_node 工具确认 RSS、OpenAI 以及文件读写节点在 v2 版本下的最新参数 Schema。
- 引用规则：严禁尝试生成新的凭证，必须且仅能引用我提供的 Credential ID。
- 先展示逻辑计划和关键节点代码草案。在我回复“确认”后，再执行 n8n_create_workflow 进行部署。
请开始执行第一步：调研与规划。
```

智能体接收指令后，会通过 MCP 查阅节点定义，结合 Skills 里的规则约束生成标准 JSON，完成工作流的无代码部署。

## 工程价值对比矩阵

通过指令驱动智能体生成 n8n 工作流，改变了传统的画布拖拽交互。智能体与 n8n 的结合解决了单独依赖智能体执行任务的三个底层缺陷。

|           | 智能体直接执行                            | n8n + 智能体                              |
| --------- | ---------------------------------- | -------------------------------------- |
| **密钥安全性** | 高风险。凭证以明文形式暴露在系统变量或配置文件中。          | 隔离管理。凭证统一存储在 n8n 保险库，OpenClaw 是“无状态”的。 |
| **可观测性**  | 黑盒运行。报错需要翻阅长篇终端日志，定位困难。            | 节点级监控。在 n8n 界面可以追踪每个执行步骤和数据流转状态。       |
| **算力消耗**  | 成本高昂。每次执行重复任务都需要消耗大量 Token 进行逻辑推演。 | 边际成本低。智能体仅在初次构建工作流时消耗 Token，后续执行零模型成本。 |

> **专注 AI 与个人知识管理**
> 本文属于 [杰森的效率工坊](https://jasonai.me)原创。未经允许禁止商用。
> 
> **订阅杰森的频道：**
> [YouTube](https://www.youtube.com/@JasonEfficiencyLab) · [Twitter(X)](https://x.com/JasonEffiLab) · [小红书](https://www.xiaohongshu.com/user/profile/60935957000000000101fbf7) · [B站](https://space.bilibili.com/3546884870244925)