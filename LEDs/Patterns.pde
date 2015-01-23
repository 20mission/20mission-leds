abstract public class Pattern extends LXPattern {

  final Model model;

  Pattern(LX lx) {
    super(lx);

    this.model = (Model)lx.model;
  }
}

public class VolumePattern extends Pattern {

  VolumePattern(LX lx) {
    super(lx);
  }

  void run(double deltaMs) {
    println(microphone.volume);
    setColors(lx.hsb(100, 100, min(100, microphone.volume * 100)));
  }
}

public class LightsOffPattern extends Pattern {

  LightsOffPattern(LX lx) {
    super(lx);
  }

  void run(double deltaMs) {
    setColors(lx.hsb(0, 0, 0));
  }
}

public class LightsOnPattern extends Pattern {

  LightsOnPattern(LX lx) {
    super(lx);
  }

  void run(double deltaMs) {
    setColors(lx.hsb(0, 0, 100));
  }
}


public class MicrophonePulsePattern extends Pattern {

  private final int NUM_PULSES = 27;
  private final int PULSE_DISTANCE = LED.RECT_MAX / NUM_PULSES;

  final SinLFO speed = new SinLFO(40000, 1200000, 30000);
  final SawLFO position = new SawLFO(0, LED.RECT_MAX, speed);
  final SawLFO hue = new SawLFO(0, 360, 10000);

  MicrophonePulsePattern(LX lx) {
    super(lx);
    addModulator(speed).start();
    addModulator(position).start();
    addModulator(hue).start();
  }

  void run(double deltaMs) {
    for (LED led : model.leds) {
      colors[led.index] = lx.hsb(hue.getValuef(),
        100,
        max(0, min(100, 100 - max(0, (abs(((position.getValuef() + led.rectTheta) % PULSE_DISTANCE) - PULSE_DISTANCE / 2) - 1)) / microphone.volume * 100.0 / (PULSE_DISTANCE / 2)))
      );
    }
  }
}

public class FastMicrophonePulsePattern extends Pattern {

  private final int NUM_PULSES = 27;
  private final int PULSE_DISTANCE = LED.RECT_MAX / NUM_PULSES;

  final SinLFO speed = new SinLFO(2000, 10000, 10000);
  final SawLFO position = new SawLFO(0, LED.RECT_MAX, speed);
  final SawLFO hue = new SawLFO(0, 360, 10000);

  FastMicrophonePulsePattern(LX lx) {
    super(lx);
    addModulator(speed).start();
    addModulator(position).start();
    addModulator(hue).start();
  }

  void run(double deltaMs) {
    for (LED led : model.leds) {
      colors[led.index] = lx.hsb(hue.getValuef(),
        100,
        max(0, min(100, 100 - max(0, (abs(((position.getValuef() + led.rectTheta) % PULSE_DISTANCE) - PULSE_DISTANCE / 2) - 1)) / microphone.volume * 100.0 / (PULSE_DISTANCE / 2)))
      );
    }
  }
}

public class AntsPattern extends Pattern {

  private final int NUM_PULSES = 69;
  private final int PULSE_DISTANCE = LED.RECT_MAX / NUM_PULSES;

  final SinLFO speed = new SinLFO(1500, 4000, 10000);
  final SinLFO position = new SinLFO(0, PULSE_DISTANCE * 4, speed);
  final SawLFO hue = new SawLFO(0, 360, 10000);

  AntsPattern(LX lx) {
    super(lx);
    addModulator(speed).start();
    addModulator(position).start();
    addModulator(hue).start();
  }

  void run(double deltaMs) {
    for (LED led : model.leds) {
      colors[led.index] = lx.hsb(hue.getValuef(),
        100,
        max(0, min(100, 100 - max(0, ((position.getValuef() + led.rectTheta) % PULSE_DISTANCE) - PULSE_DISTANCE / 2) * 100.0 / (PULSE_DISTANCE / 2)))
      );
      // println((led.rectTheta % (LED.RECT_MAX / NUM_PULSES)) - LED.RECT_MAX / NUM_PULSES / 2);
    }
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
      colors[led.index] = lx.hsb(random(360), 100, 100);
    }
  }
}

public class FadePattern extends Pattern {

  final SawLFO hue = new SawLFO(0, 360, 10000);

  FadePattern(LX lx) {
    super(lx);
    addModulator(hue).start();
  }
  void run(double deltaMs) {
    setColors(lx.hsb(hue.getValuef(), 100, 100));
  }
}

public class CrazyColorStrobePattern extends Pattern {

  CrazyColorStrobePattern(LX lx) {
    super(lx);
  }
  void run(double deltaMs) {
    setColors(lx.hsb(random(360), 100, 100));
  }
}

public class ColorStrobePattern extends Pattern {

  final SinLFO speed = new SinLFO(200, 800, 20000);
  final SquareLFO on = new SquareLFO(0, 100, speed);
  float hue;

  ColorStrobePattern(LX lx) {
    super(lx);
    addModulator(speed).start();
    addModulator(on).start();
  }
  void run(double deltaMs) {
    if (on.getValuef() == 0) {
      hue = random(360);
    }
    setColors(lx.hsb(hue, 100, on.getValuef()));
  }
}

public class StrobePattern extends Pattern {

  final SinLFO speed = new SinLFO(100, 200, 10000);
  final SquareLFO on = new SquareLFO(0, 100, speed);

  StrobePattern(LX lx) {
    super(lx);
    addModulator(speed).start();
    addModulator(on).start();
  }
  void run(double deltaMs) {
    setColors(lx.hsb(0, 0, on.getValuef()));
  }
}

public class TestPixelPattern extends Pattern {
  TestPixelPattern(LX lx) {
    super(lx);
  }

  void run(double deltaMs) {
    for (LED led : model.leds) {
      if (led.index == 0) {
        colors[led.index] = lx.hsb(100, 100, 100);
      } else {
        colors[led.index] = lx.hsb(100, 100, 10);
      }
    }
  }
}
