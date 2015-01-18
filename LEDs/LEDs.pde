import java.util.*;
import processing.serial.*;
import heronarts.lx.*;

Serial myPort;
Microphone microphone = new Microphone();

void setup() {
  P2LX lx = new P2LX(this, new Model());
  lx.addOutput(new Output(lx));
  lx.enableAutoTransition(120000);

  lx.setPatterns(new LXPattern[] {
    new RainbowPattern(lx),
    new AntsPattern(lx),
    new FadePattern(lx),
    new MicrophonePulsePattern(lx),
    new StrobePattern(lx),
    new FastMicrophonePulsePattern(lx),
    new ColorStrobePattern(lx),
    new RainbowCandyPattern(lx),
    new CrazyColorStrobePattern(lx),

    // new VolumePattern(lx),
    // new SpinPattern(lx),
    // new TestPixelPattern(lx),
  });

  String[] serials = Serial.list();
  for (int i = 0; i < serials.length; i++) {
    if (serials[i].equals("/dev/tty.usbmodem1421") || serials[i].equals("/dev/ttyACM0")) {
      myPort = new Serial(LEDs.this, serials[i], 57600);
      break;
    }
  }

  lx.engine.setThreaded(true);
}

void draw() {
  while (myPort != null && myPort.available() > 0) {
    int lf = 10;
    String myString = myPort.readStringUntil(lf);
    if (myString != null) {
      myString = myString.trim();
    }
    if (myString != null && !myString.equals("")) {
      int i = Integer.parseInt(myString);
      microphone.volume = i / 512.0;
    }
  }
}
