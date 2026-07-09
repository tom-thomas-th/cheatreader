import 'dart:io';

import 'package:image/image.dart' as img;

void main() {
  final outputDir = Directory('assets/disguise');
  outputDir.createSync(recursive: true);

  for (final preset in _PresetIcon.values) {
    final image = _renderPreset(preset, 32);
    File(
      '${outputDir.path}/${preset.fileName}.png',
    ).writeAsBytesSync(img.encodePng(image));
    File(
      '${outputDir.path}/${preset.fileName}.ico',
    ).writeAsBytesSync(img.encodeIco(image));
  }
}

enum _PresetIcon {
  codeEditor('code_editor'),
  devStudio('dev_studio'),
  terminal('terminal'),
  notes('notes');

  const _PresetIcon(this.fileName);

  final String fileName;
}

img.Image _renderPreset(_PresetIcon preset, int size) {
  final image = img.Image(width: size, height: size, numChannels: 4);
  img.fill(image, color: img.ColorRgba8(0, 0, 0, 0));

  switch (preset) {
    case _PresetIcon.codeEditor:
      _drawRoundedRect(image, 3, 4, 28, 27, _color(30, 36, 48), radius: 5);
      _drawRoundedRect(image, 3, 4, 28, 9, _color(54, 65, 82), radius: 4);
      _drawLine(image, 8, 17, 13, 12, _color(96, 165, 250), thickness: 2);
      _drawLine(image, 8, 17, 13, 22, _color(96, 165, 250), thickness: 2);
      _drawLine(image, 23, 12, 18, 17, _color(52, 211, 153), thickness: 2);
      _drawLine(image, 23, 22, 18, 17, _color(52, 211, 153), thickness: 2);
      _drawLine(image, 17, 12, 14, 23, _color(226, 232, 240), thickness: 2);
    case _PresetIcon.devStudio:
      _drawRoundedRect(image, 3, 3, 28, 28, _color(25, 34, 46), radius: 7);
      _drawRectOutline(
        image,
        7,
        8,
        24,
        23,
        _color(125, 211, 252),
        thickness: 2,
      );
      _drawLine(image, 11, 12, 20, 12, _color(226, 232, 240), thickness: 2);
      _drawLine(image, 11, 17, 18, 17, _color(148, 163, 184), thickness: 2);
      _drawLine(image, 11, 21, 22, 21, _color(52, 211, 153), thickness: 2);
      img.fillCircle(
        image,
        x: 23,
        y: 8,
        radius: 3,
        color: _color(251, 191, 36),
        antialias: true,
      );
    case _PresetIcon.terminal:
      _drawRoundedRect(image, 3, 5, 28, 26, _color(16, 24, 39), radius: 5);
      _drawRoundedRect(image, 3, 5, 28, 10, _color(51, 65, 85), radius: 4);
      _drawLine(image, 8, 16, 12, 19, _color(52, 211, 153), thickness: 2);
      _drawLine(image, 8, 22, 12, 19, _color(52, 211, 153), thickness: 2);
      _drawLine(image, 15, 22, 23, 22, _color(226, 232, 240), thickness: 2);
    case _PresetIcon.notes:
      _drawRoundedRect(image, 6, 3, 25, 29, _color(241, 245, 249), radius: 3);
      _drawRoundedRect(image, 6, 3, 25, 8, _color(251, 191, 36), radius: 3);
      _drawLine(image, 10, 13, 21, 13, _color(71, 85, 105), thickness: 2);
      _drawLine(image, 10, 18, 21, 18, _color(100, 116, 139), thickness: 2);
      _drawLine(image, 10, 23, 18, 23, _color(100, 116, 139), thickness: 2);
  }

  return image;
}

img.Color _color(int red, int green, int blue, [int alpha = 255]) {
  return img.ColorRgba8(red, green, blue, alpha);
}

void _drawRoundedRect(
  img.Image image,
  int x1,
  int y1,
  int x2,
  int y2,
  img.Color color, {
  required int radius,
}) {
  img.fillRect(
    image,
    x1: x1,
    y1: y1,
    x2: x2,
    y2: y2,
    color: color,
    radius: radius,
  );
}

void _drawRectOutline(
  img.Image image,
  int x1,
  int y1,
  int x2,
  int y2,
  img.Color color, {
  required num thickness,
}) {
  _drawLine(image, x1, y1, x2, y1, color, thickness: thickness);
  _drawLine(image, x2, y1, x2, y2, color, thickness: thickness);
  _drawLine(image, x2, y2, x1, y2, color, thickness: thickness);
  _drawLine(image, x1, y2, x1, y1, color, thickness: thickness);
}

void _drawLine(
  img.Image image,
  int x1,
  int y1,
  int x2,
  int y2,
  img.Color color, {
  required num thickness,
}) {
  img.drawLine(
    image,
    x1: x1,
    y1: y1,
    x2: x2,
    y2: y2,
    color: color,
    thickness: thickness,
    antialias: true,
  );
}
