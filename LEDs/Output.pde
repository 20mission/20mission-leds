public static class Output extends OPCOutput {

  final static int EAST_BREAK_INDEX = 150;
  final static int WEST_BREAK_INDEX = 21;

  public Output(LX lx) {
    super(lx, "courtyard-leds.local", 7890, pointIndices());
  }

  private static int[] pointIndices() {
    int[] pointIndices = new int[1218];

    int index = 0;

    // north side from east to west
    for (int i = EAST_BREAK_INDEX - 1; i >= 0; i--) {
      pointIndices[index++] = Direction.NORTH.NUM_LEDS
        + Direction.SOUTH.NUM_LEDS + i;
    }
    for (int i = 0; i < Direction.NORTH.NUM_LEDS; i++) {
      pointIndices[index++] = i;
    }
    for (int i = 0; i < WEST_BREAK_INDEX; i++) {
      pointIndices[index++] = Direction.NORTH.NUM_LEDS
        + Direction.SOUTH.NUM_LEDS + Direction.EAST.NUM_LEDS + i;
    }

    // south side from east to west
    for (int i = EAST_BREAK_INDEX; i < Direction.EAST.NUM_LEDS; i++) {
      pointIndices[index++] = Direction.NORTH.NUM_LEDS
        + Direction.SOUTH.NUM_LEDS + i;
    }
    for (int i = 0; i < Direction.SOUTH.NUM_LEDS; i++) {
      pointIndices[index++] = Direction.NORTH.NUM_LEDS + i;
    }
    for (int i = Direction.WEST.NUM_LEDS - 1; i >= WEST_BREAK_INDEX; i--) {
      pointIndices[index++] = Direction.NORTH.NUM_LEDS
        + Direction.SOUTH.NUM_LEDS + Direction.EAST.NUM_LEDS + i;
    }

    return pointIndices;
  }
}