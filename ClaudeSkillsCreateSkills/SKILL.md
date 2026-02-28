---
name: claude-skills-create-skills
description: Guides creation of Agent Skills compliant with the open standard for Claude Code and Cursor. Use when the user wants to create, write, or author a new Skill, set up Claude Skills / Agent Skills, or asks about SKILL.md structure, best practices, publishing to GitHub, or installing via add-skill/openskills. Covers 创建 skill、写 SKILL、Claude Skills 构建、Agent Skills 规范.
---

# Claude Skills 构建完整指南

本 Skill 指导创建符合 [Agent Skills 开放标准](https://agentskills.io/specification)、适用于 Claude Code 与 Cursor 的 Skills，并支持通过 add-skill / openskills 从 GitHub 安装。

## 何时使用本 Skill

- 用户要**创建新 Skill**、编写或修改 `SKILL.md`、了解 Skill 目录结构或 frontmatter。
- 用户提到 **Claude Skills**、**Agent Skills**、**创建 skill**、**写 SKILL**、**Skill 模版**、**发布到 GitHub**、**openskills install**、**add-skill**。
- 需要统一满足 agentskills.io 规范与 Claude Code / Cursor 扩展字段，或需要发布前校验清单与安装说明。

## 构建框架总览

三层结构：**规范层** → **指南层** → **实战层**。先满足规范，再应用指南，最后落地实战与发布。

```
┌─────────────────────────────────────────────────────────────────┐
│  实战层 (Practice)                                              │
│  ├─ 写作原则与模式 (Template/Examples/Workflow/Feedback Loop)   │
│  ├─ 反模式与校验 (validate-skill.sh)                            │
│  └─ 多 IDE 安装与发布 (add-skill / openskills)                  │
├─────────────────────────────────────────────────────────────────┤
│  指南层 (Guide)                                                 │
│  ├─ Claude Code 完整指南 (frontmatter/支持文件/hooks)          │
│  ├─ 渐进式披露 (name/description → SKILL正文 → 引用文件)       │
│  └─ 调用控制 (disable-model-invocation / context: fork)        │
├─────────────────────────────────────────────────────────────────┤
│  规范层 (Specification)                                         │
│  ├─ Agent Skills 开放标准 (agentskills.io)                     │
│  ├─ SKILL.md 格式 (YAML frontmatter + Markdown)                │
│  └─ 目录与命名约束 (name 与目录一致、kebab-case)                │
└─────────────────────────────────────────────────────────────────┘
```

## 核心组件清单

### 元数据与发现

- **`name`**（必需）：1–64 字符，仅小写字母、数字、连字符；与**父目录名一致**（建议目录用 kebab-case，如 `my-skill-name`）；不能以连字符开头/结尾，不能出现连续连字符 `--`。
- **`description`**（强烈推荐）：1–1024 字符；须包含**做什么（WHAT）**与**何时用（WHEN）**及触发词；用**第三人称**（如 "Processes…" / "Guides…"），便于 agent 自动发现。
- **可选字段**（开放标准）：`license`、`compatibility`、`metadata`。
- **可选字段**（Claude Code 扩展，Cursor 部分支持）：`argument-hint`、`disable-model-invocation`、`user-invocable`、`allowed-tools`、`context`、`agent`、`hooks`。

### 目录结构

- **最少**：`skill-name/SKILL.md`。
- **推荐**：同目录下 `reference.md`、`examples.md`、`scripts/`（Claude/Cursor）；规范可选 `references/`、`assets/`。从 `SKILL.md` 引用时保持**仅一层深度**，避免深层嵌套。

### 内容策略

- 主文件 **< 500 行**；采用**渐进式披露**：先加载 name/description，再在激活时加载 SKILL 正文，最后按需引用 reference/examples/scripts。
- 引用仅一层深度；详细内容放在 `reference.md` 或 `examples.md`，在正文中链接说明「何时查看」。

### 写作模式

- **Template**：提供输出格式模板。
- **Examples**：给出具体输入/输出示例。
- **Workflow**：分步清单与检查项。
- **Conditional Workflow**：按分支（如「新建 vs 编辑」）选择流程。
- **Feedback Loop**：质量关键任务中先执行再校验，失败则修复后重跑。
- **参考型 vs 任务型**：任务型（如部署、提交）可设 `disable-model-invocation: true` 仅手动调用；需隔离执行时可设 `context: fork`（Claude Code）。

### 兼容性矩阵

| 字段 | Agent Skills 规范 | Claude Code | Cursor |
|------|-------------------|-------------|--------|
| `name` | ✅ 必需 | ✅ 必需 | ✅ 必需 |
| `description` | ✅ 强烈推荐 | ✅ 强烈推荐 | ✅ 强烈推荐 |
| `license` | ✅ 可选 | ✅ 支持 | ✅ 支持 |
| `compatibility` | ✅ 可选 | ✅ 支持 | ✅ 支持 |
| `argument-hint` | ❌ | ✅ 支持 | ⚠️ 部分支持 |
| `disable-model-invocation` | ❌ | ✅ 支持 | ⚠️ 部分支持 |
| `user-invocable` | ❌ | ✅ 支持 | ⚠️ 部分支持 |
| `allowed-tools` | ✅ 实验 | ✅ 支持 | ⚠️ 部分支持 |
| `context: fork` | ❌ | ✅ 支持 | ❌ 不支持 |
| `agent` | ❌ | ✅ 支持 | ❌ 不支持 |
| `hooks` | ❌ | ✅ 支持 | ⚠️ 部分支持 |

> ✅ = 完全支持 | ⚠️ = 部分支持/忽略 | ❌ = 不支持/非规范字段

### 多 IDE 与发布

| 环境 | 项目级 | 用户级 |
|------|--------|--------|
| Claude Code | `.claude/skills/` | `~/.claude/skills/` |
| Cursor | `.cursor/skills/` | `~/.cursor/skills/`（勿用 `~/.cursor/skills-cursor/`） |

安装（从 GitHub）：`npx add-skill owner/repo` 或 `npx add-skill owner/repo --skill <name>`；或 `npx openskills install owner/repo`。仓库可为单 skill（根目录即含 `SKILL.md` 的目录）或多 skill（如 `skills/<skill-name>/`）。

## 写作原则

1. **简洁**：仅补充 agent 尚不具备的上下文；每一段都值得占用 token。
2. **主文件 < 500 行**：详细内容放到 reference.md / examples.md，正文中链接。
3. **渐进式披露**：SKILL.md 写要点与导航；细节按需引用。
4. **自由度与任务匹配**：多解任务用文字说明；有首选模式时用模板/伪代码；强一致性任务用具体脚本。

## 模式与反模式

- **推荐**：统一术语（如只用「API endpoint」）、提供默认方案并注明例外、用「当前方法」+「旧模式（deprecated）」代替时间敏感表述、路径用正斜杠 `scripts/helper.py`。
- **避免**：Windows 风格路径 `scripts\helper.py`、罗列过多可选方案而不给默认、时间敏感信息（「2025 年 8 月前用旧 API」）、模糊的 skill 名（如 `helper`、`utils`）。

## 发布与安装

- **GitHub 仓库**：单 skill 时仓库根即 skill 目录（含 `SKILL.md`）；多 skill 时使用 `skills/<skill-name>/`。确保 `name` 与安装后的目录名一致（kebab-case 推荐）。
- **安装命令**：`npx add-skill <owner>/<repo>`（项目或加 `-g` 全局）；选装单个：`npx add-skill <owner>/<repo> --skill <name>`。Cursor 会检测并安装到 `.cursor/skills/` 或 `~/.cursor/skills/`。
- **兼容性说明**：`disable-model-invocation`、`context`、`agent`、`hooks`、动态注入 `!command` 等为 Claude Code 扩展；Cursor 等主要依赖 name/description 与正文，可选字段按环境支持情况使用。

## 发布前校验清单

- [ ] `name` 与父目录名一致（kebab-case），1–64 字符，无连续连字符。
- [ ] `description` 包含 WHAT 与 WHEN，第三人称，含触发词。
- [ ] SKILL.md 正文 < 500 行；引用仅一层深度。
- [ ] 无 Windows 风格路径；术语一致；无时间敏感表述。
- [ ] 若含脚本：依赖已说明，错误信息明确；路径使用 `scripts/` 形式。

可选用本 Skill 自带的 `scripts/validate-skill.sh` 做基础校验（目录名、name、description 长度、SKILL.md 存在性）。

## 最小可用 Frontmatter 模板

```yaml
---
name: your-skill-name
description: One sentence on what it does. Use when [trigger scenario or keywords].
---
```

## 完整 SKILL.md 章节模板

```markdown
---
name: your-skill-name
description: [WHAT: 做什么] + [WHEN: 何时用] + [触发词]。第三人称。
argument-hint: [可选: 参数提示，如 [filename] [format]]
disable-model-invocation: [可选: true，仅手动调用]
---

# Skill 标题

一句话概述本 Skill 的用途。

## 何时使用

- 触发场景 1
- 触发场景 2

## 核心内容

### 组件/概念 1
说明...

### 组件/概念 2
说明...

## 工作流（如适用）

1. 步骤 1
2. 步骤 2
3. 步骤 3

## 模式与反模式

- **推荐**：...
- **避免**：...

## 校验清单

- [ ] 检查项 1
- [ ] 检查项 2

## 附加资源

- 详细参考：见 [reference.md](reference.md)
- 示例：见 [examples.md](examples.md)
```

## 四阶段工作流

创建 Skill 时的推荐流程：

```
┌─────────────────────────────────────────────────────────────────┐
│  阶段 1: 规划 (Plan)                                            │
│  ├─ 确定 Skill 名称和目录结构                                    │
│  ├─ 编写 description（WHAT + WHEN + 触发词）                    │
│  └─ 列出核心章节大纲                                            │
├─────────────────────────────────────────────────────────────────┤
│  阶段 2: 编写 (Write)                                           │
│  ├─ 创建 SKILL.md，填充 frontmatter                             │
│  ├─ 按模板编写正文（保持 < 500 行）                              │
│  └─ 创建 reference.md / examples.md（如需）                     │
├─────────────────────────────────────────────────────────────────┤
│  阶段 3: 校验 (Validate)                                        │
│  ├─ 运行 scripts/validate-skill.sh                              │
│  ├─ 检查 name 与目录名一致                                      │
│  └─ 检查 description 含 WHAT/WHEN                               │
├─────────────────────────────────────────────────────────────────┤
│  阶段 4: 发布 (Publish)                                         │
│  ├─ 推送到 GitHub                                               │
│  ├─ 测试安装：npx add-skill owner/repo --skill name             │
│  └─ 验证 agent 能通过触发词发现                                  │
└─────────────────────────────────────────────────────────────────┘
```

## 附加资源

- Frontmatter 与规范速查、各 IDE 路径与安装命令：见 [reference.md](reference.md)。
- 完整示例 Skill：见 [examples.md](examples.md)。
