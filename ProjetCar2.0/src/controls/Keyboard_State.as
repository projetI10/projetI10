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
			trace("insta");
			keyUp = false;
			keyDown = false;
			keyLeft = false;
			keyRight = false;
		}
		
		public function handleKeyUp(keyCode:uint)
		{
			trace(keyCode);
			if (keyCode == 38)
			{
				this.keyUp = false;
			}
			else if (keyCode == 40)
			{
				this.keyDown = false;
			}
			else if (keyCode == 37)
			{
				this.keyLeft = false;
			}
			else if (keyCode == 39)
			{
				this.keyRight = false;
			}
		}
		public function handleKeyDown(keyCode:uint)
		{
			if (keyCode == 38)
			{
				this.keyUp = true;
			}
			else if (keyCode == 40)
			{
				this.keyDown = true;
			}
			else if (keyCode == 37)
			{
				this.keyLeft = true;
			}
			else if (keyCode == 39)
			{
				this.keyRight = true;
			}
	}
		public function getKeyUp()
		{
			return this.keyUp;	
		}
		public function getKeyDown()
		{
			return this.keyDown;	
		}
		public function getKeyLeft()
		{
			return this.keyLeft;
		}
		public function getKeyRight()
		{
			return this.keyRight;
		}
		public function setKeyUp(value:Boolean)
		{
			this.keyUp = value;
		}
		public function setKeyDown(value:Boolean)
		{
			this.keyDown = value;
		}
		public function setKeyLeft(value:Boolean)
		{
			this.keyLeft = value;
		}
		public function setKeyRight(value:Boolean)
		{
			this.keyRight = value;
		}
	}
}