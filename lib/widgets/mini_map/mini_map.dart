import 'dart:async' as async;

import 'package:bonfire/bonfire.dart';
import 'package:flutter/material.dart';

import 'mini_map_canvas.dart';

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

typedef MiniMapCustomRender<T extends GameComponent> = void Function(
    Canvas canvas, T component);

class MiniMap extends StatefulWidget {
  final BonfireGame game;
  final MiniMapCustomRender<Tile>? tileRender;
  final MiniMapCustomRender? componentsRender;
  final Vector2 size;
  final EdgeInsetsGeometry? margin;
  final BorderRadius? borderRadius;
  final Color? backgroundColor;
  final BoxBorder? border;
  final Color? tileCollisionColor;
  final Color? tileColor;
  final Color? playerColor;
  final Color? enemyColor;
  final Color? npcColor;
  final Color? allyColor;
  final Color? decorationColor;
  final double zoom;
  MiniMap({
    Key? key,
    required this.game,
    this.tileRender,
    this.componentsRender,
    Vector2? size,
    this.margin,
    this.borderRadius,
    this.backgroundColor,
    this.border,
    this.tileCollisionColor,
    this.tileColor,
    this.playerColor,
    this.enemyColor,
    this.npcColor,
    this.allyColor,
    this.zoom = 2, //change
    this.decorationColor,
  })  : size = size ?? Vector2(100, 250),
        super(key: key);

  @override
  State<MiniMap> createState() => _MiniMapState();
}

class _MiniMapState extends State<MiniMap> {
  Vector2 cameraPosition = Vector2.zero();
  Vector2 playerPosition = Vector2.zero();

  late async.Timer timer;
  @override
  void initState() {
    _initInterval();
    super.initState();
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.game.hasLayout) {
      return const SizedBox.shrink();
    }
    return Positioned(
      right: 0,
      child: Padding(
        padding: widget.margin ?? EdgeInsets.zero,
        child: ClipRRect(
          borderRadius: widget.borderRadius ?? BorderRadius.zero,
          child: Container(
            width: widget.size.x,
            height: widget.size.y,
            decoration: BoxDecoration(
              border: widget.border,
              color: widget.backgroundColor ??
                  Color.fromARGB(255, 253, 253, 253).withOpacity(0.5),
              borderRadius: widget.borderRadius,
            ),
            child: ClipRRect(
              borderRadius: widget.borderRadius ?? BorderRadius.zero,
              child: CustomPaint(
                painter: MiniMapCanvas(
                  components: widget.game.visibleComponents().toList()
                    ..addAll(
                      widget.game.map.getRendered(),
                    ),
                  cameraPosition: cameraPosition,
                  gameSize: widget.game.size,
                  componentsRender:
                      widget.componentsRender ?? componentsRenderDefault(),
                  tileRender: widget.tileRender ?? tilesRenderDefault(),
                  zoom: widget.zoom,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _initInterval() {
    timer = async.Timer.periodic(const Duration(milliseconds: 100), (timer) {
      if (widget.game.camera.position != cameraPosition) {
        cameraPosition = widget.game.camera.position.clone();
        playerPosition = cameraPosition; //change

        setState(() {});
      }
      if (widget.game.player?.position != playerPosition) {
        //change
        playerPosition = widget.game.player?.position.clone() ?? Vector2.zero();
        cameraPosition = playerPosition; //change

        setState(() {});
      }
    });
  }

  MiniMapCustomRender<Tile> tilesRenderDefault() => (canvas, component) {
        if (component is ObjectCollision) {
          (component as ObjectCollision).renderCollision(
            canvas,
            widget.tileCollisionColor ?? Colors.black.withOpacity(0.5),
          );
        } else if (widget.tileColor != null) {
          (component as ObjectCollision).renderCollision(
            canvas,
            widget.tileColor!,
          );
        }
      };

  MiniMapCustomRender componentsRenderDefault() => (canvas, component) {
        if (component is ObjectCollision) {
          if (component is GameDecoration) {
            component.renderCollision(
              canvas,
              widget.decorationColor ??
                  Color.fromARGB(255, 86, 21, 209).withOpacity(0.5),
            );
          }
          if (component is Player) {
            component.renderCollision(
              canvas,
              widget.playerColor ?? Colors.cyan.withOpacity(0.5),
            );
          } else if (component is Ally) {
            component.renderCollision(
              canvas,
              widget.allyColor ?? Colors.yellow.withOpacity(0.5),
            );
          } else if (component is Enemy) {
            component.renderCollision(
              canvas,
              widget.playerColor ?? Colors.red.withOpacity(0.5),
            );
          } else if (component is Npc) {
            component.renderCollision(
              canvas,
              widget.npcColor ?? Colors.green.withOpacity(0.5),
            );
          }
        }
      };
}
