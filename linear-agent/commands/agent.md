# Linear Agent Workflow

Continue or start the Linear agent workflow.

## Instructions

1. **Check for state file** (`.claude-linear-agent.json` in project root)
   - If exists: read `phase` and `linearId`, continue from current phase
   - If not exists: ask user for a Linear project or issue URL to begin

2. **Invoke the linear-agent skill** to execute the appropriate phase:
   - `planning` → Break down brief into Linear issues
   - `scaffolding` → Create test stubs, types, directory structure for all features
   - `coding` → Fetch issues, select next task, implement one feature

3. **If no state file and no URL provided**, prompt the user:
   > "To start a Linear agent workflow, paste a Linear project or issue URL."

Always use the linear-agent skill for the actual workflow execution.
