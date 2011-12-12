package {
	import examples.*;
	
	import flash.display.Sprite;

	[SWF(width="640", height="480", frameRate="60", backgroundColor="#FFFFFF")]
	public class FLARManagerExampleLauncher extends Sprite {
		
		public function FLARManagerExampleLauncher () {
			this.addChild(new FLARManagerTutorial_Collada_PV3D());
			
		}
	}
}