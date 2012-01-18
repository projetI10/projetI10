
package models
{
	import org.papervision3d.objects.parsers.DAE;
	public class CorpseCarDAE extends DAE
	{
		public function CorpseCarDAE(autoPlay:Boolean ,name:String ,loop:Boolean )
		{
			super(autoPlay, name, loop);
		}
		
		public function RotateLeft(rotationSpeed:Number):void{
			this.rotationZ -=  rotationSpeed;  //make a left turn
		}
		public function RotateRight(rotationSpeed:Number):void{
			this.rotationZ +=  rotationSpeed; //make a right turn 
		}
		public function move(x:Number,y:Number):void //move the model
		{
			this.y +=  y;
			this.x +=  x;
		}
		public function reInit():void //reInit the model
		{
			this.x = 0;
			this.y = 0;
		}
	}
}