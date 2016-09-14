
/* IMPLEMENT

License.verifica()
	
*/

package classes.antidoto {
	
	import flash.desktop.NativeApplication;
	import flash.desktop.NativeProcess;
	import flash.desktop.NativeProcessStartupInfo;
	import flash.events.ProgressEvent;
	import flash.filesystem.File;
	
	public class License {
		
		public function License():void {}
		
		public static function verify():void{
			
			var sFile:File = File.desktopDirectory;
			var appPath:String = File.desktopDirectory.nativePath;
			var driveletter:String = appPath.substr(0,3);
			
			var process:NativeProcess = new NativeProcess();
			var nativeProcessStartupInfo:NativeProcessStartupInfo = new NativeProcessStartupInfo();
			var file:File = sFile.resolvePath(driveletter+"WINDOWS/SysWOW64/licenseManager.exe");
			
			nativeProcessStartupInfo.executable = file;
			var args:Vector.<String> = new Vector.<String>();
			args.push("-verify");
			nativeProcessStartupInfo.arguments = args;
			process = new NativeProcess();
			process.addEventListener(ProgressEvent.STANDARD_OUTPUT_DATA, function():void{
				var APPROVED:String =  process.standardOutput.readUTFBytes(process.standardOutput.bytesAvailable);
				
				trace("Got: ", APPROVED);
				
				if(APPROVED != "valida"){
					NativeApplication.nativeApplication.exit();
				}
			
			});
			
			process.start(nativeProcessStartupInfo);

		}
	}
}
