enum AccessPoint { ne1, ne2, ne3, se1, se2, se3, sw1, sw2, sw3, nw1, nw2, nw3 }

class TileSetup {
  final int size;
  final List<AccessPoint> accesPoints;

  const TileSetup(this.size, this.accesPoints);
}
