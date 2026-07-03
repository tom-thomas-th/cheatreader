## ADDED Requirements

### Requirement: Automatic page-turn
The system SHALL support an automatic page-turn mode that advances the reading position on a configurable timer, using either whole-page or single-line advancement granularity, and SHALL stop automatically when no further forward movement is possible.

#### Scenario: Enable auto page-turn
- **WHEN** the user enables auto page-turn
- **THEN** the reader begins advancing the reading position on the configured interval

#### Scenario: Advance by whole page
- **WHEN** auto page-turn is enabled with page granularity
- **THEN** each tick advances the reading position by one visible page, equivalent to the next-page action

#### Scenario: Advance by single line
- **WHEN** auto page-turn is enabled with line granularity
- **THEN** each tick advances the reading position by one line or segment, equivalent to the next-line action

#### Scenario: Change interval while running
- **WHEN** the user changes the page-turn interval while auto page-turn is enabled
- **THEN** the next tick fires after the newly configured interval without requiring a manual toggle

#### Scenario: Stop at end of content
- **WHEN** a tick cannot advance the reading position any further and auto page-turn is enabled
- **THEN** the reader disables auto page-turn and notifies the user

#### Scenario: Toggle via keyboard shortcut
- **WHEN** the user presses the configured auto page-turn shortcut
- **THEN** the reader toggles auto page-turn on or off and shows a transient status message

#### Scenario: Persist auto page-turn state
- **WHEN** the user reopens the reader after closing it
- **THEN** the saved auto page-turn enable state, interval, and granularity are restored
