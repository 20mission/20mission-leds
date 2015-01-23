import java.util.*;
import heronarts.lx.*;
import jssc.*;
import processing.net.*;

//serialport is connected to an arduino micro which runs at 3.3v and acts as an ADC for the microphone.  It reports back the peak mic signal every 50ms.
SerialPort serialPort;
Microphone microphone = new Microphone();

//server to set which pattern to show
Server server;

P2LX lx;



void setup() {
  
  lx = new P2LX(this, new Model());
  lx.addOutput(new Output(lx));
  lx.enableAutoTransition(120000);

  lx.setPatterns(new LXPattern[] {
    new LightsOffPattern(lx)
  });
/*
  lx.setPatterns(new LXPattern[] {
    new RainbowPattern(lx),
    new AntsPattern(lx),
    new FadePattern(lx),
    new MicrophonePulsePattern(lx),
    // new StrobePattern(lx),
    // new FastMicrophonePulsePattern(lx),
    // new ColorStrobePattern(lx),
    new RainbowCandyPattern(lx),

    // new CrazyColorStrobePattern(lx),
    // new VolumePattern(lx),
    // new SpinPattern(lx),
    // new TestPixelPattern(lx),
  });*/

  lx.addEffect(new TurnOffDeadPixelEffect(lx));

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
  
  server = new Server(this, 2973);
}

void draw() {
  
 thread("checkMic");
 thread("checkServer");
  
}

void checkMic(){
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
        if (myString != null) {
          myString = myString.trim();
          if (myString != null && !myString.equals("")) {
            int i = Integer.parseInt(myString);
            microphone.volume = i / 512.0;
          }
        }
      }
    } 
  }else{
    microphone.volume = random(1,100) / 100.0;
  }
}

void checkServer(){
   if (server != null){
    // Get the next available client
    Client thisClient = server.available();
    // If the client is not null, and says something, display what it said
    if (thisClient !=null) {
      String whatClientSaid = thisClient.readString();
      if (whatClientSaid != null) {
        println(thisClient.ip() + "\t" + whatClientSaid);
        changeMode(whatClientSaid);
      } 
    }
  }
}


void changeMode(String mode){
  mode = mode.trim();
  System.out.println("mode is: *"+mode+"*");
  if (mode.equals("off")){ 
    println("turned off");
    lx.setPatterns(new LXPattern[] {
      new LightsOffPattern(lx)
    });
  }else if (mode.equals("on")){ 
    println("turned on");
    lx.setPatterns(new LXPattern[] {
      new LightsOnPattern(lx)
    });
  }else if (mode.equals("mic")){ 
    println("turned on microphone");
    lx.setPatterns(new LXPattern[] {
      new MicrophonePulsePattern(lx)
    });
  }
}


public class TurnOffDeadPixelEffect extends LXEffect {
  public TurnOffDeadPixelEffect(LX lx) {
    super(lx);
  }
  void run(double deltaMs) {
    colors[1187] = 0;
  }
}
