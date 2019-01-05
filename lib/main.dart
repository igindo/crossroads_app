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
  Map<Actor, Point> _snapshot;
  Bounds bounds;
  Point roadSize;
  Network network;

  @override
  void initState() {
    final accessPoints = <AccessPoint>[
      AccessPoint.ne2,
      AccessPoint.nw1,
      AccessPoint.se3,
      AccessPoint.sw2
    ];
    final setup = TileSetup(320, accessPoints);
    bounds = Bounds(Point(-setup.size / 2, 0), Point(0, -setup.size / 4),
        Point(setup.size / 2, 0), Point(0, setup.size / 4), setup.size / 64);
    roadSize = Point(setup.size / 25, setup.size / 50);
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
    final accessPoints = <AccessPoint>[
      AccessPoint.ne2,
      AccessPoint.nw2,
      AccessPoint.se2
    ];

    return CustomMultiChildLayout(delegate: Delegate(), children: [
      /*CustomPaint(
        painter: StateDrawer(_snapshot),
      ),*/
      LayoutId(
          id: 'tile',
          child: CustomPaint(
            painter: TileDrawer(
                TileSetup(320, accessPoints), bounds, roadSize, network),
          ))
    ]);
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
