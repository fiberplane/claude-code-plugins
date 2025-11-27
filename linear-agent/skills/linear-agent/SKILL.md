---
name: linear-agent
description: Orchestrates long-running agent development with Linear as single source of truth. Activates on session start when .claude-linear-agent.json exists, or when user provides a Linear project/issue URL. Breaks down briefs into issues, scaffolds all features, then implements one per session.
---

# Linear Long-Running Agent Workflow

Implements Anthropic's "effective harnesses for long-running agents" pattern using Linear as the project management backend.

## Prerequisites

- Linear MCP server must be configured and authenticated
- User provides a Linear project URL or parent issue URL to begin

## Parsing Linear URLs

When user provides a Linear URL, extract identifiers correctly to avoid failed API calls:

**Project URLs:**
- Format: `https://linear.app/{workspace}/project/{name}-{uuid}/...`
- Example: `https://linear.app/fiberplane/project/local-ai-gateway-f7279645c602/overview`
- The `{name}-{uuid}` part (e.g., `local-ai-gateway-f7279645c602`) is the project **slug**
- Use `list_projects` with `query` parameter to search by name, NOT `get_project` with the slug
- The slug alone won't work with `get_project` - you need the full UUID

**Issue URLs:**
- Format: `https://linear.app/{workspace}/issue/{team}-{number}/...`
- Example: `https://linear.app/fiberplane/issue/FIB-123/implement-auth`
- Extract `{team}-{number}` (e.g., `FIB-123`) as the issue identifier
- Use `get_issue` with this identifier directly

**Efficient lookup pattern for projects:**
1. Extract the human-readable name from URL (e.g., "local-ai-gateway" from slug)
2. Call `list_projects(query: "local ai gateway")` to find by name
3. Use the returned UUID for subsequent calls like `list_issues(project: uuid)`

## Workflow Overview

**Three phases:**
1. **Planning** - Break down project brief into Linear issues (if needed)
2. **Initialization** - Scaffold ALL features upfront (runs once)
3. **Coding Agent** - Implement ONE feature per session (repeats)

---

## Phase 0: Planning (if no issues exist)

Triggered when:
- `phase: "planning"` in state file, OR
- Project/issue has description but NO child issues

### Steps

1. **Gather user preferences**
   Ask the user about:
   - **Tech stack**: Language, framework, libraries
   - **Architecture**: Monolith vs microservices, patterns (MVC, hexagonal, etc.)
   - **Testing**: Unit tests, integration tests, E2E, preferred frameworks
   - **Code style**: Linting, formatting, conventions
   - **Deployment**: Target environment, CI/CD preferences
   - **Any constraints**: Performance requirements, compatibility needs

2. **Analyze the brief**
   - Read project/issue description thoroughly
   - Identify distinct features and components
   - Note any dependencies or ordering requirements
   - Consider user's stated preferences

3. **Propose feature breakdown**
   - Present list of proposed issues to user
   - Each issue should be:
     - Atomic (one clear deliverable)
     - Testable (clear acceptance criteria)
     - Appropriately scoped (implementable in one session)
   - Include priority/order suggestions
   - Wait for user approval or adjustments

4. **Create issues in Linear**
   - Create each approved issue in Linear
   - Set appropriate priorities
   - Add descriptions with acceptance criteria
   - Link dependencies between issues

5. **Store preferences in Linear**
   - Update project description OR create a pinned "Technical Specifications" issue
   - Include all agreed preferences:
     ```markdown
     ## Technical Specifications
     - **Language**: TypeScript
     - **Framework**: Next.js
     - **Testing**: vitest
     - **Architecture**: feature-based modules
     - **Notes**: Prefer functional style, minimize dependencies
     ```
   - This keeps Linear as the single source of truth

6. **Transition to scaffolding phase**
   - Update `.claude-linear-agent.json`: set `phase: "scaffolding"`

---

## Phase 1: Scaffolding

Triggered when:
- `phase: "scaffolding"` in state file, OR
- Issues exist in project but no scaffold commit yet

### Steps

1. **Verify Linear MCP authentication**
   - Attempt to list issues using Linear MCP
   - If auth fails, inform user to configure Linear MCP

2. **Check for existing issues**
   - Fetch issues from project/parent
   - If NO issues exist → run Phase 0 first
   - If issues exist → continue

3. **Load preferences from Linear**
   - Check project description for "Technical Specifications" section
   - Or look for pinned "Technical Specifications" issue
   - If not found, ask user and store in Linear (see Phase 0, step 5)

4. **Plan architecture for all features**
   - Read all issue titles and descriptions
   - Consider user's stated preferences
   - Identify dependencies between features
   - Design architecture that accommodates ALL features upfront
   - This prevents conflicts from incremental building

5. **Present architecture plan to user**
   - Show proposed directory structure
   - Explain key architectural decisions
   - Get user approval before proceeding

6. **Create scaffold for ALL features**
   - Test stubs (failing tests defining expected behavior)
   - Interfaces and types
   - Directory structure per approved plan
   - Integration points between features
   - DO NOT implement functionality yet

7. **Commit scaffold**
   - Create commit with descriptive message
   - Message should reference the Linear project/issue

8. **Transition to coding phase**
   - Update `.claude-linear-agent.json`: set `phase: "coding"`

---

## Phase 2: Coding

Triggered when:
- `phase: "coding"` in state file
- Activates automatically at session start (no user action needed)

### Steps

1. **Verify Linear MCP authentication**
   - Fail fast if not authenticated

2. **Read local state and Linear preferences**
   - Load `.claude-linear-agent.json` for project/issue ID
   - Fetch "Technical Specifications" from Linear (project description or pinned issue)

3. **Fetch current issue status from Linear**
   - Get all issues for the project/parent
   - Linear issue status = feature status (no duplicate tracking)
   - Check for any comments with context from previous sessions

4. **Check git history**
   - Review recent commits for context
   - Understand what was done in previous sessions

5. **Select next issue**
   - Pick highest-priority non-done issue
   - Present selection to user for confirmation
   - User may override selection

6. **Implement feature**
   - Follow preferences from state file (tech stack, patterns)
   - Run tests BEFORE starting (establish baseline)
   - Implement against existing scaffold
   - Maintain mergeable codebase at all times
   - Run tests AFTER changes
   - Tests that were stubs should now pass

7. **On completion**
   - Commit with issue ID in message (e.g., "ABC-123: Implement user auth")
   - Add progress comment to Linear issue:
     - What was implemented
     - Test status
     - Any blockers or notes for next session
   - Update issue status (→ In Review, Done, etc.)

---

## State File Format

`.claude-linear-agent.json` in project root (minimal - just tracks what Linear entity we're working with):

```json
{
  "type": "project",
  "linearId": "ABC-123",
  "phase": "coding"
}
```

- `type`: "project" or "issue" (parent with children)
- `linearId`: Linear project ID or parent issue ID
- `phase`: Current workflow phase
  - `"planning"` - Breaking down brief into issues
  - `"scaffolding"` - Creating test stubs, types, structure
  - `"coding"` - Implementing features one at a time

**Note**: Technical preferences live in Linear (project description or pinned issue), not in this file.

---

## Key Principles

1. **Ask before assuming** - Gather user preferences for tech stack and architecture
2. **Linear IS the feature list** - No duplicate tracking
3. **Scaffold ALL features first** - Prevents architectural conflicts
4. **One feature per session** - Maintain focus and clean commits
5. **Always leave codebase mergeable** - No broken states
6. **Progress lives in Linear** - Comments provide session continuity
