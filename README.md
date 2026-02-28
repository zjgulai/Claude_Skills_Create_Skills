# Claude Skills 构建完整指南（ClaudeSkillsCreateSkills）

本仓库提供 **ClaudeSkillsCreateSkills** 这一 Agent Skill：指导创建符合 [Agent Skills 开放标准](https://agentskills.io/specification)、适用于 **Claude Code** 与 **Cursor** 的 Skills，并支持通过 add-skill / openskills 从 GitHub 安装与分发。

## 安装

### Cursor

在项目根或任意目录执行（安装到当前项目或自动检测的 agent 目录）：

```bash
npx add-skill <owner>/<repo>
```

仅安装本 Skill（若仓库含多个 skill 时）：

```bash
npx add-skill <owner>/<repo> --skill claude-skills-create-skills
```

全局安装（所有项目可用）：

```bash
npx add-skill <owner>/<repo> -g
```

安装后，Cursor 会将 skill 放入 `.cursor/skills/`（项目级）或 `~/.cursor/skills/`（用户级），可通过 `/claude-skills-create-skills` 或在与「创建 skill、写 SKILL、Claude Skills、Agent Skills」相关的对话中由 agent 自动调用。

### OpenSkills

```bash
npx openskills install <owner>/<repo>
```

默认可能安装到 `./.claude/skills` 或 `./.agent/skills`；使用 `--global` 时以工具文档为准（如 `~/.claude/skills`）。

### Claude Code

- **项目级**：将本仓库中的 `ClaudeSkillsCreateSkills` 目录复制到项目下的 `.claude/skills/`。
- **用户级**：复制到 `~/.claude/skills/`。
- 也可通过 Claude Code 的 Plugin 机制安装（若已配置从 GitHub 加载 skill 的插件）。

## 目录结构

```
.
├── README.md
├── LICENSE
├── PLAN_ClaudeSkillsCreateSkills.md   # 构建本 Skill 的计划文档
└── ClaudeSkillsCreateSkills/          # Skill 包（add-skill 会识别此目录）
    ├── SKILL.md                        # 主说明（框架、组件、写作原则、发布与校验）
    ├── reference.md                    # frontmatter 与规范、路径、安装命令速查
    ├── examples.md                     # 2–3 个完整 Skill 示例
    └── scripts/
        └── validate-skill.sh           # 发布前校验（name、description、SKILL.md）
```

## 与 Agent Skills 标准的关系

本 Skill 遵循 [Agent Skills 规范](https://agentskills.io/specification)（agentskills.io），并融合 Claude Code 官方文档中的扩展（如 `disable-model-invocation`、`context: fork`、参数占位符）。在 Cursor、Claude Code、以及支持该开放标准的其他 agent 中均可使用。

## 校验

在 `ClaudeSkillsCreateSkills` 目录下执行：

```bash
./scripts/validate-skill.sh
```

或校验任意 skill 目录：

```bash
./scripts/validate-skill.sh /path/to/skill-dir
```

## 许可证

见 [LICENSE](LICENSE) 文件。
