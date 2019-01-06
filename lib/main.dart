import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'package:crossroads/crossroads.dart';

import 'package:crossroads/setups/mortsel.dart';

import 'package:crossroads_app/tiles/calc.dart';
import 'package:crossroads_app/tiles/tile_drawer.dart';
import 'package:crossroads_app/tiles/tile_setup.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  createState() => SnapshotState();
}

class SnapshotState extends State<MyApp> {
  final int size = 320;
  Map<Actor, Point> _snapshot;
  Bounds bounds;
  Point roadSize;
  Network network;

  @override
  void initState() {
    bounds = Bounds(Point(-size / 2, 0), Point(0, -size / 4),
        Point(size / 2, 0), Point(0, size / 4), size / 64);
    roadSize = Point(size / 25, size / 50);
    network = Network(calculateTemplates(bounds, roadSize)
        .expand((template) => template.toConnections())
        .toList(growable: false));

    /*supervisor.snapshot
        .throttle(const Duration(milliseconds: 30))
        .listen((snapshot) {
      setState(() => _snapshot = snapshot);
    });*/

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final paths = <List<Connection>>[];
    final connections = <Connection>[];
    final setup = TileSetup(size, _randomAccessPoints());

    setup.accesPoints.forEach((start) {
      setup.accesPoints.where((ap) => ap != start).forEach((end) {
        final pathA = resolveConnection(network, _resolveStartingPoint(start),
                _resolveEndingPoint(end)),
            pathB = resolveConnection(network, _resolveStartingPoint(end),
                _resolveEndingPoint(start));

        paths.add(pathA);
        paths.add(pathB);

        connections..addAll(pathA)..addAll(pathB);
      });
    });

    return CustomMultiChildLayout(delegate: Delegate(), children: [
      /*CustomPaint(
        painter: StateDrawer(_snapshot),
      ),*/
      LayoutId(
          id: 'tile',
          child: CustomPaint(
            painter: TileDrawer(setup, bounds, roadSize, paths, connections),
          ))
    ]);
  }

  List<AccessPoint> _randomAccessPoints() {
    final random = math.Random();
    final sides = [
      const [AccessPoint.ne1, AccessPoint.ne2, AccessPoint.ne3],
      const [AccessPoint.nw1, AccessPoint.nw2, AccessPoint.nw3],
      const [AccessPoint.se1, AccessPoint.se2, AccessPoint.se3],
      const [AccessPoint.sw1, AccessPoint.sw2, AccessPoint.sw3]
    ];

    return List(random.nextInt(3) + 2)
        .map((_) =>
            sides.removeAt(random.nextInt(sides.length))[random.nextInt(3)])
        .toList(growable: false);
  }

  Point _resolveStartingPoint(AccessPoint accessPoint) {
    final toIndex = (int offset) => offset * 24;

    switch (accessPoint) {
      case AccessPoint.nw1:
        return network.connections[toIndex(0)].start;
      case AccessPoint.nw2:
        return network.connections[toIndex(1)].start;
      case AccessPoint.nw3:
        return network.connections[toIndex(2)].start;
      case AccessPoint.ne1:
        return network.connections[toIndex(3)].start;
      case AccessPoint.ne2:
        return network.connections[toIndex(4)].start;
      case AccessPoint.ne3:
        return network.connections[toIndex(5)].start;
      case AccessPoint.sw1:
        return network.connections[toIndex(6)].start;
      case AccessPoint.sw2:
        return network.connections[toIndex(7)].start;
      case AccessPoint.sw3:
        return network.connections[toIndex(8)].start;
      case AccessPoint.se1:
        return network.connections[toIndex(9)].start;
      case AccessPoint.se2:
        return network.connections[toIndex(10)].start;
      case AccessPoint.se3:
        return network.connections[toIndex(11)].start;
    }

    return null;
  }

  Point _resolveEndingPoint(AccessPoint accessPoint) {
    final toIndex = (int offset) => offset * 24 + 7;

    switch (accessPoint) {
      case AccessPoint.nw1:
        return network.connections[toIndex(0)].end;
      case AccessPoint.nw2:
        return network.connections[toIndex(1)].end;
      case AccessPoint.nw3:
        return network.connections[toIndex(2)].end;
      case AccessPoint.ne1:
        return network.connections[toIndex(3)].end;
      case AccessPoint.ne2:
        return network.connections[toIndex(4)].end;
      case AccessPoint.ne3:
        return network.connections[toIndex(5)].end;
      case AccessPoint.sw1:
        return network.connections[toIndex(6)].end;
      case AccessPoint.sw2:
        return network.connections[toIndex(7)].end;
      case AccessPoint.sw3:
        return network.connections[toIndex(8)].end;
      case AccessPoint.se1:
        return network.connections[toIndex(9)].end;
      case AccessPoint.se2:
        return network.connections[toIndex(10)].end;
      case AccessPoint.se3:
        return network.connections[toIndex(11)].end;
    }

    return null;
  }
}

class StateDrawer extends CustomPainter {
  final Map<Actor, Point> _snapshot;

  StateDrawer(this._snapshot);

  static const colors = [
    Colors.red,
    Colors.green,
    Colors.blue,
    Colors.purple,
    Colors.pink
  ];
  final colorPoints = Set<Point>();

  @override
  void paint(Canvas canvas, Size size) {
    network.connections.forEach((connection) {
      final paint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2
        ..color = connection.congestionStateSync.isCongested
            ? Colors.red
            : connection.congestionStateSync.isActorLeaving
                ? Colors.orange
                : Colors.white70;

      canvas.drawLine(
          Offset(connection.start.x.toDouble() - 100,
              connection.start.y.toDouble() - 200),
          Offset(connection.end.x.toDouble() - 100,
              connection.end.y.toDouble() - 200),
          paint);

      /*connection.accepts.forEach((incoming, signs) {
        final lights =
            signs.where((sign) => sign is Stoplight).toList(growable: false);

        lights.forEach(
            (stoplight) => stoplight.canDriveBy.first.then((canDriveBy) {
                  final paint = Paint()
                    ..style = PaintingStyle.fill
                    ..color = canDriveBy
                        ? Color.fromARGB(128, 0, 255, 0)
                        : Color.fromARGB(128, 255, 0, 0);

                  canvas.drawCircle(
                      Offset(incoming.end.x, incoming.end.y), 4, paint);
                }));
      });*/
    });

    _snapshot?.forEach((actor, point) {
      colorPoints.add(actor.end);

      final paint = Paint()
        ..style = PaintingStyle.fill
        ..color =
            colors[colorPoints.toList(growable: false).indexOf(actor.end)];

      canvas.drawCircle(
          Offset(point.x.toDouble() - 100, point.y.toDouble() - 200), 4, paint);
    });
  }

  @override
  bool shouldRepaint(StateDrawer oldDelegate) => true;
}

class Delegate extends MultiChildLayoutDelegate {
  @override
  void performLayout(Size size) {
    if (hasChild('tile')) {
      layoutChild('tile', BoxConstraints.tight(size));
      positionChild('tile', const Offset(200, 200));
    }
  }

  @override
  bool shouldRelayout(MultiChildLayoutDelegate oldDelegate) => false;
}
