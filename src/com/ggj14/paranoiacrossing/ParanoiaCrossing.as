package com.ggj14.paranoiacrossing {
	import com.ggj14.paranoiacrossing.collision.CollisionMap;
	import com.ggj14.paranoiacrossing.events.ParanoiaCrossingEvent;
	import com.ggj14.paranoiacrossing.mainmenu.MainMenu;
	import com.ggj14.paranoiacrossing.util.RandomPlus;

	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.media.SoundMixer;
	import flash.media.SoundTransform;
	import flash.net.URLRequest;

	[SWF(width="1440", height="960", frameRate="30", backgroundColor="#000000")]
	public class ParanoiaCrossing extends Sprite {
		private const characterNames : Array = ["Adam", "Ashley", "Billy", "Brian", "Dave", "Dennis"];//, "Diana", "Geoff", "Jennifer", "Jessica", "Katie", "Kerry", "Mort", "Pat", "Rich", "Scooter", "Shmebulock", "Susan", "Tifa", "Tom"];
		// the assets location
		public static const assetsLocation : String = "/Users/jamie/Documents/workspace/actionscript/ParanoiaCrossing/assets/";
		// map of the town
		private var townBackground : Bitmap;
		private var townBackgroundLoader : Loader = new Loader();
		// the map for collision
		public static var collisionMap : CollisionMap = new CollisionMap();
		// the characters
		public static var npcs : Array = new Array();
		private static const numNPCS : uint = 6;
		private var numNPCSLoaded : uint = 0;
		private const playerStartX : uint = 600;
		private const playerStartY : uint = 600;
		private var _player : Player;
		public static var _winningHouse : uint;
		public static var sceneCharacters:Vector.<String> = new Vector.<String>();
		private var _popup : PopUp = new PopUp();
		private var _finishedGamePopup : FinishedGamePopup = new FinishedGamePopup();

		public function ParanoiaCrossing() {
			stage.scaleMode = StageScaleMode.EXACT_FIT;
			stage.align = StageAlign.TOP_LEFT;

			SoundMixer.soundTransform = new SoundTransform(0.7);
			SoundManager.initSounds();

			townBackgroundLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, onBackgroundLoaded);
			townBackgroundLoader.load(new URLRequest(assetsLocation + "paranoia.png"));
		}

		private function onBackgroundLoaded(event : Event) : void {
			// add the collision map
			addChild(collisionMap);

			// load the town background
			townBackground = Bitmap(townBackgroundLoader.content);
			addChild(townBackground);

			// load the main menu for the first time
			var mainMenu : MainMenu = new MainMenu();
			addChild(mainMenu);

			// initialise the main menu
			mainMenu.init();

			// listen for the press to play the game
			mainMenu.addEventListener(ParanoiaCrossingEvent.START_GAME, onStartGame);
		}

		private function onStartGame(event : ParanoiaCrossingEvent) : void {
			// create the NPC's
			createNPCS();

			_player = new Player(null);
			_player.x = playerStartX;
			_player.y = playerStartY;
			addChild(_player);

			_player.addEventListener(ParanoiaCrossingEvent.SHOW_POP_UP, onShowPopup);
			_player.addEventListener(ParanoiaCrossingEvent.HIDE_POP_UP, onHidePopup);

			_popup.visible = false;
			stage.addChild(_popup);
			
			// winner popup
			// addFinishedGamePopup(false, []);
		}

		private function onHidePopup(event : ParanoiaCrossingEvent) : void {
			_popup.visible = false;
		}

		private function onShowPopup(event : ParanoiaCrossingEvent) : void {
			_popup.visible = true;
		}

		private function createNPCS() : void 
		{
			var rand : RandomPlus = new RandomPlus(0, characterNames.length);
			for (var i : int = 0; i < numNPCS; i++) 
			{
				npcs.push(new Character(characterNames[i]));
				sceneCharacters.push(characterNames[i]);
				addChild(npcs[i]);
				npcs[i].addEventListener(ParanoiaCrossingEvent.CHARACTER_LOADED, onCharacterLoaded);
			}

//			var chat : ConversationManager = new ConversationManager();
//			this.stage.addChild(chat);
//			chat.x = (this.stage.stageWidth - chat.width) * 0.5;
//			chat.y = this.stage.stageHeight - chat.height - 10;
//			chat.startConversation();
		}

		private function onCharacterLoaded(event : ParanoiaCrossingEvent) : void {
			event.stopImmediatePropagation();
			Character(event.target).removeEventListener(ParanoiaCrossingEvent.CHARACTER_LOADED, onCharacterLoaded);

			numNPCSLoaded++;

			if (numNPCSLoaded == numNPCS) 
			{
				for(var i:int = 0; i < numNPCS; i++)
				{
					npcs[i].buildConversation();
				}
				assignWinningHouse();
				// when the game starts create the player
				_player = new Player(null);
				_player.x = playerStartX;
				_player.y = playerStartY;
				addChild(_player);
			
				if(contains(_finishedGamePopup) && _finishedGamePopup.visible) {
					setChildIndex(_finishedGamePopup, numChildren - 1);
				}

				numNPCSLoaded = 0;
			}
		}

		private function assignWinningHouse() : void {
			var r : RandomPlus = new RandomPlus(1, 6);
			_winningHouse = r.getNum();
		}

		private function restartGame() : void {
			for each (var char : Character in npcs) {
				removeChild(char);
				char.dispose();
				char = null;
			}

			removeChild(_player);
			_player = null;

			// when the game starts create the player
			_player = new Player(null);
			_player.x = playerStartX;
			_player.y = playerStartY;
			addChild(_player);
		}
		
		private function addFinishedGamePopup(success : Boolean, characterArray : Array) : void {
			_finishedGamePopup.addGameData(success, npcs);
			addChildAt(_finishedGamePopup, numChildren - 1);
		}
	}
}
