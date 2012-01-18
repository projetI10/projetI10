package examples {
	import com.transmote.flar.*;
	import com.transmote.flar.FLARManager;
	import com.transmote.flar.camera.FLARCamera_PV3D;
	import com.transmote.flar.marker.FLARMarker;
	import com.transmote.flar.marker.FLARMarkerEvent;
	import com.transmote.flar.tracker.*;
	import com.transmote.flar.tracker.FLARToolkitManager;
	import com.transmote.flar.utils.geom.PVGeomUtils;
	import com.transmote.utils.time.FramerateDisplay;
	
	import controls.*;
	
	import flash.display.*;
	import flash.events.*;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.geom.Rectangle;
	import flash.media.Camera;
	import flash.ui.Keyboard;
	import flash.utils.Timer;
	import flash.utils.setInterval;
	
	import models.*;
	
	import org.papervision3d.cameras.Camera3D;
	import org.papervision3d.core.render.sort.NullSorter;
	import org.papervision3d.lights.PointLight3D;
	import org.papervision3d.objects.DisplayObject3D;
	import org.papervision3d.objects.parsers.DAE;
	import org.papervision3d.render.LazyRenderEngine;
	import org.papervision3d.scenes.Scene3D;
	import org.papervision3d.view.Viewport3D;
	
	public class Main  extends Sprite  {
		private var flarManager:FLARManager;
		
		private var scene3D:Scene3D;// the 3D scene
		private var camera3D:Camera3D;// the cam that is present in the scene
		private var viewport3D:Viewport3D;// the view
		private var renderEngine:LazyRenderEngine;// the 3D engine
		private var pointLight3D:PointLight3D; //the light
		
		private var activeMarker:FLARMarker;
		private var modelContainer:DisplayObject3D;
		
		private var speedCar:Number= 0;
		private var rollingSpeed:Number = 10;
		private var velocity:Number;
		// And the rotation speed
		private var rotationSpeed:Number = 5;
		private var corpseCar:CorpseCarDAE; 
		private var rotatingWheel:RotatingWheelDAE; 
		private var bothWheels:BothWheelsDAE; 
		private var flagInput:Boolean = false; // detect if the user is typing
		private var flagMoveBack:Boolean = false; // detect if the car moved backward
		private var flagMoveForward:Boolean = false; // detect if the car moved forward
		private var timer:Timer;//this timer will detect if the car must be reinit
		
		private var keyboardState:Keyboard_State;// the class that will be used to simplify the keyboard interaction

		public function Main () {
			this.addEventListener(Event.ADDED_TO_STAGE, this.onAdded);//we load the stage in flash and we wait until its done
		}
		
		//when the user press a key we catch the code of the key pressed
		private function onKeyUp(pEvent:KeyboardEvent) :void
		{
			var code:uint = pEvent.keyCode;//we put this code into a variable
			keyboardState.handleKeyUp(code);// the keyboard class will handle the key in pressed
		}
		//when the key is released
		private function onKeyDown(pEvent:KeyboardEvent):void { 
			var code:uint = pEvent.keyCode;
			keyboardState.handleKeyDown(code);// handle the the key used
			this.renderEngine.render();//we refresh the view
		}
		
		private function onAdded (evt:Event) :void {
			this.removeEventListener(Event.ADDED_TO_STAGE, this.onAdded);// we remove the previous listener
			stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown); // we had keyboard listener
			stage.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);  
			// pass the path to the FLARManager xml config file into the FLARManager constructor.
			// FLARManager creates and uses a FLARCameraSource by default.
			// the image from the first detected camera will be used for marker detection.
			// also pass an IFLARTrackerManager instance to communicate with a tracking library,
			// and a reference to the Stage (required by some trackers).
			this.flarManager = new FLARManager("../resources/flar/flarConfig.xml", new FLARToolkitManager(), this.stage);
			
			// to switch tracking engines, pass a different IFLARTrackerManager into FLARManager.
			// refer to this page for information on using different tracking engines:
			// http://words.transmote.com/wp/inside-flarmanager-tracking-engines/
				//		this.flarManager = new FLARManager("../resources/flar/flarConfig.xml", new FlareManager(), this.stage);
			//			this.flarManager = new FLARManager("../resources/flar/flarConfig.xml", new FlareNFTManager(), this.stage);
			
			// add FLARManager.flarSource to the display list to display the video capture.
			this.addChild(Sprite(this.flarManager.flarSource));
			this.addChild(new FramerateDisplay()); //display the number of fps in real time
			// begin listening for FLARMarkerEvents.
			this.flarManager.addEventListener(FLARMarkerEvent.MARKER_ADDED, this.onMarkerAdded);
			this.flarManager.addEventListener(FLARMarkerEvent.MARKER_UPDATED, this.onMarkerUpdated);
			this.flarManager.addEventListener(FLARMarkerEvent.MARKER_REMOVED, this.onMarkerRemoved);
			
			// wait for FLARManager to initialize before setting up Papervision3D environment.
			this.flarManager.addEventListener(Event.INIT, this.onFlarManagerInited);
		}
		
		private function onFlarManagerInited (evt:Event) :void {
			this.flarManager.removeEventListener(Event.INIT, this.onFlarManagerInited);// remove the previous listener
			
			this.scene3D = new Scene3D();// initialize the 3d scene
			// init the view
			this.viewport3D = new Viewport3D(this.stage.stageWidth, this.stage.stageHeight);
			this.addChild(this.viewport3D);
			//init the camera
			this.camera3D = new FLARCamera_PV3D(this.flarManager, new Rectangle(0, 0, this.stage.stageWidth, this.stage.stageHeight));
			
			this.renderEngine = new LazyRenderEngine(this.scene3D, this.camera3D, this.viewport3D);
			stage.quality = StageQuality.BEST;
			this.pointLight3D = new PointLight3D();
			this.pointLight3D.x = 1000;
			this.pointLight3D.y = 1000;
			this.pointLight3D.z = -1000;
			keyboardState = new Keyboard_State(); // init the keyboard handler
			
			initModels();
			initContainer();
			initListeners();
		}
		private function initModels():void{
			// load the model.
			// (this model has to be scaled and rotated to fit the marker; every model is different.)
			corpseCar= new CorpseCarDAE(true, "corpseCar", true);
			corpseCar.load("../resources/assets/corpseCar.DAE");
			// then position the model
			corpseCar.rotationX = 90;
			corpseCar.rotationZ = -90;
			corpseCar.scale = 1.5;
			
			rotatingWheel= new RotatingWheelDAE(true, "rotatingWheel", true);
			rotatingWheel.load("../resources/assets/rotatingWheel.DAE");
			// then position the model
			rotatingWheel.rotationX = 90;
			rotatingWheel.rotationZ = -90;
			rotatingWheel.scale = 1.5;
			
			bothWheels= new BothWheelsDAE(true, "bothWheels", true);
			bothWheels.load("../resources/assets/bothWheels.DAE");
			// then position the model
			bothWheels.rotationX = 90;
			bothWheels.rotationZ = -90;
			bothWheels.z-=1;
			bothWheels.scale =1.5;
		}
		
		
		private function initContainer ():void {
			// create a container for the model, that will accept matrix transformations.
			this.modelContainer = new DisplayObject3D(); // we create the main container
			this.modelContainer.addChild(corpseCar);// and we add the model to the 3d scene
			this.modelContainer.addChild(rotatingWheel);// and we add the model to the 3d scene
			this.modelContainer.addChild(bothWheels);// and we add the model to the 3d scene
			
			this.modelContainer.visible = false; // we set the main container to invisible so we will only see the models
			
			
			this.scene3D.addChild(this.modelContainer);// and we add the container to the 3d scene
		}
		private function reInitModels(event:TimerEvent):void
		{
			trace("gg");
			
			corpseCar.rotationX = 90;
			corpseCar.rotationZ = -90;
			corpseCar.scale = 1.5;
			corpseCar.reInit();
			
			
			rotatingWheel.rotationX = 90;
			rotatingWheel.rotationZ = -90;
			rotatingWheel.scale = 1.5;
			rotatingWheel.reInit();
			
			bothWheels.rotationX = 90;
			bothWheels.rotationZ = -90;
			bothWheels.z-=1;
			bothWheels.scale =1.5;
			bothWheels.reInit();
		}
		private function initListeners():void {
			this.addEventListener(Event.ENTER_FRAME, this.onEnterFrame);//finally we had a listener for when
			//the container enter the frame
			//below are the listener for the keyboard input
			this.addEventListener(Event.COMPLETE,this.up);
			this.addEventListener(Event.COMPLETE,this.down);
			this.addEventListener(Event.COMPLETE,this.right);
			this.addEventListener(Event.COMPLETE,this.left);
			timer = new Timer(3000);
			timer.addEventListener(TimerEvent.TIMER,reInitModels);
		}
		
		private function onMarkerAdded (evt:FLARMarkerEvent) :void {
			//trace("["+evt.marker.patternId+"] added");
			this.modelContainer.visible = true;
			this.activeMarker = evt.marker;
			timer.stop();
		}
		
		private function onMarkerUpdated (evt:FLARMarkerEvent) :void {
			//trace("["+evt.marker.patternId+"] updated");
			this.modelContainer.visible = true;
			this.activeMarker = evt.marker;
		}
		
		private function onMarkerRemoved (evt:FLARMarkerEvent) :void {
			trace("["+evt.marker.patternId+"] removed");
			this.modelContainer.visible = false;
			this.activeMarker = null;
			timer.start();
		}
		
		private function up():void{
			if (keyboardState.getKeyUp())
			{
				if (flagMoveBack) speedCar /=4; // if the car was going backward 
				//decrease the speed so that the car doesn't go forward at fullspeed which would be illogical
				
				// If the key up is pressed set the new velocity to the speed value	
				if (speedCar < 8){//4 before 
					speedCar += 2;//increase the speed  1 before
				}
				velocity = speedCar;//set the velocity	
				bothWheels.RotateUp(rollingSpeed);//we make bothWheels roll for the animation
				flagInput = true;
				flagMoveBack = false;
				flagMoveForward = true;
			}
			down();
		}
		
		private function down():void{
			if (keyboardState.getKeyDown())
			{
				// If the key down is pressed set the new velocity to the half speed value
				if (flagMoveForward) speedCar /=4;
				velocity = -speedCar/2;
				if (speedCar < 8){
					speedCar += 2;
				}
				bothWheels.RotateDown(rollingSpeed);
				flagInput = true;
				flagMoveBack = true;
				flagMoveForward = false;
			}
			right();
		}
		
		private function right():void{
			if (keyboardState.getKeyRight())
			{
				if (speedCar > 1){
					bothWheels.RotateRight(rotationSpeed);
					corpseCar.RotateRight(rotationSpeed);
					rotatingWheel.RotateRight(rotationSpeed);
					flagInput = true;
				}
			}
			left();
		}
		
		private function left():void{
			
			if (keyboardState.getKeyLeft())
			{
				if (speedCar > 1){
					corpseCar.RotateLeft(rotationSpeed);
					rotatingWheel.RotateLeft(rotationSpeed);
					bothWheels.RotateLeft(rotationSpeed);
					flagInput = true;
				}
			}
		}
		
		private function deceleration():void{
			if (flagInput == false) // if we need to decelerate
			{
				if (flagMoveBack == true){// if the car goes backward
					speedCar /= 1.5;// decrease speed
					velocity = -speedCar;// we decelarate by letting the car moving slowly backward
				}
				else{//if the car goes forward
					speedCar /= 1.5;// decrease speed
					velocity = speedCar; //we decelarate by letting the car moving slowly forward
				}
			}
		}
		
		private function onEnterFrame (evt:Event) :void {
			if(this.activeMarker){
				// Set the default velocity to 0 if no key is pressed
				flagInput = false;
				up();
				deceleration();
				// Convert the degreeAngle to the radian angle
				var angleRadian:Number = corpseCar.rotationZ / 180 * Math.PI;
				y =  Math.sin(angleRadian) * velocity;
				x =  Math.cos(angleRadian) * velocity;
				// Move the object with the radian angle and the object speed
				rotatingWheel.move(x,y);
				corpseCar.move(x,y);
				bothWheels.move(x,y);
				this.modelContainer.transform = PVGeomUtils.convertMatrixToPVMatrix(this.activeMarker.transformMatrix);
			}
			
			// update the Papervision3D view.
			this.renderEngine.render();
		}
	}
}
