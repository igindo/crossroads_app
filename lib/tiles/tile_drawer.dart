import 'package:flutter/material.dart';

import 'package:crossroads/crossroads.dart' show Connection, Point;

import 'package:crossroads_app/tiles/calc.dart';
import 'package:crossroads_app/tiles/tile_setup.dart';

class TileDrawer extends CustomPainter {
  final TileSetup setup;
  final Bounds bounds;
  final Point roadSize;
  final List<List<Connection>> paths;
  final List<Connection> connections;

  TileDrawer(
      this.setup, this.bounds, this.roadSize, this.paths, this.connections);

  @override
  void paint(Canvas canvas, Size size) {
    _drawEmpty(canvas);
    _drawTerrain(canvas);

    const colors = [Colors.white, Colors.red, Colors.blue, Colors.yellow];
    var index = 0;

    /*connections.forEach((connection) {
      canvas.drawPath(
          Path()
            ..moveTo(connection.start.x, connection.start.y)
            ..lineTo(connection.end.x, connection.end.y),
          Paint()
            ..color = colors[(index++) % colors.length]
            ..style = PaintingStyle.stroke
            ..strokeWidth = 2);
    });*/
  }

  void _drawEmpty(Canvas canvas) {
    final double height3D = setup.size / 16;
    final asphalt = Paint()
          ..style = PaintingStyle.fill
          ..strokeWidth = 6
          ..color = Color.fromARGB(255, 84, 84, 84),
        soilPaintA = Paint()
          ..style = PaintingStyle.fill
          ..strokeWidth = 6
          ..color = Color.fromARGB(255, 128, 74, 30),
        soilPaintB = Paint()
          ..style = PaintingStyle.fill
          ..strokeWidth = 6
          ..color = Color.fromARGB(255, 79, 45, 18);
    final path = Path()
          ..moveTo(bounds.left.x, bounds.left.y)
          ..lineTo(bounds.top.x, bounds.top.y)
          ..lineTo(bounds.right.x, bounds.right.y)
          ..lineTo(bounds.bottom.x, bounds.bottom.y),
        blPath = Path()
          ..moveTo(bounds.left.x, bounds.left.y)
          ..relativeLineTo(0, height3D)
          ..lineTo(bounds.bottom.x, bounds.bottom.y + height3D)
          ..relativeLineTo(0, -height3D),
        brPath = Path()
          ..moveTo(bounds.bottom.x, bounds.bottom.y)
          ..relativeLineTo(0, height3D)
          ..lineTo(bounds.right.x, bounds.right.y + height3D)
          ..relativeLineTo(0, -height3D);

    canvas.drawPath(path, asphalt);
    canvas.drawPath(blPath, soilPaintA);
    canvas.drawPath(brPath, soilPaintB);
  }

  @override
  bool shouldRepaint(TileDrawer oldDelegate) => false;

  void _drawTerrain(Canvas canvas) {
    final dx = roadSize.x / 2, dy = roadSize.y / 2;
    final ptl = Point(-dx, -dy),
        pbr = Point(dx, dy),
        ptr = Point(dx, -dy),
        pbl = Point(-dx, dy);
    var bottomPath = Path()
      ..moveTo(bounds.left.x, bounds.left.y)
      ..lineTo(bounds.top.x, bounds.top.y)
      ..lineTo(bounds.right.x, bounds.right.y)
      ..lineTo(bounds.bottom.x, bounds.bottom.y);

    for (var i = 0, len = paths.length; i < len; i++) {
      final path = paths[i];
      final head = <Point>[], tail = <Point>[];

      for (var j = 0, len2 = path.length; j < len2; j++) {
        final connection = path[j];

        if (connection.start.x < connection.end.x &&
            connection.start.y < connection.end.y) {
          head.add(connection.start.add(pbl));
          head.add(connection.end.add(pbl));
          tail.add(connection.start.add(ptr));
          tail.add(connection.end.add(ptr));
        } else if (connection.start.x > connection.end.x &&
            connection.start.y > connection.end.y) {
          head.add(connection.start.add(ptr));
          head.add(connection.end.add(ptr));
          tail.add(connection.start.add(pbl));
          tail.add(connection.end.add(pbl));
        } else if (connection.start.x < connection.end.x &&
            connection.start.y > connection.end.y) {
          head.add(connection.start.add(pbr));
          head.add(connection.end.add(pbr));
          tail.add(connection.start.add(ptl));
          tail.add(connection.end.add(ptl));
        } else if (connection.start.x > connection.end.x &&
            connection.start.y < connection.end.y) {
          head.add(connection.start.add(ptl));
          head.add(connection.end.add(ptl));
          tail.add(connection.start.add(pbr));
          tail.add(connection.end.add(pbr));
        }
      }

      final drawPath = Path()..moveTo(head.first.x, head.first.y);
      final lineTo = (Point point) => drawPath.lineTo(point.x, point.y);

      head.skip(1).forEach(lineTo);
      tail.reversed.forEach(lineTo);

      drawPath.close();

      bottomPath = Path.combine(PathOperation.difference, bottomPath, drawPath);
    }

    bottomPath.close();

    final grassPaintA = Paint()
          ..style = PaintingStyle.fill
          ..strokeWidth = 6
          ..color = Color.fromARGB(255, 58, 145, 40),
        grassPaintB = Paint()
          ..style = PaintingStyle.fill
          ..strokeWidth = 6
          ..color = Color.fromARGB(255, 27, 116, 34);

    final len = (bounds.roadHeight / 2).ceil();

    for (var i = 0; i < len; i++) {
      canvas.drawPath(bottomPath.shift(Offset(0, -i.toDouble())),
          i == len - 1 ? grassPaintA : grassPaintB);
    }
  }
}
