package {
	import examples.*;
	
	import flash.display.Sprite;

	[SWF(width="640", height="480", frameRate="60", backgroundColor="#FFFFFF")]
	public class Launcher extends Sprite {
		
		public function Launcher () {
			this.addChild(new Main());
			
		}
	}
}