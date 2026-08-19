---
created: 2026-08-15
tags: [AgentSkill, AI能力, 自动化, 最佳实践]
type: tutorial
source: web-search-yuanbao
---
# Agent Skill 完全指南：从原理到实践

> 采集时间：2026-08-15
> 核心价值：一次编写，全网通用，将经验沉淀为可复用的 AI 能力

---

## 一、Agent Skill 是什么？

### 1.1 核心定义

**一句话定义**：
> **Skill = 可插拔的专业能力模块**

**本质**：
- 大模型可随时翻阅的"说明书"
- 沉淀了自然语言描述 SOP 的 Markdown 文件
- 将"怎么做"的知识，从 Prompt 中剥离出来，变成了 AI 的"肌肉记忆"

**形象比喻**：
- 如果把大模型比作"大脑"
- 工具比作"手"
- 那么 Skill 就是"**肌肉记忆 + 操作规程 + 安全带**"

### 1.2 为什么需要 Skill？

**传统问题**：
1. **重复提示词**：每次都要写又臭又长的提示词
2. **上下文浪费**：每次对话都要占用大量 tokens
3. **无法复用**：经验无法沉淀，每次从零开始
4. **标准不一**：不同人用 AI 的效果差异大

**Skill 的解决方案**：
1. **一次编写，多次使用**：不用每次重复提示词
2. **按需加载**：只在需要时才加载，节省 tokens
3. **经验沉淀**：将最佳实践固化，可复用
4. **统一标准**：团队共享 Skill，保证一致性

### 1.3 Skill vs Prompt vs MCP

| 维度 | Skill | Prompt | MCP |
|------|--------|--------|-----|
| **本质** | 标准化的能力封装 | 一次性指令 | 工具调用协议 |
| **复用性** | ✅ 可复用 | ❌ 每次重写 | ✅ 可复用 |
| **脚本执行** | ✅ 支持 | ❌ 不支持 | ✅ 支持 |
| **按需加载** | ✅ 渐进式加载 | ❌ 每次全量 | ❌ 全量 |
| **模块化** | ✅ 可组合 | ❌ 单文件 | ✅ 可组合 |
| **定位** | 上层逻辑（指挥官） | 单次指令 | 底层协议（工具） |

**关系**：
- MCP 是底层协议，定义了 AI 如何调用外部工具
- Skill 是上层逻辑，定义了 AI 在特定场景下如何使用 MCP 工具
- Prompt 是单次指令，Skill 包含多个 Prompt

---

## 二、Skill 的工作原理

### 2.1 渐进式披露（核心机制）

**三层加载**：

| 层级 | 加载时机 | 加载内容 | Token 消耗 |
|------|----------|----------|-----------|
| **Layer 1** | Agent 启动时 | 所有 Skill 的元数据（name + description） | 约 100 tokens |
| **Layer 2** | Skill 被激活时 | SKILL.md 的正文内容 | 数百到数千 tokens |
| **Layer 3** | 需要资源时 | scripts、references、assets 等资源文件 | 数千到数万 tokens |

**优势**：
- 极大节省 Context Window（上下文窗口）
- 允许挂载大量 Skill 而不造成溢出
- 按需加载，避免浪费

### 2.2 自动激活机制

**触发流程**：
1. Agent 启动时，加载所有 Skill 的元数据（name + description）
2. 用户发起请求
3. Agent 判断任务是否与某个 Skill 相关
4. 如果相关，自动激活该 Skill
5. 加载 SKILL.md 的详细指令
6. 按需加载资源文件
7. 执行任务

**关键点**：
- Skill 的 description 非常重要（决定了何时被激活）
- 不会被手动激活，由 AI 自动判断

---

## 三、Skill 的标准结构

### 3.1 目录结构

```
my-skill/                    # Skill 根目录（命名应清晰反映技能用途）
├── SKILL.md                 # 必需：技能元数据和流程说明
├── scripts/                 # 可选：可执行脚本、工具函数
│   ├── script1.py
│   └── script2.sh
├── references/              # 可选：参考文档、规范、标准
│   ├── api-doc.md
│   └── coding-standard.md
└── assets/                  # 可选：模板、配置文件、示例数据
    ├── template.md
    └── example.json
```

**核心文件**：
- **SKILL.md**：必须包含，定义技能的元数据和详细指令
- 其他文件夹和文件都是可选的

### 3.2 SKILL.md 规范

**基本结构**：
```markdown
---
name: skill-name
description: 简短描述（用于触发激活）
---

# Skill 名称

## When to use this skill

描述在什么场景下使用这个 skill

## How to use

详细的操作步骤和判断逻辑

## Examples

实际案例和示例

## Notes

注意事项和最佳实践
```

