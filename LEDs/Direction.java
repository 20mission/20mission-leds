public enum Direction {
  NORTH(447),
  SOUTH(447),
  EAST(174),
  WEST(150);

  public final int NUM_LEDS;

  Direction(int numLeds) {
  	this.NUM_LEDS = numLeds;
  }
}
