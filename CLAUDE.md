# OhMyAICodingToolbox - AI Coding Toolbox

[English](#english) | [中文](#中文)

---

<a name="english"></a>
## English

This project provides pre-built commands/skills for AI coding tools (such as Claude Code, Cursor Agent) to help with more efficient software development.

### Project Types

This project supports two development scenarios. Choose the corresponding type based on your current work:

#### 1. Application Development

**Applicable scenarios**: Developing application features, new feature development, bug fixes, etc.

**Directory**: `application/en/`

**Available Commands**:

| Command | Purpose | When to Use |
|---------|---------|-------------|
| `oh.specify` | Create feature specification | When starting new feature development |
| `oh.plan` | Create technical plan | After spec is confirmed, design implementation |
| `oh.implement` | Execute technical plan | After plan is confirmed, start implementation |

**Development Flow**:

```
User Requirement → oh.specify → oh.plan → oh.implement → Done
```

**Usage Examples**:

```bash
# 1. Start new feature - Create specification
/oh.specify Add user login feature

# 2. After spec confirmed - Create technical plan
/oh.plan

# 3. After plan confirmed - Execute implementation
/oh.implement
```

**Command Details**:

- **oh.specify**: Create feature specification document (spec.md) based on user description
  - Generate branch name
  - Define user scenarios
  - Write E2E test cases (Golden Cases)
  - List clarification questions (max 3)

- **oh.plan**: Create technical plan document (plan.md) based on specification
  - Technical research and solution selection
  - Data model design (including database design)
  - File modification plan
  - Detailed task list

- **oh.implement**: Execute technical plan until tests pass
  - Execute tasks by phase
  - Run E2E tests
  - Fix issues until tests pass
  - Update memory file (record best practices)

#### 2. Testing Development

**Applicable scenarios**: Writing test cases, test framework setup, test tool development, etc.

**Directory**: `test_project/en/`

> **Note**: Commands in this category are under development

### Directory Structure

```
OhMyAICodingToolbox/
├── application/           # Application development skills
│   ├── en/               # English version
│   │   ├── oh.specify.md
│   │   ├── oh.plan.md
│   │   └── oh.implement.md
│   └── zh/               # Chinese version
│       ├── oh.specify.md
│       ├── oh.plan.md
│       └── oh.implement.md
├── test_project/          # Testing development skills
│   ├── en/               (under development)
│   └── zh/               (under development)
├── scripts/               # Installation scripts
│   ├── install.ps1        # Windows installation script
│   └── install.sh         # macOS/Linux installation script
└── CLAUDE.md              # This file
```

### Installation

This project provides installation scripts to install commands/skills to Cursor or Claude Code directories.

#### Memory Path Configuration

Different AI tools store memory/rules in different locations. The installer automatically configures the correct path:

| Tool | Memory Path | Description |
|------|-------------|-------------|
| **Claude Code** | `CLAUDE.md` | Project root memory file |
| **Cursor** | `.cursor/rules/memory.mdc` | Cursor rules directory |

#### Installation Location

AI coding tools support two configuration levels:

| Level | Directory | Description |
|-------|-----------|-------------|
| **User level** | `~/.cursor/` or `~/.claude/` | Global, available for all projects |
| **Project level** | `<project>/.cursor/` or `<project>/.claude/` | Only for current project |

#### Windows Installation

Run installation script using PowerShell:

```powershell
# Interactive mode - prompts for tool and scope selection
.\scripts\install.ps1

# Install Chinese version
.\scripts\install.ps1 -Lang zh

# Non-interactive: specify all parameters
.\scripts\install.ps1 -Tool Claude -Scope User           # Claude Code, User level
.\scripts\install.ps1 -Tool Cursor -Scope Project        # Cursor, Project level
.\scripts\install.ps1 -Tool Claude -Scope User -Lang zh  # Claude Code, Chinese
```

**Parameters**:
- `-Tool`: Tool selection (required), options: `Cursor`, `Claude`
- `-Scope`: Installation scope, options: `User`, `Project` (interactive if not provided)
- `-Lang`: Language, options: `en` (default), `zh`

#### macOS/Linux Installation

Run installation script using Bash:

```bash
# Grant execute permission (first time)
chmod +x scripts/install.sh

# Interactive mode - prompts for tool and scope selection
./scripts/install.sh

# Non-interactive: specify all parameters
./scripts/install.sh Claude User          # Claude Code, User level
./scripts/install.sh Cursor Project       # Cursor, Project level
./scripts/install.sh Claude User zh       # Claude Code, Chinese
```

**Parameters**:
- 1st parameter: Tool selection, options: `Cursor`, `Claude` (interactive if not provided)
- 2nd parameter: Installation scope, options: `User`, `Project` (interactive if not provided)
- 3rd parameter: Language, options: `en` (default), `zh`

#### Verify Installation

After installation, check target directory:

```bash
# Windows (PowerShell)
ls $env:USERPROFILE\.cursor\commands   # For Cursor
ls $env:USERPROFILE\.claude\commands   # For Claude Code

# macOS/Linux
ls ~/.cursor/commands   # For Cursor
ls ~/.claude/commands   # For Claude Code
```

You should see `oh.specify.md`, `oh.plan.md`, `oh.implement.md` files.

### Extending This Project

#### Adding New Commands

1. Create new `.md` file in corresponding type directory
2. Define description using YAML front matter
3. Use `{{MEMORY_PATH}}` placeholder for memory file references
4. Write content following existing command format

#### Adding New Project Types

1. Create new type directory in project root (e.g., `automation/`)
2. Create `en/` and `zh/` subdirectories in that directory
3. Add corresponding type description in this file

### Project Conventions

- All commands use `oh.` prefix (OhMyAI Coding Toolbox abbreviation)
- Documentation uses Markdown format
- Each command must have clear description
- Use `{{MEMORY_PATH}}` placeholder for tool-specific memory paths
- Follow Test-Driven Development (TDD) principles

### FAQ

#### Installation Related

**Q: Commands not recognized after installation?**
A: Try these steps:
1. Confirm files are correctly installed to target directory
2. Restart Cursor or Claude Code
3. Check file format is correct (YAML front matter required)

**Q: How to update installed commands?**
A: Re-run the installation script. Files are copied with tool-specific configurations.

**Q: Can I install for both Cursor and Claude Code?**
A: Yes, run the installer twice with different `-Tool` parameters.

#### Usage Related

**Q: Can I skip steps and implement directly?**
A: Not recommended. Specification and planning phases are key for quality and maintainability. But if you have clear design, you can run `oh.implement` directly.

**Q: How to modify generated spec or plan?**
A: Directly edit `specs/{branch-name}/spec.md` or `plan.md`, then continue to next step.

**Q: What if tests fail?**
A: `oh.implement` will automatically analyze failure causes and fix until all tests pass.

---

<a name="中文"></a>
## 中文

本项目为 AI coding 工具（如 Claude Code、Cursor Agent）提供预制的 commands/skills，帮助更高效地进行软件开发。

### 项目类型

本项目支持两类开发场景，根据当前工作内容选择对应类型：

#### 1. Application 开发

**适用场景**：开发应用程序功能、新特性开发、Bug 修复等

**目录**：`application/zh/`

**可用 Commands**：

| Command | 用途 | 使用时机 |
|---------|------|----------|
| `oh.specify` | 创建功能规范 | 开始新功能开发时 |
| `oh.plan` | 创建技术方案 | 规范确认后，设计实施方案 |
| `oh.implement` | 执行技术方案 | 方案确认后，开始实施 |

**开发流程**：

```
用户需求 → oh.specify → oh.plan → oh.implement → 完成
```

**使用示例**：

```bash
# 1. 开始新功能 - 创建规范
/oh.specify 添加用户登录功能

# 2. 确认规范后 - 创建技术方案
/oh.plan

# 3. 确认方案后 - 执行实施
/oh.implement
```

**各 Command 详细说明**：

- **oh.specify**：基于用户描述创建功能规范文档（spec.md）
  - 生成分支名称
  - 定义用户场景
  - 编写 E2E 测试用例（Golden Case）
  - 列出待澄清问题（最多 3 个）

- **oh.plan**：基于规范创建技术方案文档（plan.md）
  - 技术调研与方案选型
  - 数据模型设计（含数据库设计）
  - 文件修改方案
  - 详细任务列表

- **oh.implement**：执行技术方案直到测试通过
  - 按阶段执行任务
  - 运行 E2E 测试
  - 修复问题直到测试通过
  - 更新记忆文件（记录最佳实践）

#### 2. Testing 开发

**适用场景**：编写测试用例、测试框架搭建、测试工具开发等

**目录**：`test_project/zh/`

> **注意**：此类别下的 commands 正在开发中

### 工作目录结构

```
OhMyAICodingToolbox/
├── application/           # Application 开发技能
│   ├── en/               # 英文版
│   │   ├── oh.specify.md
│   │   ├── oh.plan.md
│   │   └── oh.implement.md
│   └── zh/               # 中文版
│       ├── oh.specify.md
│       ├── oh.plan.md
│       └── oh.implement.md
├── test_project/          # Testing 开发技能
│   ├── en/               (待开发)
│   └── zh/               (待开发)
├── scripts/               # 安装脚本
│   ├── install.ps1        # Windows 安装脚本
│   └── install.sh         # macOS/Linux 安装脚本
└── CLAUDE.md              # 本文件
```

### 安装

本项目提供安装脚本，将 commands/skills 安装到 Cursor 或 Claude Code 的目录中。

#### 记忆路径配置

不同的 AI 工具将记忆/规则存储在不同位置，安装程序会自动配置正确的路径：

| 工具 | 记忆路径 | 说明 |
|------|----------|------|
| **Claude Code** | `CLAUDE.md` | 项目根目录的记忆文件 |
| **Cursor** | `.cursor/rules/memory.mdc` | Cursor 规则目录 |

#### 安装位置说明

AI coding 工具支持两个级别的配置：

| 级别 | 目录 | 说明 |
|------|------|------|
| **用户级别** | `~/.cursor/` 或 `~/.claude/` | 全局生效，所有项目可用 |
| **项目级别** | `<项目>/.cursor/` 或 `<项目>/.claude/` | 仅当前项目生效 |

#### Windows 安装

使用 PowerShell 运行安装脚本：

```powershell
# 交互模式 - 会提示选择工具和安装位置
.\scripts\install.ps1 -Lang zh

# 英文版（交互模式）
.\scripts\install.ps1

# 非交互模式：指定所有参数
.\scripts\install.ps1 -Tool Claude -Scope User -Lang zh      # Claude Code，用户级别
.\scripts\install.ps1 -Tool Cursor -Scope Project -Lang zh   # Cursor，项目级别
.\scripts\install.ps1 -Tool Claude -Scope User               # Claude Code，英文版
```

**参数说明**：
- `-Tool`: 工具选择（必选），可选 `Cursor`、`Claude`
- `-Scope`: 安装范围，可选 `User`、`Project`（不提供则交互选择）
- `-Lang`: 语言，可选 `en`（默认）、`zh`

#### macOS/Linux 安装

使用 Bash 运行安装脚本：

```bash
# 赋予执行权限（首次）
chmod +x scripts/install.sh

# 交互模式 - 会提示选择工具和安装位置
./scripts/install.sh

# 非交互模式：指定所有参数
./scripts/install.sh Claude User zh      # Claude Code，用户级别，中文
./scripts/install.sh Cursor Project zh   # Cursor，项目级别，中文
./scripts/install.sh Claude User         # Claude Code，用户级别，英文
```

**参数说明**：
- 第一个参数: 工具选择，可选 `Cursor`、`Claude`（不提供则交互选择）
- 第二个参数: 安装范围，可选 `User`、`Project`（不提供则交互选择）
- 第三个参数: 语言，可选 `en`（默认）、`zh`

#### 验证安装

安装完成后，检查目标目录：

```bash
# Windows (PowerShell)
ls $env:USERPROFILE\.cursor\commands   # Cursor
ls $env:USERPROFILE\.claude\commands   # Claude Code

# macOS/Linux
ls ~/.cursor/commands   # Cursor
ls ~/.claude/commands   # Claude Code
```

应该能看到 `oh.specify.md`、`oh.plan.md`、`oh.implement.md` 三个文件。

### 扩展本项目

#### 添加新的 Command

1. 在对应类型目录下创建新的 `.md` 文件
2. 使用 YAML front matter 定义 description
3. 使用 `{{MEMORY_PATH}}` 占位符引用记忆文件
4. 按照现有 command 的格式编写内容

#### 添加新的项目类型

1. 在项目根目录创建新的类型目录（如 `automation/`）
2. 在该目录下创建 `en/` 和 `zh/` 子目录
3. 在本文件中添加对应的类型说明

### 项目约定

- 所有 command 使用 `oh.` 前缀（OhMyAI Coding Toolbox 的缩写）
- 文档使用 Markdown 格式
- 每个 command 必须有清晰的 description
- 使用 `{{MEMORY_PATH}}` 占位符引用工具特定的记忆路径
- 遵循测试驱动开发（TDD）原则

### 常见问题

#### 安装相关

**Q: 安装后 Cursor/Claude Code 没有识别到命令？**
A: 尝试以下步骤：
1. 确认文件已正确安装到目标目录
2. 重启 Cursor 或 Claude Code
3. 检查文件格式是否正确（YAML front matter 必须）

**Q: 如何更新已安装的命令？**
A: 重新运行安装脚本。文件会被复制并配置工具特定的路径。

**Q: 可以同时安装 Cursor 和 Claude Code 吗？**
A: 可以，使用不同的 `-Tool` 参数运行两次安装程序即可。

#### 使用相关

**Q: 可以跳过某个步骤直接实施吗？**
A: 不建议。规范和方案阶段是确保质量和可维护性的关键。但如果已有明确设计，可以直接运行 `oh.implement`。

**Q: 如何修改生成的规范或方案？**
A: 直接编辑 `specs/{branch-name}/spec.md` 或 `plan.md`，然后继续下一个步骤。

**Q: 测试失败怎么办？**
A: `oh.implement` 会自动分析失败原因并修复，直到所有测试通过。

---

## Version History / 版本历史

- v1.2.0: Tool-specific memory path support / 支持工具特定的记忆路径配置
- v1.1.0: Added bilingual support (English/Chinese) / 添加双语支持（英文/中文）
- v1.0.0: Initial version with 3 core Application commands / 初始版本，包含 Application 开发的三个核心 command
