package models
{
	import org.papervision3d.objects.parsers.DAE;
	public class BothWheelsDAE extends DAE
	{
		public function BothWheelsDAE(autoPlay:Boolean ,name:String ,loop:Boolean )
		{
			super(autoPlay, name, loop);
		}
		public function RotateUp(rollingSpeed:Number):void{
			this.rotationY+= rollingSpeed;//animate both wheels going forward
		}
		public function RotateDown(rollingSpeed:Number):void{
			this.rotationY-= rollingSpeed;//animate both wheels going backward
		}
		public function RotateLeft(rotationSpeed:Number):void{
			this.rotationZ -=  rotationSpeed; //make a right turn 
		}
		public function RotateRight(rotationSpeed:Number):void{
			this.rotationZ +=  rotationSpeed; //make a left turn
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