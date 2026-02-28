# Claude Skills 构建完整指南 — 计划文档

## 一、目标与范围

- **交付物**：文件夹名为 `ClaudeSkillsCreateSkills` 的完整 Skill 包，可被 Claude Code / Cursor 等 IDE 调用；支持通过 `npx add-skill` 或 `npx openskills install` 等从 GitHub 安装。
- **质量要求**：全面、稳定、符合 [Agent Skills 开放标准](https://agentskills.io/specification)；使用本 Skill 能生成比现有 Cursor create-skill 更规范、更易发现的 Skills。
- **计划输出**：本计划以 Markdown 形式存储在当前目录（如 `PLAN_ClaudeSkillsCreateSkills.md`），便于评审与执行对照。

---

## 二、官方手册与规范萃取（框架与组件）

### 2.1 核心文献来源

| 来源 | 用途 |
|------|------|
| [Claude Code 官方文档 - 使用 skills 扩展 Claude](https://docs.claude.com/zh-CN/docs/claude-code/skills) | 完整指南：frontmatter、支持文件、调用控制、subagent、动态上下文 |
| [Agent Skills 规范 (agentskills.io/specification)](https://agentskills.io/specification) | 开放标准：目录结构、frontmatter 约束、可选目录、渐进式披露 |
| [Cursor create-skill (SKILL.md)](.cursor/skills-cursor/create-skill/SKILL.md) | 实战：写作原则、模式、反模式、四阶段工作流 |
| [anthropics/skills](https://github.com/anthropics/skills) | 官方示例库：template、skills 目录结构、Plugin 分发 |
| [add-skill / OpenSkills](https://add-skill.org/) | 多 IDE 安装路径与 CLI 用法 |

### 2.2 萃取出的「构建 Claude Skills 完整框架」

```mermaid
flowchart LR
  subgraph spec [规范层]
    A1[Agent Skills 开放标准]
    A2[SKILL.md 格式]
    A3[目录与 frontmatter 约束]
  end
  subgraph guide [指南层]
    B1[Claude Code 完整指南]
    B2[渐进式披露]
    B3[调用控制与 Hooks]
  end
  subgraph practice [实战层]
    C1[写作原则与模式]
    C2[反模式与校验]
    C3[多 IDE 安装与发布]
  end
  spec --> guide --> practice
```

### 2.3 核心组件清单

- **元数据与发现**
  - `name`：1–64 字符，小写+数字+连字符，与目录名一致，无连续连字符（规范 + Claude 文档）。
  - `description`：1–1024 字符，需包含「做什么 + 何时用」及触发词；第三人称（Cursor create-skill）。
  - 可选：`argument-hint`、`disable-model-invocation`、`user-invocable`、`allowed-tools`、`context`、`agent`、`hooks`（Claude 扩展）；`license`、`compatibility`、`metadata`（开放标准）。

- **目录结构**
  - 最少：`skill-name/SKILL.md`。
  - 推荐：`reference.md`、`examples.md`、`scripts/`（Claude/Cursor）；规范可选 `references/`、`assets/`。

- **内容策略**
  - 主文件 < 500 行；渐进式披露（先 name/description，再 SKILL 正文，再按需引用文件）。
  - 引用仅一层深度，避免深层嵌套。

- **写作模式**
  - Template、Examples、Workflow、Conditional Workflow、Feedback Loop（来自 Cursor create-skill）。
  - 参考型 vs 任务型内容；任务型可配合 `disable-model-invocation: true`、`context: fork`（Claude 文档）。

- **多 IDE 与发布**
  - Claude Code：`.claude/skills/` 或 `~/.claude/skills/`；Plugin 为 `skills/`。
  - Cursor：`.cursor/skills/` 或 `~/.cursor/skills/`（勿用 `~/.cursor/skills-cursor/`）。
  - 安装：`npx add-skill owner/repo`、`npx add-skill owner/repo --skill name`、`npx openskills install owner/repo`；仓库需包含 skills 目录或根目录即 skill。

---

## 三、与「更好 Skill」的差异化设计

为使本 Skill 能生成**优于** Claude Code 文档 + Cursor create-skill 的 Skills，计划在内容中明确：

1. **统一规范与扩展**：同时满足 agentskills.io 最低要求与 Claude Code 扩展字段，并说明 Cursor 兼容性（description 长度等）。
2. **可执行检查清单**：提供「发布前校验」步骤（如 name 与目录一致、description 含 WHEN/WHAT、无 Windows 路径、引用一层深度）。
3. **安装与分发**：明确 GitHub 仓库应具备的结构（如 `skills/ClaudeSkillsCreateSkills/` 或根目录即单 skill），以及 add-skill/openskills 的推荐命令。
4. **中英双语触发**：description 与说明中覆盖「创建 skill、写 SKILL、Claude Skills、Agent Skills」等中英文场景，便于多环境发现。
5. **模板与片段**：在 Skill 内或 `references/` 提供最小可用的 frontmatter 与章节模板，减少遗漏。

---

## 四、仓库与 Skill 包结构设计

建议在**当前工作区**内建立如下结构（执行阶段实现）：

```
ClaudeSkillsCreateSkills/           # 仓库根或 skills 子目录
├── README.md                       # 仓库说明、安装命令、与 Agent Skills 标准说明
├── LICENSE                         # 建议 MIT 或 Apache-2.0
├── PLAN_ClaudeSkillsCreateSkills.md # 本计划 MD（执行时写入当前目录）
└── ClaudeSkillsCreateSkills/       # 若仓库为多 skill 则放此目录；若单 skill 则与根同级
    ├── SKILL.md                    # 主 Skill：框架+组件+实战+发布
    ├── reference.md                # 可选：frontmatter 与规范速查
    ├── examples.md                 # 可选：2–3 个完整 Skill 示例
    └── scripts/                   # 可选：校验脚本（如检查 name/目录一致、description 长度）
        └── validate-skill.sh
```

- **单 skill 发布**：仓库可仅为 `ClaudeSkillsCreateSkills/` 下含 `SKILL.md` 的单个目录，add-skill 支持从仓库根安装。
- **多 skill 仓库**：若将来扩展，可改为 `skills/ClaudeSkillsCreateSkills/`，并在 README 中说明 `npx add-skill owner/repo --skill ClaudeSkillsCreateSkills`。

---

## 五、SKILL.md 内容大纲（将写入 ClaudeSkillsCreateSkills/SKILL.md）

1. **Frontmatter**
   - `name: claude-skills-create-skills`（与目录名一致，kebab-case）
   - `description`：中英触发词，说明「指导创建符合 Agent Skills 标准且适用于 Claude Code / Cursor 的 Skills，并在何时使用本 Skill」。

2. **正文结构**
   - 何时使用本 Skill（触发场景）。
   - 构建框架总览（可引用上文的 mermaid 或文字版）。
   - 组件清单：元数据、目录、内容策略、写作模式、调用与发布（对应第二节萃取）。
   - 写作原则：简洁、渐进式披露、自由度、<500 行（对齐 Cursor create-skill）。
   - 模式与反模式：Template/Examples/Workflow/条件/反馈循环；Windows 路径、过多选项、时间敏感、术语不一致、模糊 name。
   - 发布与安装：GitHub 结构、add-skill/openskills 命令、Claude Code vs Cursor 路径。
   - 发布前校验清单（可执行）。
   - 引用 `reference.md`、`examples.md`（若存在）。

3. **兼容性**
   - 遵守 Agent Skills 规范，并标注 Claude Code 与 Cursor 的扩展/差异（如 `disable-model-invocation`、`context: fork` 仅部分环境支持）。

---

## 六、可安装性与完整性保障

- **完整性**：SKILL.md 覆盖「规范 + 指南 + 实战 + 发布」全链路；可选 reference/examples/scripts 不阻塞基本使用。
- **可调用性**：description 明确、含触发词；支持 `/claude-skills-create-skills` 或自动匹配「创建 skill、写 SKILL」等表述。
- **OpenSkills / add-skill**：README 中写明安装命令（如 `npx add-skill <owner>/<repo>` 或 `npx openskills install <owner>/<repo>`），并注明 Cursor 目标路径为 `.cursor/skills/` 或 `~/.cursor/skills/`。
- **稳定性**：不依赖时效性表述；规范与路径以官方文档与 agentskills.io 为据，并在 reference 中注明来源与版本/日期。

---

## 七、执行顺序与产出

1. **在当前目录创建 `PLAN_ClaudeSkillsCreateSkills.md`**  
   将本计划全文以 Markdown 写入，便于存档与对照。

2. **创建 `ClaudeSkillsCreateSkills/` 目录及 `SKILL.md`**  
   按第五节大纲写入主 Skill，融合第二节框架与第三节差异化设计。

3. **（可选）添加 `reference.md`**  
   frontmatter 与规范速查表、各 IDE 路径与安装命令。

4. **（可选）添加 `examples.md`**  
   2–3 个精简但完整的 Skill 示例（含 frontmatter + 简短正文）。

5. **（可选）添加 `scripts/validate-skill.sh`**  
   校验目录名与 name、description 长度、是否存在 SKILL.md。

6. **编写仓库级 `README.md` 与 `LICENSE`**  
   说明用途、安装方式（add-skill / openskills）、目录结构、与 Agent Skills 标准的关系。

7. **（若需发布）初始化 git、提交、推送到 GitHub**  
   确保仓库结构满足 add-skill/openskills 的预期（可先本地用 `npx add-skill .` 或指向本地路径做安装测试）。

---

## 八、风险与假设

- **假设**：用户接受「单 skill 仓库」或「多 skill 仓库中一个子目录」两种之一；当前计划按单 skill 可发布设计，后续可改为 `skills/` 下多子目录。
- **风险**：OpenSkills 与 add-skill 的默认路径可能随版本变化（如 `.agent/skills` vs `.cursor/skills`）；计划与 README 中同时写明 Cursor 与 Claude Code 的路径，减少歧义。
- **依赖**：不依赖私有或需登录的文档；所有引用均为公开的 Claude 文档、agentskills.io、anthropics/skills、add-skill.org。

---

## 九、计划文档落盘

执行阶段将把**本计划全文**以 Markdown 格式保存到当前目录，建议文件名：**`PLAN_ClaudeSkillsCreateSkills.md`**。若需与仓库一起版本化管理，可将其置于仓库根目录并纳入 git。
