public enum Direction {
  NORTH(447),
  SOUTH(448),
  EAST(174),
  WEST(131);

  public final int NUM_LEDS;

  Direction(int numLeds) {
  	this.NUM_LEDS = numLeds;
  }
}
