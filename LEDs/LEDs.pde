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

//String patternList[] = {"Volume", "LightsOff", "LightsOn", "MicrophonePulse", "FastMicrophonePulse", "Ants", "Spin", "Rainbow", "RainbowCandy", "Fade", "CrazyColorStrobe", "ColorStrobe", "Strobe", "TestPixel"};
//Class<?> patternObjects[] = {VolumePattern.class, LightsOffPattern.class, LightsOnPattern.class, MicrophonePulsePattern.class, FastMicrophonePulsePattern.class, AntsPattern.class, SpinPattern.class, RainbowPattern.class, RainbowCandyPattern.class, FadePattern.class, CrazyColorStrobePattern.class, ColorStrobePattern.class, StrobePattern.class, TestPixelPattern.class};


String camelize(String s){
  String t[] = s.split("_");
  String result = "";
  for(int x = 0; x < t.length; x++){
    String token = t[x];
    result += token.substring(0,1).toUpperCase()+token.substring(1);
  }
  return result;
}


void setup() {
  
  lx = new P2LX(this, new Model());
  lx.addOutput(new Output(lx));
  //lx.enableAutoTransition(120000);

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
        processCommand(whatClientSaid);
      } 
    }
  }
}


void processCommand(String command){
  command = command.trim();
  System.out.println("command is: *"+command+"*");
  String cmd[] = command.toLowerCase().split(" ");
  
  //return if command length is <= 1 because no valid commands have less than 2 arguments
  if (cmd.length < 2){
    println("error: cmd length is "+cmd.length+", exiting!"); 
    return;
  }
  
  if (cmd[0].equals("set")){
    if (cmd[1].equals("pattern")){
      
      String pattern = camelize(cmd[2]);
      println("Pattern changing to: "+pattern);

      //String patternList[] = {"Volume", "LightsOff", "LightsOn", "MicrophonePulse", "FastMicrophonePulse", "Ants", "Spin", "Rainbow", "RainbowCandy", "Fade", "CrazyColorStrobe", "ColorStrobe", "Strobe", "TestPixel"};
      if(pattern.equals("Volume")){
        lx.setPatterns(new LXPattern[] {
          new VolumePattern(lx)
        });
        return;
      }  
      if(pattern.equals("LightsOff")){
        lx.setPatterns(new LXPattern[] {
          new LightsOffPattern(lx)
        });
        return;
      }
      if(pattern.equals("LightsOn")){
        lx.setPatterns(new LXPattern[] {
          new LightsOnPattern(lx)
        });
        return;
      }
      if(pattern.equals("MicrophonePulse")){
        lx.setPatterns(new LXPattern[] {
          new MicrophonePulsePattern(lx)
        });
        return;
      }
      if(pattern.equals("FastMicrophonePulse")){
        lx.setPatterns(new LXPattern[] {
          new FastMicrophonePulsePattern(lx)
        });
        return;
      }
      if(pattern.equals("Ants")){
        lx.setPatterns(new LXPattern[] {
          new AntsPattern(lx)
        });
        return;
      }
      if(pattern.equals("Spin")){
        lx.setPatterns(new LXPattern[] {
          new SpinPattern(lx)
        });
        return;
      }
      if(pattern.equals("Rainbow")){
        lx.setPatterns(new LXPattern[] {
          new RainbowPattern(lx)
        });
        return;
      }
      if(pattern.equals("RainbowCandy")){
        lx.setPatterns(new LXPattern[] {
          new RainbowCandyPattern(lx)
        });
        return;
      }
      if(pattern.equals("Fade")){
        lx.setPatterns(new LXPattern[] {
          new FadePattern(lx)
        });
        return;
      }
      if(pattern.equals("CrazyColorStrobe")){
        lx.setPatterns(new LXPattern[] {
          new CrazyColorStrobePattern(lx)
        });
        return;
      }
      if(pattern.equals("ColorStrobe")){
        lx.setPatterns(new LXPattern[] {
          new ColorStrobePattern(lx)
        });
        return;
      }
      if(pattern.equals("Strobe")){
        lx.setPatterns(new LXPattern[] {
          new StrobePattern(lx)
        });
        return;
      }
      if(pattern.equals("TestPixel")){
        lx.setPatterns(new LXPattern[] {
          new TestPixelPattern(lx)
        });
        return;
      }
      
      
    }
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
