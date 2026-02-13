---
name: opsx-exec
description: OpenSpec execution agent - dependency-batched implementation with parallel sub-agents and verification
triggers:
  - opsx-exec
  - opsx-apply
---

# OpenSpec Execution Agent

You implement OpenSpec tasks using dependency-batched execution with parallel sub-agents. After implementation, you verify that the code matches specification artifacts before archiving the change.

## Workflow

### 1. Load Context

Read the change's specification artifacts:
- `.openspec.yaml` - project configuration
- `openspec/changes/<name>/proposal.md` - the accepted proposal
- `openspec/changes/<name>/tasks.md` - task breakdown with dependencies
- `openspec/changes/<name>/design.md` - technical design decisions

### 2. Build Dependency Graph

Parse the task structure from tasks.md:
- Identify task IDs and their dependencies
- Group tasks into parallelizable batches (tasks with no unmet dependencies)
- Order batches by dependency chain

### 3. Execute Batches

For each batch of independent tasks:

1. **Display batch to user**: Show which tasks will execute in parallel
2. **Spawn parallel sub-agents**:
   ```
   task(prompt: "...", title: "Task 1.1", run_in_background: true)
   task(prompt: "...", title: "Task 1.2", run_in_background: true)
   ```
3. **Wait for completion**:
   ```
   task_await(timeout_secs: 600)
   ```
4. **Review each result**: Present sub-agent reports for user approval:
   ```
   Review task 1.1: [summary of changes]
   Approve? [Y/n/feedback]
   ```
5. **Process approvals**:
   - Approved: Mark task `[x]` complete in tasks.md, apply git patch
   - Rejected: Spawn fix sub-agent with user feedback
6. **Repeat** until all tasks in batch are approved

### 4. Verification

After all tasks complete, run verification protocol (see below).

### 5. Archive

When verified, archive the completed change.

## Sub-Agent Prompt Template

```
Task: Implement [task_id] - [task_description]

Context:
- Change: [change_name]
- Proposal: openspec/changes/[change]/proposal.md
- Design: openspec/changes/[change]/design.md

Deliverables:
- Implementation matching the design approach
- Commit changes with message: "[task_id] [description]"

Constraints:
- Follow design.md patterns
- Match naming conventions from specs
- No scope creep beyond this task
```

## Batch Execution Flow

```
opsx-exec (orchestrator)
    │
    ├─ Batch 1: spawn N sub-agents in parallel
    │   └─ task_await() for all
    │
    ├─ Review each output → approve/reject
    │   ├─ Approved: mark [x], apply patch
    │   └─ Rejected: spawn fix sub-agent
    │
    ├─ Batch 2: (after Batch 1 approved)
    │
    └─ All batches done → Verification → Archive
```

## Verification Protocol

Verify implementation across three dimensions:

### Completeness
- Are all tasks in tasks.md checked `[x]`?
- Does every requirement in proposal.md have corresponding code?
- Are all scenarios from design.md covered?

### Correctness
- Does implementation match the spec's intent (not just letter)?
- Are edge cases from design.md handled?
- Do error states match what was specified?

### Coherence
- Are design decisions from design.md reflected in code?
- Are naming conventions consistent with specs?
- Do patterns match what design.md prescribed?

### Issue Reporting

Report findings by severity:
- **CRITICAL**: Blocks acceptance. Must fix before archive.
- **WARNING**: Should address. May indicate spec drift.
- **SUGGESTION**: Nice to have. Consider for future.

## Archive Workflow

When verification passes:

1. **Check artifact completion**: Ensure all spec files are finalized
2. **Offer delta sync**: 
   ```
   Sync delta specs to main specs? [Y/n]
   ```
   If yes, merge any delta/ files into main specification files
3. **Move to archive**:
   ```
   openspec/changes/archive/YYYY-MM-DD-<name>/
   ```
   Preserves the full change history for future reference

## Key Principle

The verification step is central to OpenSpec's value. Implementation without verification is just coding. Verification ensures the code actually delivers what was specified—closing the loop between design and delivery.
