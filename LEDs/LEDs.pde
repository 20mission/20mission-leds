import java.util.*;
import heronarts.lx.*;
import jssc.*;

SerialPort serialPort;
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

  for (String serialName : SerialPortList.getPortNames()) {
    if (serialName.equals("/dev/tty.usbmodem1421") || serialName.equals("/dev/ttyACM0")) {
      serialPort = new SerialPort(serialName);
      try {
        serialPort.openPort();//Open serial port
        serialPort.setParams(SerialPort.BAUDRATE_9600, 
                             SerialPort.DATABITS_8,
                             SerialPort.STOPBITS_1,
                             SerialPort.PARITY_NONE);//Set params. Also you can set params by this string: serialPort.setParams(9600, 8, 1, 0);
      } catch (SerialPortException ex) {
        System.out.println(ex);
      }
      break;
    }
  }

  lx.engine.setThreaded(true);
}

void draw() {
  if (serialPort != null) {
    String inputString = null;
    try {
      inputString = serialPort.readString();
    } catch (SerialPortException ex) {
      System.out.println(ex);
    }
    if (inputString != null) {
      String[] inputArray = inputString.split("\r\n");
      if (inputArray.length > 0) {
        String myString = inputArray[0];
        if (myString != null && !myString.equals("")) {
          int i = Integer.parseInt(myString);
          microphone.volume = i / 512.0;
        }
      }
    } 
  }
}
