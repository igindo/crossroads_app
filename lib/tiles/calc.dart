import 'package:crossroads/crossroads.dart' show Connection, Point, Speed;

TemplateCollection calculateData(final Bounds bounds, final Point roadSize) {
  final nw = Point(bounds.left.x / 4, bounds.top.y / 4),
      ne = Point(bounds.right.x / 4, bounds.top.y / 4),
      se = Point(bounds.right.x / 4, bounds.bottom.y / 4),
      sw = Point(bounds.left.x / 4, bounds.bottom.y / 4);

  final neLeftStart = Point(ne.x + roadSize.x / 2, 3 * ne.y + roadSize.y / 2),
      neLeftEnd = Point(roadSize.x, bounds.top.y / 2),
      neRightStart = Point(ne.x - roadSize.x / 2, 3 * ne.y - roadSize.y / 2),
      neRightEnd = Point(0, -roadSize.y + bounds.top.y / 2),
      nwLeftStart = Point(nw.x + roadSize.x / 2, 3 * nw.y - roadSize.y / 2),
      nwLeftEnd = Point(0, -roadSize.y + bounds.top.y / 2),
      nwRightStart = Point(nw.x - roadSize.x / 2, 3 * nw.y + roadSize.y / 2),
      nwRightEnd = Point(-roadSize.x, bounds.top.y / 2),
      seLeftStart = Point(se.x - roadSize.x / 2, 3 * se.y + roadSize.y / 2),
      seLeftEnd = Point(0, roadSize.y + bounds.bottom.y / 2),
      seRightStart = Point(se.x + roadSize.x / 2, 3 * se.y - roadSize.y / 2),
      seRightEnd = Point(roadSize.x, bounds.bottom.y / 2),
      swLeftStart = Point(sw.x - roadSize.x / 2, 3 * sw.y - roadSize.y / 2),
      swLeftEnd = Point(-roadSize.x, bounds.bottom.y / 2),
      swRightStart = Point(sw.x + roadSize.x / 2, 3 * sw.y + roadSize.y / 2),
      swRightEnd = Point(0, roadSize.y + bounds.bottom.y / 2);

  return TemplateCollection(
      PathTemplate(
        PathSegment(
            neLeftStart,
            neLeftStart.add(Point(-roadSize.x / 2, roadSize.y / 2)),
            neLeftEnd,
            neLeftEnd.add(Point(-roadSize.x / 2, roadSize.y / 2)),
            neLeftEnd.add(Point(-roadSize.x, roadSize.y))),
        PathSegment(
            neRightStart,
            neRightStart.add(Point(-roadSize.x / 2, roadSize.y / 2)),
            neRightEnd,
            neRightEnd.add(Point(-roadSize.x / 2, -roadSize.y / 2)),
            neRightEnd.add(Point(-roadSize.x, -roadSize.y))),
      ),
      PathTemplate(
          PathSegment(
              nwLeftStart,
              nwLeftStart.add(Point(roadSize.x / 2, roadSize.y / 2)),
              nwLeftEnd,
              nwLeftEnd.add(Point(roadSize.x / 2, roadSize.y / 2)),
              nwLeftEnd.add(Point(roadSize.x, roadSize.y))),
          PathSegment(
              nwRightStart,
              nwRightStart.add(Point(roadSize.x / 2, roadSize.y / 2)),
              nwRightEnd,
              nwRightEnd.add(Point(roadSize.x / 2, roadSize.y / 2)),
              nwRightEnd.add(Point(roadSize.x, roadSize.y)))),
      PathTemplate(
          PathSegment(
              seLeftStart,
              seLeftStart.add(Point(-roadSize.x / 2, -roadSize.y / 2)),
              seLeftEnd,
              seLeftEnd.add(Point(-roadSize.x / 2, -roadSize.y / 2)),
              seLeftEnd.add(Point(-roadSize.x, -roadSize.y))),
          PathSegment(
              seRightStart,
              seRightStart.add(Point(-roadSize.x / 2, -roadSize.y / 2)),
              seRightEnd,
              seRightEnd.add(Point(-roadSize.x / 2, -roadSize.y / 2)),
              seRightEnd.add(Point(-roadSize.x, -roadSize.y)))),
      PathTemplate(
          PathSegment(
              swLeftStart,
              swLeftStart.add(Point(roadSize.x / 2, -roadSize.y / 2)),
              swLeftEnd,
              swLeftEnd.add(Point(roadSize.x / 2, -roadSize.y / 2)),
              swLeftEnd.add(Point(roadSize.x, -roadSize.y))),
          PathSegment(
              swRightStart,
              swRightStart.add(Point(roadSize.x / 2, -roadSize.y / 2)),
              swRightEnd,
              swRightEnd.add(Point(roadSize.x / 2, -roadSize.y / 2)),
              swRightEnd.add(Point(roadSize.x, -roadSize.y)))));
}

