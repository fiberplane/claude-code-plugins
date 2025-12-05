# Common Planning Patterns

Reusable patterns for structuring work in FP.

## Pattern: Foundation → Implementation → Integration

```bash
# Step 1: Foundation
fp issue create --title "Data models" --parent FP-1

# Step 2: Core logic (depends on foundation)
fp issue create --title "Business logic" --parent FP-1 --depends "FP-2"

# Step 3: API/Interface (depends on business logic)
fp issue create --title "API endpoints" --parent FP-1 --depends "FP-3"

# Step 4: UI (depends on API)
fp issue create --title "UI components" --parent FP-1 --depends "FP-4"
```

## Pattern: Vertical Slices

For full-stack features, consider vertical slices:

```bash
# Slice 1: User registration (full stack)
fp issue create --title "User registration flow" --parent FP-1

# Slice 2: User login (full stack)
fp issue create --title "User login flow" --parent FP-1 --depends "FP-2"

# Slice 3: User profile (full stack)
fp issue create --title "User profile page" --parent FP-1 --depends "FP-3"
```

Each slice goes from database → backend → frontend.

## Pattern: Parallel Tracks

For work that can happen concurrently:

```bash
# Track 1: Backend
fp issue create --title "API implementation" --parent FP-1

# Track 2: Frontend (can start in parallel)
fp issue create --title "UI mockups and components" --parent FP-1

# Track 3: Integration (needs both)
fp issue create --title "Wire up frontend to API" --parent FP-1 --depends "FP-2,FP-3"
```

## Pattern: Research → Implementation

For unclear requirements:

```bash
# Phase 1: Spike/Research
fp issue create \
  --title "Research OAuth providers" \
  --parent FP-1 \
  --description "Compare GitHub, Google, and Auth0. Recommend one. Expected: 2-3 hours, decision document."

# Phase 2: Implementation (waits for research)
fp issue create \
  --title "Implement chosen OAuth provider" \
  --parent FP-1 \
  --depends "FP-2" \
  --description "Implement the OAuth provider selected in FP-2"
```

## Pattern: Incremental Feature Flags

For gradual rollout:

```bash
# Phase 1: Backend with feature flag
fp issue create \
  --title "Backend logic (behind feature flag)" \
  --parent FP-1

# Phase 2: Testing with flag enabled
fp issue create \
  --title "Internal testing" \
  --parent FP-1 \
  --depends "FP-2"

# Phase 3: UI (still flagged)
fp issue create \
  --title "UI components (feature-flagged)" \
  --parent FP-1 \
  --depends "FP-3"

# Phase 4: Full release
fp issue create \
  --title "Remove feature flag and release" \
  --parent FP-1 \
  --depends "FP-4"
```
