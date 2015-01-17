public static class Model extends LXModel {

  public final static int NUM_WALLS = 4;

  public final List<Wall> walls;
  public final List<LED> leds;

  public Model() {
    super(new Fixture());

    Fixture f = (Fixture)this.fixtures.get(0);
    this.walls = Collections.unmodifiableList(f.walls);

    List<LED> leds = new ArrayList<LED>();
    for (Wall wall : this.walls) {
      for (LED led : wall.leds) {
        leds.add(led);
      }
    }
    this.leds = Collections.unmodifiableList(leds);
  }

  private static class Fixture extends LXAbstractFixture {

    final List<Wall> walls = new ArrayList<Wall>(NUM_WALLS);

    private Fixture() {
      for (int i = 0; i < NUM_WALLS; i++) {
        Wall wall = new Wall(Direction.values()[i]);
        walls.add(wall);
        for (LXPoint p : wall.points) {
          points.add(p);
        }
      }
    }
  }
}

public static class Wall extends LXModel {

  public final List<LED> leds;
  public final Direction direction;

  public Wall(Direction direction) {
    super(new Fixture(direction));

    this.direction = direction;

    Fixture f = (Fixture)this.fixtures.get(0);
    this.leds = Collections.unmodifiableList(f.leds);
  }

  private static class Fixture extends LXAbstractFixture {
    
    final List<LED> leds = new ArrayList<LED>();

    private Fixture(Direction direction) {
      int numLEDs = direction.NUM_LEDS;
      float wallCoord;
      switch (direction) {
        case NORTH:
          wallCoord = -1;
          break;
        case SOUTH:
          wallCoord = 1;
          break;
        case EAST:
          wallCoord = -1;
          break;
        default:
        case WEST:
          wallCoord = 1;
          break;
      }

      for (int i = 0; i < numLEDs; i++) {
        LED led;
        float ledCoord = 2.0 * i / numLEDs - 1.0;
        if (direction == Direction.NORTH || direction == Direction.SOUTH) {
          led = new LED(ledCoord, wallCoord);
        } else {
          led = new LED(wallCoord, ledCoord);
        }
        leds.add(led);

        for (LXPoint p : led.points) {
          this.points.add(p);
        }
      }
    }
  }
}

public static class LED extends LXModel {

  public final int index;

  public final float x;
  public final float y;
  public final float theta;

  public LED(float x, float y) {
    super(Arrays.asList(new LXPoint[] { new LXPoint(x, y) }));

    this.index = this.points.get(0).index;

    this.x = x;
    this.y = y;

    this.theta = 180 + 180 / PI * atan2(this.y, this.x);
  }
}
