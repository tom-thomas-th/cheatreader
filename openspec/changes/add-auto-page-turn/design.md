## Context

CheatReader is a keyboard-driven desktop reader where the primary forward action advances one line/segment (down-arrow, space, wheel) and PageDown advances one visible page. For long-form or hands-free reading, users currently have no way to advance automatically. We add an auto page-turn feature that drives the existing forward navigation on a timer, with user control over interval, advance granularity, and a toggle shortcut.

## Goals / Non-Goals

**Goals:**
- Provide a timer-driven automatic advance that reuses the existing forward/page navigation paths.
- Let users choose advance granularity: whole page (PageDown-equivalent) or single line/segment (down-arrow-equivalent).
- Let users choose the interval (1–60 seconds, default 5).
- Provide a rebindable keyboard shortcut (default `A`) to toggle auto page-turn while reading, with a transient status toast.
- Persist the enable state, interval, granularity, and shortcut binding alongside other reader settings.
- Stop automatically and notify when the end of the book is reached.

**Non-Goals:**
- Sub-second or variable-speed smoothing within a tick (interval is an integer number of seconds).
- Pausing auto page-turn when the control panel is open (it keeps running behind the dialog; users can toggle it off).
- Auto-scrolling pixel-by-pixel; we reuse the discrete line/page advance model.

## Decisions

### 1. Drive existing navigation methods instead of a separate advance path
The timer tick calls `_advanceReadingPage()` (page granularity) or `_advanceReadingInternal(animate: true)` (line granularity) — the same code paths as PageDown / down-arrow.

Rationale: Reuses well-tested segment-wrapping and animation logic in both single-line and multi-line modes; avoids a parallel advance path that could diverge.

Alternatives considered:
- Always advance one line regardless of granularity. Rejected: does not match the "翻页" (page) semantics requested by users.
- Add a dedicated `controller.nextAutoStep()`. Rejected: duplicates existing navigation.

### 2. Own the timer in the reader surface, not the controller
`_ReaderSurfaceState` owns the `Timer.periodic` and reconciles it in `build()` based on `settings.autoPageEnabled` and `autoPageIntervalSeconds`. The controller only holds settings/state.

Rationale: The forward/page advance methods live on the surface (they manage visual segments, animation tokens, and post-frame transitions). The controller's `notifyListeners` already triggers surface rebuilds, so reconciliation in `build` is cheap and consistent with the existing `updateVisibleLineCapacity` post-frame pattern.

Alternatives considered:
- Timer in the controller calling `controller.nextPage()`. Rejected: bypasses segment/animation handling and would mis-advance in single-line mode.

### 3. Refactor `_advanceReadingPage` to return whether it moved
Returning a bool lets the tick detect "reached the end" and auto-disable.

Rationale: Prevents a stuck "enabled but no-op" toggle at the end of a book. Existing callers ignore the return value (Dart discards return values for `void Function()` callbacks).

### 4. Persist the enable state by default
Like every other reader setting, `autoPageEnabled` is persisted and restored on launch.

Rationale: Consistency with the rest of the settings surface; predictable for users who close/reopen mid-read. The shortcut toast and end-of-book auto-stop provide clear feedback.

### 5. Add `autoPage` to the configurable shortcut system with default `A`
A new `ReaderShortcutAction.autoPage` with default `ReaderShortcutKey.keyA`, exposed in the keyboard-controls recorder.

Rationale: The app is keyboard-driven; toggling auto-page from the keyboard while reading is the expected UX. Additive: old saved bindings without `autoPage` fall back to the default via the existing `fromJson` decode-with-fallback.

## Risks / Trade-offs

- [A periodic timer created during `build` is a side effect] -> Mitigation: guarded by an "unchanged" check so it is only (re)created when enabled state or interval changes; cancelled in `dispose`.
- [Reaching the end mid-tick] -> Mitigation: tick detects no movement and disables auto-page with a toast.
- [Possible default-key collision for users who previously remapped another action to `A`] -> Mitigation: additive and low-frequency; the conflict resolver surfaces conflicts on reassignment.
- [Auto-paging behind an open control panel dialog] -> Mitigation: accepted; harmless and reversible via the shortcut or panel switch.

## Migration Plan

1. Add `ReaderAutoPageGranularity` enum and three settings fields with constants and equality.
2. Add controller setters (interval clamped 1–60) and preference load/save.
3. Add `autoPage` shortcut action + `keyA` to the bindings system.
4. Wire the timer, tick, shortcut handler, and control-panel UI; refactor `_advanceReadingPage` to return bool.
5. Add localization and regenerate; add tests.

Rollback strategy:
- Revert the feature commit; persisted auto-page keys remain harmlessly in preferences and are ignored by older builds.

## Open Questions

- Should auto page-turn pause while the control panel dialog is open? (Currently no.)
- Should the interval allow sub-second values for faster reading? (Currently integer seconds only.)