**YAML Frontmatter 字段**：
- `name`：技能名称（必需）
- `description`：简短描述（必需，用于触发激活）
- `version`：版本号（可选）
- `author`：作者（可选）
- `tags`：标签（可选）

### 3.3 SKILL.md 最佳实践

**标题层级**：
- `# Skill 名称`：总标题
- `## When to use`：触发条件
- `## How to use`：操作步骤
- `## Examples`：实际案例
- `## Notes`：注意事项

**内容要求**：
- **清晰明确**：避免模糊表述
- **结构化**：使用列表、表格、代码块
- **可执行**：步骤要有明确的输入输出
- **可验证**：提供测试案例

**长度建议**：
- 元数据（name + description）：不超过 100 tokens
- SKILL.md 正文：数百到数千 tokens（放心写，按需加载）
- scripts + references：数千到数万 tokens（放在文件夹里，进一步延后加载）

---

## 四、5 分钟创建第一个 Skill

### 4.1 创建 Skill 目录

**以 OpenClaw 为例**：
```bash
mkdir -p ~/.openclaw/workspace/skills/hello-world
```

**Claude Code 等价命令**：
```bash
mkdir -p ~/.claude/skills/hello-world
```

**Hermes Agent 等价命令**：
```bash
mkdir -p ~/.hermes/skills/hello-world
```

### 4.2 编写 SKILL.md

**创建文件**：
```bash
cd ~/.openclaw/workspace/skills/hello-world
touch SKILL.md
```

**编写内容**：
```markdown
---
name: hello-world
description: A simple skill that greets the user in a friendly way
---

# Hello World Skill

## When to use this skill

Use this skill when the user asks for a greeting or says hello.

## How to use

1. Check the user's name (if available)
2. Generate a friendly greeting message
3. Include a motivational quote or fun fact

## Examples

**Input**: "Hi there"
**Output**: "Hello! Great to see you! Remember: every expert was once a beginner. 🚀"

**Input**: "Hello"
**Output**: "Hey! Welcome back! Fun fact: Honey never spoils. 🍯"

## Notes

- Keep the greeting friendly and positive
- Adapt the tone based on the user's mood (if detectable)
```

### 4.3 测试 Skill

**重启 Agent**（让新 Skill 被识别）

**测试对话**：
```
你：Hi there

AI：（自动激活 hello-world Skill）
Hello! Great to see you! Remember: every expert was once a beginner. 🚀
```

---

## 五、实战案例：代码审查 Skill

### 5.1 需求分析

**场景**：团队协作时，需要统一代码审查标准

**目标**：
- 自动检测代码风格问题
- 检查安全漏洞
- 提供改进建议
- 生成审查报告

### 5.2 创建 Skill 目录

```bash
mkdir -p ~/.openclaw/workspace/skills/code-review
cd ~/.openclaw/workspace/skills/code-review
```

### 5.3 编写 SKILL.md

```markdown
---
name: code-review
description: Professional code review skill that analyzes code quality, security, and performance
---

# Code Review Skill

## When to use this skill

Use this skill when:
- User asks for code review
- User submits code for review
- User wants to check code quality
- User mentions "review my code" or "check this code"

## How to use

### Step 1: Analyze Code Structure
- Check file organization
- Verify naming conventions
- Evaluate module structure

### Step 2: Check Code Quality
- Detect code smells
- Measure complexity
- Identify duplicate code
- Check test coverage

### Step 3: Security Analysis
- Scan for common vulnerabilities (SQL injection, XSS, etc.)
- Check sensitive data handling
- Verify authentication and authorization

### Step 4: Performance Review
- Identify performance bottlenecks
- Check memory leaks
- Evaluate algorithm efficiency

### Step 5: Generate Report
Create a structured review report with:
- **Summary**: Overall assessment (1-10 score)
- **Critical Issues**: Must fix before merge
- **Warnings**: Should fix but not blocking
- **Suggestions**: Nice to have improvements
- **Positive Points**: Good practices found

## Examples

### Example 1: Python Code Review

**Input**:
```python
def calc(x,y):
    return x+y
```

**Output**:
```
# Code Review Report

## Summary
Score: 6/10
Basic functionality works, but needs improvements in documentation and error handling.

## Critical Issues
- None

## Warnings
- Missing function documentation (docstring)
- No input validation
- No type hints

## Suggestions
- Use descriptive function name: `add_numbers` instead of `calc`
- Add docstring: """Add two numbers and return the result."""
- Add type hints: `def add_numbers(x: float, y: float) -> float:`

## Positive Points
- Simple and clear logic
- Returns correct result
```

## Notes

- Always be constructive in feedback
- Prioritize issues by severity
- Provide code examples for suggestions
- Reference best practices and documentation
```

### 5.4 添加参考资料

