package classes.antidoto {
	import flash.desktop.NativeProcess;
	import flash.events.EventDispatcher;
	import flash.filesystem.File;
	import flash.desktop.NativeProcessStartupInfo;
	import flash.events.NativeProcessExitEvent;
	import flash.events.ProgressEvent;
	
	public class Comunicador extends EventDispatcher {
		
		private var serialReadProcess:NativeProcess;
		private var serialReadInfo:NativeProcessStartupInfo;
		
		private var serialReadCleanupProcess:NativeProcess;
		private var serialReadCleanUpInfo:NativeProcessStartupInfo;
		
		private var comunicadorPath:String;
		
		private var file:File;
		
		public function Comunicador(comPath:String) {
			
			comunicadorPath = comPath;
			file = new File().resolvePath(comPath);
			
			serialReadCleanUpInfo = new NativeProcessStartupInfo();
			serialReadCleanUpInfo.executable = file;
			
			var procArgs:Vector.<String> = new Vector.<String>();
			procArgs.push("cleanup");
			
			serialReadCleanUpInfo.arguments = procArgs;
			
			serialReadCleanupProcess = new NativeProcess();	
			serialReadCleanupProcess.addEventListener(NativeProcessExitEvent.EXIT, cleanupCompleto);
			serialReadCleanupProcess.start(serialReadCleanUpInfo);
		}

		private function cleanupCompleto(evt:NativeProcessExitEvent):void
		{
			serialReadCleanupProcess.removeEventListener(NativeProcessExitEvent.EXIT, cleanupCompleto);
			serialReadCleanupProcess = null;
			serialReadCleanUpInfo = null;
			
			iniciaLeitorSerial();
		}
		
		private function iniciaLeitorSerial():void
		{
			serialReadInfo = new NativeProcessStartupInfo();
			serialReadInfo.executable = file;
			
			serialReadProcess = new NativeProcess();
			serialReadProcess.addEventListener(ProgressEvent.STANDARD_OUTPUT_DATA, infoSerialRecebida);
			serialReadProcess.start(serialReadInfo);
		}

		private function infoSerialRecebida(evt:ProgressEvent):void
		{			
			var serialEvent:ComunicadorEvent = new ComunicadorEvent(ComunicadorEvent.LEITURA_RECEBIDA);
			serialEvent.leitura = serialReadProcess.standardOutput.readUTFBytes(serialReadProcess.standardOutput.bytesAvailable);
			dispatchEvent(serialEvent);
		}
		
	}
	
}
