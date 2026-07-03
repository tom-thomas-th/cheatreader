## Why

阅读时需要手动不断翻页，长时间阅读容易疲劳，也无法在阅读时解放双手（例如边读边做笔记）。希望阅读器能按可配置的速度自动前进，并保留对前进粒度和触发节奏的完全控制。

## What Changes

- 新增「自动翻页」开关，开启后按设定间隔自动前进阅读内容。
- 新增可配置的翻页间隔（1–60 秒，默认 5 秒）。
- 新增可配置的前进粒度：「整页」（每次推进一屏可见行，等价 PageDown）或「逐行」（每次推进一行/段，等价下方向键）。
- 新增可自定义的快捷键（默认 `A`）用于在阅读时随手开关自动翻页，并通过 toast 提示当前状态。
- 到达书末无法继续前进时，自动关闭翻页并提示。
- 所有相关设置随现有偏好一并持久化。

## Capabilities

### New Capabilities
- None.

### Modified Capabilities
- `reader-navigation-controls`: 新增「自动翻页」导航方式，按计时器按设定粒度自动前进，并在到达结尾时停止。
- `reader-control-panel`: 在阅读设置区暴露自动翻页开关、粒度与间隔控件，以及对应的快捷键录制项。

## Impact

- 受影响代码：`lib/src/reader_settings.dart`、`lib/src/reader_controller.dart`、`lib/src/reader_preferences.dart`、`lib/src/reader_shortcuts.dart`、`lib/src/reader_app.dart`，以及本地化资源（`lib/l10n/*.arb` 与生成文件）。
- 新增键盘动作 `autoPage`（默认 `A`），与现有可定制快捷键系统一致；对已有用户向后兼容（旧偏好缺失该键时回退默认）。
- 无外部 API 变更；属阅读交互与设置增强。
- 需补充自动翻页在多行/单行模式下的手动验证，以及到结尾自动停止的行为。