**创建 coding-standards.md**：
```markdown
# Python Coding Standards

## Naming Conventions
- Use snake_case for function and variable names
- Use PascalCase for class names
- Use UPPER_CASE for constants

## Documentation
- All public functions must have docstrings
- Use Google-style docstrings

## Error Handling
- Always use specific exception types
- Never use bare `except:`

## Type Hints
- Required for all public functions
- Use `Optional` for nullable parameters
```

**创建 security-checklist.md**：
```markdown
# Security Checklist

## Input Validation
- Validate all user inputs
- Use parameterized queries for database operations

## Sensitive Data
- Never hardcode passwords or API keys
- Use environment variables for secrets

## Authentication
- Use strong password hashing (bcrypt, argon2)
- Implement rate limiting for login attempts
```

### 5.5 测试 Skill

**测试对话**：
```
你：请帮我审查这段代码
```python
def get_user(id):
    query = f"SELECT * FROM users WHERE id = {id}"
    return db.execute(query)
```

AI：（自动激活 code-review Skill）
# Code Review Report

## Summary
Score: 3/10
CRITICAL SECURITY ISSUE detected!

## Critical Issues
- **SQL Injection Vulnerability**: Using string formatting in SQL query allows attackers to execute arbitrary SQL commands.

## How to Fix
```python
def get_user(user_id: int) -> User:
    """Fetch user by ID safely."""
    query = "SELECT * FROM users WHERE id = ?"
    return db.execute(query, (user_id,))
```

## Warnings
- Missing docstring
- No type hints
- No error handling

## Suggestions
- Add try-except block for database errors
- Return None if user not found

## Positive Points
- Function name is clear
```

---

## 六、高级技巧

### 6.1 脚本执行

**场景**：Skill 需要执行复杂计算或调用外部 API

**创建脚本**：
```python
# scripts/calculate_metrics.py
import json
import sys

def calculate_complexity(code):
    # 实际的复杂度计算逻辑
    lines = code.strip().split('\n')
    return len(lines) * 2

if __name__ == "__main__":
    code = sys.argv[1]
    result = calculate_complexity(code)
    print(json.dumps({"complexity": result}))
```

**在 SKILL.md 中使用**：
```markdown
## How to use

### Step 2: Calculate Complexity
Run the complexity calculation script:
```bash
python scripts/calculate_metrics.py "{code}"
```

Use the result in your analysis.
```

### 6.2 模板系统

**场景**：Skill 需要生成特定格式的输出

**创建模板**：
```markdown
# assets/report-template.md

# {title}

**Date**: {date}
**Author**: {author}

## Summary
{summary}

## Issues Found
{issues}

## Recommendations
{recommendations}
```

**在 SKILL.md 中使用**：
```markdown
## How to use

### Step 5: Generate Report
Use the report template from `assets/report-template.md`:

1. Fill in the placeholders:
   - {title}: Code Review Report
   - {date}: Current date
   - {author}: AI Assistant
   - {summary}: Overall assessment
   - {issues}: List of issues
   - {recommendations}: Improvement suggestions

2. Format the final report in Markdown
```

### 6.3 多 Skill 组合

**场景**：复杂任务需要多个 Skill 协同

**创建主 Skill**：
```markdown
---
name: full-project-review
description: Complete project review including code, documentation, and tests
---

# Full Project Review

## When to use this skill

Use this skill when user requests a comprehensive project review.

## How to use

### Step 1: Code Review
Activate [[code-review]] skill to analyze code quality.

### Step 2: Documentation Review
Activate [[doc-review]] skill to check documentation completeness.

### Step 3: Test Coverage
Activate [[test-coverage]] skill to evaluate test coverage.

### Step 4: Generate Comprehensive Report
Combine results from all three skills into a final report.
```

**效果**：主 Skill 可以调用其他 Skill，形成能力组合

---

## 七、Skill 开发最佳实践

### 7.1 设计原则

1. **单一职责**：每个 Skill 只做一件事
2. **清晰触发**：description 要准确描述使用场景
3. **结构化指令**：使用列表、表格、代码块
4. **可验证**：提供测试案例
5. **可扩展**：预留扩展空间

### 7.2 文件组织

**推荐结构**：
```
my-skill/
├── SKILL.md              # 核心指令（必需）
├── scripts/              # 可执行脚本（可选）
│   ├── main.py          # 主脚本
│   └── utils.py         # 工具函数
├── references/           # 参考资料（可选）
│   ├── api-doc.md       # API 文档
│   └── best-practices.md # 最佳实践
├── assets/               # 资源文件（可选）
│   ├── template.md      # 输出模板
│   └── config.json      # 配置文件
└── examples/             # 示例（可选）
    ├── example1.md
    └── example2.md
```

### 7.3 SKILL.md 写作技巧

