package models
{
	import org.papervision3d.objects.parsers.DAE;
	
	public class RotatingWheelDAE extends DAE
	{
		public function RotatingWheelDAE(autoPlay:Boolean ,name:String ,loop:Boolean )
		{
			super(autoPlay, name, loop);
		}
		public function RotateLeft(rotationSpeed:Number):void{
			this.rotationZ -=  rotationSpeed; //make a left turn
		}
		public function RotateRight(rotationSpeed:Number):void{
			this.rotationZ +=  rotationSpeed; //make a right turn 
		}
		public function move(x:Number,y:Number):void
		{
			this.y +=  y;
			this.x +=  x;
		}
		public function reInit():void
		{
			this.x = 0;
			this.y = 0;
		}
	}
}