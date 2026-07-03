## 1. Settings and persistence

- [x] 1.1 Add `ReaderAutoPageGranularity` enum and `autoPageEnabled` / `autoPageIntervalSeconds` / `autoPageGranularity` fields to `ReaderSettings` with constants (min 1, max 60, default 5) and `copyWith`/equality.
- [x] 1.2 Add controller setters `setAutoPageEnabled`, `setAutoPageIntervalSeconds` (clamped), `setAutoPageGranularity`.
- [x] 1.3 Add preference keys and load/save for the three new settings, with safe fallbacks.

## 2. Shortcut

- [x] 2.1 Add `ReaderShortcutAction.autoPage` and `ReaderShortcutKey.keyA` (legacy name `keyA`).
- [x] 2.2 Wire `autoPage` into `ReaderShortcutBindings` (defaults, keyForAction, copyWith, copyWithAction, toJson, fromJson, ==, hashCode).
- [x] 2.3 Bind the shortcut to a toggle handler that shows an on/off toast.

## 3. Reader surface timer

- [x] 3.1 Add `_autoPageTimer` and `_syncAutoPageTimer()` reconciling on enabled/interval changes; call from `build()`, cancel in `dispose()`.
- [x] 3.2 Add `_autoPageTick()` dispatching by granularity (page vs line).
- [x] 3.3 Refactor `_advanceReadingPage()` to return whether it moved.
- [x] 3.4 Auto-disable and toast when the end is reached.

## 4. Control panel UI

- [x] 4.1 Add an auto page-turn switch in the reading-settings section.
- [x] 4.2 Add a granularity `SegmentedButton` (page / line).
- [x] 4.3 Add an interval `_SliderRow` (1–60s) with localized display value.
- [x] 4.4 Add the `autoPage` case to the shortcut label switch.

## 5. Localization

- [x] 5.1 Add 11 new strings (en + zh) to `.arb` files and regenerate via `flutter gen-l10n`.

## 6. Validation

- [x] 6.1 Add a controller test for auto-page settings persistence and interval clamping; extend the existing preferences round-trip test.
- [x] 6.2 `flutter analyze` clean; `flutter test` green.
- [ ] 6.3 Manually validate: enable/disable via shortcut and panel, page vs line granularity, interval change while running, end-of-book auto-stop, persistence across restart.