**触发条件要具体**：
```markdown
## When to use this skill

Use this skill when:
- User explicitly asks for "code review"
- User submits code with "please review" or "check this"
- User mentions "PR review" or "pull request review"
```

**操作步骤要可执行**：
```markdown
## How to use

### Step 1: Analyze Code Structure
1. Count the number of files
2. Check file organization (src/, tests/, docs/)
3. Verify naming conventions
```

**提供示例**：
```markdown
## Examples

### Example 1: Simple Function Review

**Input**:
```python
def add(a, b):
    return a + b
```

**Output**:
[详细输出]
```

### 7.4 测试与调试

**测试步骤**：
1. 创建 Skill 后重启 Agent
2. 发送触发词测试是否激活
3. 检查输出是否符合预期
4. 迭代优化 SKILL.md

**调试技巧**：
- 在 SKILL.md 中添加 `DEBUG: true` 开启调试模式
- 在 SKILL.md 中打印中间结果
- 使用 `/skill-info` 命令查看 Skill 加载状态

---

## 八、Skill 生态系统

### 8.1 Skills Hub

**官方技能市场**：https://skills.sh

**功能**：
- 发现和安装社区 Skill
- 分享你的 Skill
- 查看热门 Skill

**安装 Skill**：
```bash
npx skills add owner/repo@skill-name
```

**示例**：
```bash
npx skills add nousresearch/hermes-agent@code-review
```

### 8.2 官方推荐 Skill

**热门 Skill**：
- `hermes-agent`：通用 Agent 技能包（551 安装）
- `powerpoint`：PPT 生成技能（485 安装）
- `google-workspace`：Google 工作空间集成（432 安装）
- `arxiv`：论文检索和分析（431 安装）
- `claude-design`：设计辅助技能（401 安装）

### 8.3 创建自己的 Skill 库

**推荐目录结构**：
```
~/.openclaw/workspace/skills/
├── code-review/
│   └── SKILL.md
├── api-testing/
│   └── SKILL.md
├── documentation/
│   └── SKILL.md
└── project-management/
    └── SKILL.md
```

**管理 Skill**：
- 使用 Git 版本控制
- 定期更新和优化
- 分享到 Skills Hub

---

## 九、常见问题

### 9.1 Skill 没有被激活

**原因**：
- description 不够准确
- 触发词不匹配
- Agent 未重启

**解决**：
1. 优化 description，更准确描述使用场景
2. 使用明确的触发词测试
3. 重启 Agent 让新 Skill 生效

### 9.2 Skill 输出不符合预期

**原因**：
- 指令不够清晰
- 示例不够完整
- 缺少约束条件

**解决**：
1. 细化操作步骤，增加判断逻辑
2. 提供更完整的示例
3. 添加"不要做什么"的约束

### 9.3 Skill 占用过多 tokens

**原因**：
- SKILL.md 过长
- 加载了不必要的资源文件

**解决**：
1. 精简 SKILL.md，只保留核心指令
2. 将详细内容放到 references/ 文件夹
3. 使用渐进式加载机制

---

## 十、总结与行动清单

### 10.1 核心要点

1. **Skill 是可插拔的能力模块**：将经验沉淀为可复用的 AI 能力
2. **渐进式加载**：按需加载，节省 tokens
3. **一次编写，全网通用**：支持 Claude Code、OpenClaw、Hermes 等多个平台
4. **结构化 + 可执行**：指令要清晰、可验证

### 10.2 行动清单

**本周可做**：
- [ ] 创建第一个 Skill（hello-world）
- [ ] 测试 Skill 激活机制
- [ ] 编写一个实用的 Skill（如代码审查）

**本月可做**：
- [ ] 建立个人 Skill 库（至少 5 个 Skill）
- [ ] 学习社区 Skill，借鉴最佳实践
- [ ] 分享一个 Skill 到 Skills Hub

**长期修炼**：
- [ ] 持续优化 Skill 指令
- [ ] 建立团队 Skill 规范
- [ ] 构建 Skill 生态系统

---

## 十一、延伸阅读

### 11.1 官方资源

- Skills Hub：https://skills.sh
- Claude Code 文档：https://docs.anthropic.com/claude-code
- OpenClaw 文档：https://docs.openclaw.ai

### 11.2 推荐教程

- 《Agent Skills 完全教程》- CSDN
- 《从零开发 AI Agent Skill：构建可复用技能包的完整指南》- CSDN
- 《Agent Skills 傻瓜式教程》- 博客园

### 11.3 社区资源

- Claude Code 社区：https://forum.claude.ai
- OpenClaw 社区：https://community.openclaw.ai

---

**标签**：#AgentSkill #AI能力 #自动化 #最佳实践
**类型**：tutorial
