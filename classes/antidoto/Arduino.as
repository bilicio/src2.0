package classes.antidoto {
	
	import com.quetwo.Arduino.ArduinoConnector;
	import com.quetwo.Arduino.ArduinoConnectorEvent;
	
	import flash.desktop.NativeProcess;
	import flash.desktop.NativeProcessStartupInfo;
	import flash.events.EventDispatcher;
	import flash.events.ProgressEvent;
	import flash.filesystem.File;

	public class Arduino extends EventDispatcher{
		
		private var process:NativeProcess = new NativeProcess();
		private var nativeProcessStartupInfo:NativeProcessStartupInfo = new NativeProcessStartupInfo();
		
		private var sFile:File = File.desktopDirectory;
		private var appPath:String = File.desktopDirectory.nativePath;
		private var driveletter:String = appPath.substr(0,3);
		
		private var file:File = sFile.resolvePath(driveletter+"WINDOWS/SysWOW64/GetCom.exe");
		private var arduino:ArduinoConnector;
		
		private var com:*;
		
		public function Arduino() {

			nativeProcessStartupInfo.executable = file;
			process = new NativeProcess();
			process.addEventListener(ProgressEvent.STANDARD_OUTPUT_DATA, onOutputData);
			process.start(nativeProcessStartupInfo);
		}
		
		private function onOutputData(evt:ProgressEvent = null):void{
			com =  process.standardOutput.readUTFBytes(process.standardOutput.bytesAvailable);
			trace("[GetCom] Arduino na porta: ", com); 
			arduino = new ArduinoConnector();
			arduino.connect(com,9600);

			arduino.addEventListener("socketData", receiveData);

			this.dispatchEvent(new propagaEvento(propagaEvento.CONNECTED, {l:""}));
			
		}
		
		private function receiveData(evt:ArduinoConnectorEvent):void{
			//------------------------------------------------------------------ | Remove espaços em branco na variável
			var spaces:RegExp = /\s/g; // match "spaces" in a string
			//var dashes:RegExp = /-/gi; // match "dashes" in a string
			
			var str:String = arduino.readBytesAsString();
			str = str.replace(spaces, ""); // find and replace "spaces"
			//str = str.replace(dashes, ":"); // find and replace "dashes"
			
			this.dispatchEvent(new propagaEvento(propagaEvento.ARDUINORESPONSE, {response:str}));
		}
		
		public function sendData(data):void{
			arduino.writeString(data);
		}
		
		public function dispose():void{
			try{
				arduino.flush();
				arduino.close();
				arduino.dispose();
				arduino = null;
			}catch(err){};
			
		}
		
	}

}


