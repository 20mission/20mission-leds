public enum Direction {
  NORTH(600),
  SOUTH(600),
  EAST(170),
  WEST(130);

  public final int NUM_LEDS;

  Direction(int numLeds) {
  	this.NUM_LEDS = numLeds;
  }
}
