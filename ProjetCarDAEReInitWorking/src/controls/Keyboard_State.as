package controls
{ 
	import org.papervision3d.core.render.sort.NullSorter;

	public class Keyboard_State
	{
		private var keyUp:Boolean;
		private var keyDown:Boolean;
		private var keyLeft:Boolean;
		private var keyRight:Boolean;
		
		public function Keyboard_State()
		{
			keyUp = false;
			keyDown = false;
			keyLeft = false;
			keyRight = false;
		}
		
		public function handleKeyUp(keyCode:uint):void
		{
			trace(keyCode);
			if (keyCode == 38)
			{
				this.setKeyUp(false);
			}
			else if (keyCode == 40)
			{
				this.setKeyDown(false);
			}
			else if (keyCode == 37)
			{
				this.setKeyLeft(false);
			}
			else if (keyCode == 39)
			{
				this.setKeyRight(false);
			}
		}
		public function handleKeyDown(keyCode:uint):void
		{
			if (keyCode == 38)
			{
				this.setKeyUp(true);
			}
			else if (keyCode == 40)
			{
				this.setKeyDown(true);
			}
			else if (keyCode == 37)
			{
				this.setKeyLeft(true);
			}
			else if (keyCode == 39)
			{
				this.setKeyRight(true);
			}
	}
		public function getKeyUp():Boolean
		{
			return this.keyUp;	
		}
		public function getKeyDown():Boolean
		{
			return this.keyDown;	
		}
		public function getKeyLeft():Boolean
		{
			return this.keyLeft;
		}
		public function getKeyRight():Boolean
		{
			return this.keyRight;
		}
		public function setKeyUp(value:Boolean):void
		{
			this.keyUp = value;
		}
		public function setKeyDown(value:Boolean):void
		{
			this.keyDown = value;
		}
		public function setKeyLeft(value:Boolean):void
		{
			this.keyLeft = value;
		}
		public function setKeyRight(value:Boolean):void
		{
			this.keyRight = value;
		}
	}
}