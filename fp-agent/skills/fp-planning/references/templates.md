# Plan Templates

Ready-to-use templates for common planning scenarios.

## Template: Full-Stack Feature

```bash
# 1. Plan issue
fp issue create --title "[Feature Name]" --description "[Goals, approach, success criteria]"

# 2. Data models
fp issue create --title "Data models and schema" --parent FP-X

# 3. Backend API
fp issue create --title "Backend API endpoints" --parent FP-X --depends "FP-Y"

# 4. Frontend UI
fp issue create --title "UI components" --parent FP-X --depends "FP-Y"

# 5. Integration
fp issue create --title "Frontend-backend integration" --parent FP-X --depends "FP-Z,FP-A"

# 6. Testing
fp issue create --title "Tests and documentation" --parent FP-X --depends "FP-B"
```

## Template: Bug Fix

```bash
# 1. Investigation
fp issue create --title "Investigate [bug description]" --description "Reproduce, identify root cause, propose fix"

# 2. Fix implementation
fp issue create --title "Fix [bug]" --depends "FP-Y"

# 3. Regression test
fp issue create --title "Add regression test for [bug]" --depends "FP-Z"
```

## Template: Refactoring

```bash
# 1. Plan
fp issue create --title "Refactor [component]" --description "Goals: [why], Scope: [what]"

# 2. Extract/reorganize
fp issue create --title "Extract shared logic" --parent FP-X

# 3. Update call sites
fp issue create --title "Update all call sites" --parent FP-X --depends "FP-Y"

# 4. Remove old code
fp issue create --title "Remove deprecated code" --parent FP-X --depends "FP-Z"

# 5. Update tests
fp issue create --title "Update tests for new structure" --parent FP-X --depends "FP-A"
```

## Template: Performance Optimization

```bash
# 1. Baseline
fp issue create --title "Establish performance baseline" --parent FP-X

# 2. Identify bottlenecks
fp issue create --title "Profile and identify bottlenecks" --parent FP-X --depends "FP-Y"

# 3. Optimize
fp issue create --title "Optimize [specific area]" --parent FP-X --depends "FP-Z"

# 4. Verify improvement
fp issue create --title "Measure performance improvement" --parent FP-X --depends "FP-A"
```
