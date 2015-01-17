abstract public class Pattern extends LXPattern {

  final Model model;

  Pattern(LX lx, Model model) {
    super(lx);

    this.model = model;
  }
}

public class BasicPattern extends Pattern {

  final SawLFO position = new SawLFO(0, Model.NUM_LEDS, 8000);

  BasicPattern(LX lx, Model model) {
    super(lx, model);

    addModulator(position).start();
  }

  void run(double deltaMs) {
    for (LED led : model.leds) {
      colors[led.index] = lx.hsb(100,
        100,
        max(0, 100 - LXUtils.wrapdistf(led.rectTheta, position.getValuef(), Model.NUM_LEDS) * 100)
      );
    }
  }
}
