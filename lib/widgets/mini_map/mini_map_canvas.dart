import 'dart:math';

import 'package:bonfire/bonfire.dart';
import 'package:flutter/material.dart';

///
/// Created by
///
/// ─▄▀─▄▀
/// ──▀──▀
/// █▀▀▀▀▀█▄
/// █░░░░░█─█
/// ▀▄▄▄▄▄▀▀
///
/// Rafaelbarbosatec
/// on 12/04/22
class MiniMapCanvas extends CustomPainter {
  final Iterable<GameComponent> components;
  final Vector2 cameraPosition;
  final Vector2 gameSize;
  final MiniMapCustomRender<Tile>? tileRender;
  final MiniMapCustomRender? componentsRender;
  final double zoom;

  MiniMapCanvas({
    required this.components,
    required this.cameraPosition,
    required this.gameSize,
    this.zoom = 1, //change
    this.tileRender,
    this.componentsRender,
  });

  @override
  void paint(Canvas canvas, Size size) {
    double scaleX = size.width / gameSize.x;
    double scaleY = size.height / gameSize.y;
    double scale = max(scaleX, scaleY) * zoom / 1.5;
    double restX = (gameSize.x * scale - 4 * size.width);
    double restY = (gameSize.y * scale - 2 * size.height);

    canvas.translate(
      (cameraPosition.x + restX) * scale * -1,
      (cameraPosition.y + restY) * scale * -1,
    );
    canvas.save();
    canvas.scale(scale);
    for (var element in components) {
      if (element is Tile) {
        tileRender?.call(canvas, element);
      } else {
        componentsRender?.call(canvas, element);
      }
    }
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant MiniMapCanvas oldDelegate) {
    return true;
  }
}
