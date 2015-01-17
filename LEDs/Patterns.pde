abstract public class Pattern extends LXPattern {

  final Model model;

  Pattern(LX lx) {
    super(lx);

    this.model = (Model)lx.model;
  }
}

public class SpinPattern extends Pattern {

  final SawLFO position = new SawLFO(0, LED.RECT_MAX, 8000);

  SpinPattern(LX lx) {
    super(lx);
    addModulator(position).start();
  }

  void run(double deltaMs) {
    for (LED led : model.leds) {
      colors[led.index] = lx.hsb(100,
        100,
        max(0, 100 - LXUtils.wrapdistf(led.rectTheta, position.getValuef(), LED.RECT_MAX) * 100)
      );
    }
  }
}

public class RainbowPattern extends Pattern {

  final SawLFO position = new SawLFO(0, 360, 3000);

  RainbowPattern(LX lx) {
    super(lx);
    addModulator(position).start();
  }
  void run(double deltaMs) {
    for (LED led : model.leds) {
      colors[led.index] = lx.hsb((position.getValuef() + led.rectTheta * 1.0 / LED.RECT_MAX * 360 * 6) % 360,
        100,
        100
      );
    }
  }
}

public class RainbowCandyPattern extends Pattern {

  RainbowCandyPattern(LX lx) {
    super(lx);
  }
  void run(double deltaMs) {
    for (LED led : model.leds) {
      colors[led.index] = lx.hsb((int)random(360), 100, 100);
    }
  }
}

public class ColorStrobePattern extends Pattern {

  ColorStrobePattern(LX lx) {
    super(lx);
  }
  void run(double deltaMs) {
    setColors(lx.hsb((int)random(360), 100, 100));
  }
}
