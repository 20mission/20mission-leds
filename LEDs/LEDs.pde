import heronarts.lx.*;
import java.util.*;

void setup() {
  boolean headless = false;
  for (String arg : args) {
    if (arg.equals("--headless")) {
      headless = true;
    }
  }
  if (headless) {
    noLoop();
  }

  Model model = new Model();
  P2LX lx = new P2LX(this, model);

  lx.setPatterns(new LXPattern[] {
    new RainbowCandyPattern(lx),
    new ColorStrobePattern(lx),
    new RainbowPattern(lx),
    new SpinPattern(lx)
  });
  for (LXPattern pattern : lx.engine.getFocusedChannel().getPatterns()) {
    pattern.setTransition(new DissolveTransition(lx).setDuration(1000));
  }
  // lx.engine.getFocusedChannel().getFader().setValue(1);

  Output output = new Output(lx);
  lx.addOutput(output);
  
  lx.engine.setThreaded(true);
}