List<PathTemplate> calculateTemplates(
    final Bounds bounds, final Point roadSize) {
  final data = calculateData(bounds, roadSize);

  final nw1 = data.nw,
      nw2 = data.nw.transform(Point(bounds.left.x / 4, bounds.bottom.y / 4)),
      nw3 = data.nw.transform(Point(bounds.left.x / 2, bounds.bottom.y / 2)),
      ne1 = data.ne,
      ne2 = data.ne.transform(Point(bounds.right.x / 4, bounds.bottom.y / 4)),
      ne3 = data.ne.transform(Point(bounds.right.x / 2, bounds.bottom.y / 2)),
      sw1 = data.sw,
      sw2 = data.sw.transform(Point(bounds.left.x / 4, bounds.top.y / 4)),
      sw3 = data.sw.transform(Point(bounds.left.x / 2, bounds.top.y / 2)),
      se1 = data.se,
      se2 = data.se.transform(Point(bounds.right.x / 4, bounds.top.y / 4)),
      se3 = data.se.transform(Point(bounds.right.x / 2, bounds.top.y / 2));

  return <PathTemplate>[
    nw1,
    nw1.transform(Point(bounds.right.x / 4, bounds.bottom.y / 4)),
    nw1.transform(Point(bounds.right.x / 2, bounds.bottom.y / 2)),
    nw2,
    nw2.transform(Point(bounds.right.x / 4, bounds.bottom.y / 4)),
    nw2.transform(Point(bounds.right.x / 2, bounds.bottom.y / 2)),
    nw3,
    nw3.transform(Point(bounds.right.x / 4, bounds.bottom.y / 4)),
    nw3.transform(Point(bounds.right.x / 2, bounds.bottom.y / 2)),
    ne1,
    ne1.transform(Point(bounds.left.x / 4, bounds.bottom.y / 4)),
    ne1.transform(Point(bounds.left.x / 2, bounds.bottom.y / 2)),
    ne2,
    ne2.transform(Point(bounds.left.x / 4, bounds.bottom.y / 4)),
    ne2.transform(Point(bounds.left.x / 2, bounds.bottom.y / 2)),
    ne3,
    ne3.transform(Point(bounds.left.x / 4, bounds.bottom.y / 4)),
    ne3.transform(Point(bounds.left.x / 2, bounds.bottom.y / 2)),
    sw1,
    sw1.transform(Point(bounds.right.x / 4, bounds.top.y / 4)),
    sw1.transform(Point(bounds.right.x / 2, bounds.top.y / 2)),
    sw2,
    sw2.transform(Point(bounds.right.x / 4, bounds.top.y / 4)),
    sw2.transform(Point(bounds.right.x / 2, bounds.top.y / 2)),
    sw3,
    sw3.transform(Point(bounds.right.x / 4, bounds.top.y / 4)),
    sw3.transform(Point(bounds.right.x / 2, bounds.top.y / 2)),
    se1,
    se1.transform(Point(bounds.left.x / 4, bounds.top.y / 4)),
    se1.transform(Point(bounds.left.x / 2, bounds.top.y / 2)),
    se2,
    se2.transform(Point(bounds.left.x / 4, bounds.top.y / 4)),
    se2.transform(Point(bounds.left.x / 2, bounds.top.y / 2)),
    se3,
    se3.transform(Point(bounds.left.x / 4, bounds.top.y / 4)),
    se3.transform(Point(bounds.left.x / 2, bounds.top.y / 2)),
  ];
}

class Bounds {
  final Point left, top, right, bottom;
  final double roadHeight;

  Bounds(this.left, this.top, this.right, this.bottom, this.roadHeight);
}

class PathSegment {
  final Point start, approach, end, midway, extended;

  PathSegment(this.start, this.approach, this.end, this.midway, this.extended);
}

class PathTemplate {
  final PathSegment left, right;

  PathTemplate(this.left, this.right);

  PathTemplate transform(Point offset) => PathTemplate(
      PathSegment(
          left.start.add(offset),
          left.approach.add(offset),
          left.end.add(offset),
          left.midway.add(offset),
          left.extended.add(offset)),
      PathSegment(
          right.start.add(offset),
          right.approach.add(offset),
          right.end.add(offset),
          right.midway.add(offset),
          right.extended.add(offset)));

  List<Connection> toConnections() => <Connection>[
        Connection(right.start, right.approach, Speed.undivided, const {}),
        Connection(right.approach, right.end, Speed.undivided, const {}),
        Connection(right.end, right.midway, Speed.undivided, const {}),
        Connection(right.midway, right.extended, Speed.undivided, const {}),
        Connection(left.extended, left.midway, Speed.undivided, const {}),
        Connection(left.midway, left.end, Speed.undivided, const {}),
        Connection(left.end, left.approach, Speed.undivided, const {}),
        Connection(left.approach, left.start, Speed.undivided, const {})
      ];
}

class TemplateCollection {
  final PathTemplate ne, nw, se, sw;

  TemplateCollection(this.ne, this.nw, this.se, this.sw);
}
