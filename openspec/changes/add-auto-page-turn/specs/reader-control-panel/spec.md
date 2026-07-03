## ADDED Requirements

### Requirement: Auto page-turn settings
The control panel SHALL expose auto page-turn controls in the reading-settings section, including an enable toggle, an advance-granularity choice (page or line), and a page-turn interval, alongside a rebindable keyboard shortcut for toggling auto page-turn.

#### Scenario: Toggle auto page-turn from panel
- **WHEN** the user toggles the auto page-turn switch in the control panel
- **THEN** auto page-turn is enabled or disabled immediately

#### Scenario: Choose advance granularity
- **WHEN** the user selects page or line granularity in the control panel
- **THEN** subsequent auto page-turn ticks use the selected granularity

#### Scenario: Adjust page-turn interval
- **WHEN** the user drags the interval slider
- **THEN** the interval is clamped to the supported range (1–60 seconds) and applied to the running timer

#### Scenario: Rebind auto page-turn shortcut
- **WHEN** the user records a new key for the auto page-turn action in the keyboard-controls section
- **THEN** the new shortcut is saved and conflicts with other actions are rejected
