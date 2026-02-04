# OhMyAICodingToolbox

[English](#english) | [中文](#中文)

---

<a name="english"></a>
## English

Pre-built commands/skills for AI coding tools (Claude Code, Cursor Agent) to enable more efficient software development.

### Features

#### Application Development Commands

- **oh.specify.app** - Create feature specifications with user scenarios and E2E test cases
- **oh.plan.app** - Generate technical plans with architecture decisions and task lists
- **oh.implement.app** - Execute plans with built-in self-learning memory updates

#### E2E Test Project Commands

- **oh.specify.e2e** - Create test specifications with SUT description, test scope, and test cases
- **oh.plan.e2e** - Generate test plans with framework selection, architecture design (Page Object/API Client)
- **oh.implement.e2e** - Execute test implementation with selector strategies and wait patterns

### Development Flow

**Application Development:**
```
User Requirement → oh.specify.app → oh.plan.app → oh.implement.app → Done
                                                          ↓
                                                   Update Memory
                                                   (Self-learning)
```

**E2E Test Project:**
```
Test Target → oh.specify.e2e → oh.plan.e2e → oh.implement.e2e → Done
                                                    ↓
                                            Update Memory
                                            (Selector/Wait patterns)
```

### Installation

#### Windows (PowerShell)

```powershell
# Interactive mode
.\scripts\install.ps1

# With parameters
.\scripts\install.ps1 -Tool Claude -Scope User -Lang en
.\scripts\install.ps1 -Tool Cursor -Scope Project -Lang zh
```

#### macOS/Linux (Bash)

```bash
chmod +x scripts/install.sh

# Interactive mode
./scripts/install.sh

# With parameters
./scripts/install.sh Claude User en
./scripts/install.sh Cursor Project zh
```

#### Parameters

| Parameter | Options | Description |
|-----------|---------|-------------|
| Tool | `Claude`, `Cursor` | Target AI coding tool |
| Scope | `User`, `Project` | Installation level |
| Lang | `en`, `zh` | Language version |

### Usage

**Application Development:**
```bash
# In Claude Code
/oh.specify.app Add user login feature
/oh.plan.app
/oh.implement.app

# In Cursor
oh.specify.app Add user login feature
oh.plan.app
oh.implement.app
```

**E2E Test Project:**
```bash
# In Claude Code
/oh.specify.e2e Test user authentication API
/oh.plan.e2e
/oh.implement.e2e

# In Cursor
oh.specify.e2e Test user authentication API
oh.plan.e2e
oh.implement.e2e
```

### Directory Structure

```
OhMyAICodingToolbox/
├── app/
│   ├── en/                 # English commands (app development)
│   └── zh/                 # Chinese commands (app development)
├── e2e/
│   ├── en/                 # English commands (E2E testing)
│   └── zh/                 # Chinese commands (E2E testing)
├── scripts/
│   ├── install.ps1         # Windows installer
│   └── install.sh          # macOS/Linux installer
├── CLAUDE.md               # AI memory file
└── README.md               # This file
```

### Memory Path Configuration

The installer automatically configures the correct memory path for each tool:

| Tool | Memory Path |
|------|-------------|
| Claude Code | `CLAUDE.md` |
| Cursor | `.cursor/rules/memory.mdc` |

### FAQ

**Q: Commands not recognized after installation?**
A: Restart Cursor or Claude Code after installation.

**Q: How to update installed commands?**
A: Re-run the installation script.

**Q: Can I install for both tools?**
A: Yes, run the installer twice with different `-Tool` parameters.

### Version History

- v1.4.0 - E2E test project workflow commands
- v1.3.0 - Self-learning memory update mechanism
- v1.2.0 - Tool-specific memory path support
- v1.1.0 - Bilingual support (EN/ZH)
- v1.0.0 - Initial release

---

<a name="中文"></a>
## 中文

为 AI 编码工具（Claude Code、Cursor Agent）提供预制的 commands/skills，帮助更高效地进行软件开发。

### 功能特性

#### 应用开发命令

- **oh.specify.app** - 创建功能规范，包含用户场景和 E2E 测试用例
- **oh.plan.app** - 生成技术方案，包含架构决策和任务列表
- **oh.implement.app** - 执行方案，内置自我学习记忆更新

#### E2E 测试项目命令

- **oh.specify.e2e** - 创建测试规范，包含被测系统描述、测试范围和测试用例
- **oh.plan.e2e** - 生成测试方案，包含框架选型、架构设计（Page Object/API Client）
- **oh.implement.e2e** - 执行测试实现，包含选择器策略和等待模式

### 开发流程

**应用开发：**
```
用户需求 → oh.specify.app → oh.plan.app → oh.implement.app → 完成
                                                  ↓
                                              更新记忆
                                             (自我学习)
```

**E2E 测试项目：**
```
测试目标 → oh.specify.e2e → oh.plan.e2e → oh.implement.e2e → 完成
                                                ↓
                                            更新记忆
                                        (选择器/等待模式)
```

### 安装

#### Windows (PowerShell)

```powershell
# 交互模式
.\scripts\install.ps1

# 指定参数
.\scripts\install.ps1 -Tool Claude -Scope User -Lang zh
.\scripts\install.ps1 -Tool Cursor -Scope Project -Lang en
```

#### macOS/Linux (Bash)

```bash
chmod +x scripts/install.sh

# 交互模式
./scripts/install.sh

# 指定参数
./scripts/install.sh Claude User zh
./scripts/install.sh Cursor Project en
```

#### 参数说明

| 参数 | 选项 | 说明 |
|------|------|------|
| Tool | `Claude`, `Cursor` | 目标 AI 编码工具 |
| Scope | `User`, `Project` | 安装级别 |
| Lang | `en`, `zh` | 语言版本 |

### 使用方法

**应用开发：**
```bash
# 在 Claude Code 中
/oh.specify.app 添加用户登录功能
/oh.plan.app
/oh.implement.app

# 在 Cursor 中
oh.specify.app 添加用户登录功能
oh.plan.app
oh.implement.app
```

**E2E 测试项目：**
```bash
# 在 Claude Code 中
/oh.specify.e2e 测试用户认证 API
/oh.plan.e2e
/oh.implement.e2e

# 在 Cursor 中
oh.specify.e2e 测试用户认证 API
oh.plan.e2e
oh.implement.e2e
```

### 目录结构

```
OhMyAICodingToolbox/
├── app/
│   ├── en/                 # 英文版命令（应用开发）
│   └── zh/                 # 中文版命令（应用开发）
├── e2e/
│   ├── en/                 # 英文版命令（E2E 测试）
│   └── zh/                 # 中文版命令（E2E 测试）
├── scripts/
│   ├── install.ps1         # Windows 安装脚本
│   └── install.sh          # macOS/Linux 安装脚本
├── CLAUDE.md               # AI 记忆文件
└── README.md               # 本文件
```

### 记忆路径配置

安装程序会自动为每个工具配置正确的记忆路径：

| 工具 | 记忆路径 |
|------|----------|
| Claude Code | `CLAUDE.md` |
| Cursor | `.cursor/rules/memory.mdc` |

### 常见问题

**Q: 安装后命令未被识别？**
A: 安装后重启 Cursor 或 Claude Code。

**Q: 如何更新已安装的命令？**
A: 重新运行安装脚本。

**Q: 可以同时为两个工具安装吗？**
A: 可以，使用不同的 `-Tool` 参数运行两次安装程序。

### 版本历史

- v1.4.0 - E2E 测试项目工作流命令
- v1.3.0 - 自我学习记忆更新机制
- v1.2.0 - 支持工具特定的记忆路径
- v1.1.0 - 双语支持（中/英）
- v1.0.0 - 初始版本
