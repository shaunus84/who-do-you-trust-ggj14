package com.ggj14.paranoiacrossing {
	import flash.events.MouseEvent;

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
	import flash.filters.GlowFilter;
	import flash.media.SoundMixer;
	import flash.media.SoundTransform;
	import flash.net.URLRequest;
	import flash.text.AntiAliasType;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;

	[SWF(width="1440", height="960", frameRate="30", backgroundColor="#000000")]
	public class ParanoiaCrossing extends Sprite {
		private const characterNames : Array = ["Adam", "Ashley", "Billy", "Brian", "Dave", "Dennis", "Diana", "Shmebulock", "Susan", "Tom"];
		// , "Diana", "Geoff", "Jennifer", "Jessica", "Katie", "Kerry", "Mort", "Pat", "Rich", "Scooter", "Shmebulock", "Susan", "Tifa", "Tom"];
		// the assets location
		public static const assetsLocation : String = "/Users/shaunmitchell/Documents/ggj/Paranoia Crossing/assets/";
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
		public static var sceneCharacters : Vector.<String> = new Vector.<String>();
		private var _popup : PopUp = new PopUp();
		private var _finishedGamePopup : FinishedGamePopup = new FinishedGamePopup();
		public static var tableOfTruth : Array = new Array();
		
		private var _tipBoard : Sprite = new Sprite();
		private var _tipBoardBackground : TipBoardBackground = new TipBoardBackground();
		private var _headingFont : Font043B0Regular = new Font043B0Regular();
		private var _headingFormat : TextFormat = new TextFormat();
		private var _bodyFont : FontRespectiveRegular = new FontRespectiveRegular();
		private var _bodyFormat : TextFormat = new TextFormat();

		public function ParanoiaCrossing() {
			stage.scaleMode = StageScaleMode.EXACT_FIT;
			stage.align = StageAlign.TOP_LEFT;

			SoundMixer.soundTransform = new SoundTransform(0.7);
			SoundManager.initSounds();

			townBackgroundLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, onBackgroundLoaded);
			townBackgroundLoader.load(new URLRequest(assetsLocation + "paranoia.png"));
			
			_tipBoard.addChild(_tipBoardBackground);
			addChild(_tipBoard);
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
			assignWinningHouse();
			// create the NPC's
			createNPCS();

			_player = new Player(null);
			_player.x = playerStartX;
			_player.y = playerStartY;
			addChild(_player);

			_player.addEventListener(ParanoiaCrossingEvent.SHOW_POP_UP, onShowPopup);
			_player.addEventListener(ParanoiaCrossingEvent.HIDE_POP_UP, onHidePopup);
			_player.addEventListener(ParanoiaCrossingEvent.SHOW_TIP_BOARD, onShowTipBoard);

			_popup.visible = false;
			stage.addChild(_popup);

			_popup.yesButton.addEventListener(MouseEvent.CLICK, onHouseChosen);
		}

		private function onHouseChosen(event : MouseEvent) : void {
			_player.removeEventListener(ParanoiaCrossingEvent.SHOW_POP_UP, onShowPopup);
			_player.removeEventListener(ParanoiaCrossingEvent.HIDE_POP_UP, onHidePopup);
			_popup.yesButton.removeEventListener(MouseEvent.CLICK, onHouseChosen);
			if (_player.currentHouse == _winningHouse) {
				addFinishedGamePopup(true, npcs);
			} else {
				addFinishedGamePopup(false, npcs);
			}

			_popup.visible = false;
		}

		private function populateTipBoard() : void {
			_headingFormat = new TextFormat();
			_headingFormat.color = 0x333333;
			_headingFormat.font = _headingFont.fontName;
			_headingFormat.align = TextFormatAlign.CENTER;
			_headingFormat.size = 30;
			
			_bodyFormat = new TextFormat();
			_bodyFormat.size = 60;
			_bodyFormat.align = TextFormatAlign.CENTER;
			_bodyFormat.color = 0x000000;
			_bodyFormat.font = _bodyFont.fontName;
			
			var headingText : TextField = new TextField();
			headingText.width = _tipBoard.width;
			headingText.antiAliasType = AntiAliasType.ADVANCED;
			headingText.defaultTextFormat = _headingFormat;
			headingText.text = "A QUICK TIP...";
			headingText.y = _tipBoard.height >> 3;
			
			var bodyText : TextField = new TextField();
			bodyText.width = _tipBoard.width;
			bodyText.antiAliasType = AntiAliasType.ADVANCED;
			bodyText.height = _tipBoard.height;
			bodyText.defaultTextFormat = _bodyFormat;
			bodyText.y = (_tipBoard.height - bodyText.textHeight) >> 1;
			bodyText.wordWrap = true;
			bodyText.multiline = true;
			
			var numFalse : int;
			var numTruth : int;
			for each(var character : Boolean in tableOfTruth) {
				if(character) numTruth++;
				else numFalse++;
			}
			
			bodyText.text = "We thought you should know, there are " + numTruth + " people \rtelling the truth, and " + numFalse + " people lying to you.";  
			
			_tipBoard.addChild(headingText);
			_tipBoard.addChild(bodyText);
		}

		private function onShowTipBoard(event : ParanoiaCrossingEvent) : void {
			if(!_tipBoard) _tipBoard = new Sprite();
			if(!_tipBoard.contains(_tipBoardBackground)) _tipBoard.addChildAt(_tipBoardBackground, 0);
			if(!contains(_tipBoard)) addChild(_tipBoard);
			
			if(!_tipBoardBackground.filters.length > 0) {
				var filter : GlowFilter = new GlowFilter();
				filter.alpha = 0.75;
				filter.blurX = 15;
				filter.blurY = 15;
				filter.color = 0x333333;
				
				_tipBoardBackground.filters = [filter];
			}
			
			// position the tipboard
			_tipBoard.x = (stage.stageWidth - _tipBoard.width) >> 1;
			_tipBoard.y = stage.stageHeight - _tipBoard.height - 30;
			
			_tipBoard.visible = true;
			setChildIndex(_tipBoard, numChildren - 1);
		}

		private function onHidePopup(event : ParanoiaCrossingEvent) : void {
			_popup.visible = false;
			
			if(_tipBoard.visible) {
				_tipBoard.visible = false;
			}
		}

		private function onShowPopup(event : ParanoiaCrossingEvent) : void {
			_popup.visible = true;
		}

		private function createNPCS() : void {
			var rand : RandomPlus = new RandomPlus(0, characterNames.length - 1);
			var randSpawn : RandomPlus = new RandomPlus(0, collisionMap.spawns.length - 1);
			for (var i : int = 0; i < numNPCS; i++) {
				npcs.push(new Character(characterNames[rand.getNum()]));
				trace(npcs[i].charname);
				sceneCharacters.push(npcs[i].charname);
				addChild(npcs[i]);
				
//				var spawn : SpawnPoint = collisionMap.spawns[randSpawn.getNum()];
//				trace(spawn);
//				var pos : Point = new Point(spawn.x, spawn.y);
//
//				npcs[i].x = pos.x;
//				npcs[i].y = pos.y;

				npcs[i].addEventListener(ParanoiaCrossingEvent.CHARACTER_LOADED, onCharacterLoaded);
			}
		}

		private function onCharacterLoaded(event : ParanoiaCrossingEvent) : void {
			event.stopImmediatePropagation();
			Character(event.target).removeEventListener(ParanoiaCrossingEvent.CHARACTER_LOADED, onCharacterLoaded);

			numNPCSLoaded++;

			trace(numNPCSLoaded)

			if (numNPCSLoaded == numNPCS) {
				for (var i : int = 0; i < numNPCS; i++) {
					npcs[i].buildConversation();
				}
				assignWinningHouse();
				// when the game starts create the player
				_player = new Player(null);
				_player.x = playerStartX;
				_player.y = playerStartY;
				addChild(_player);

				_player.addEventListener(ParanoiaCrossingEvent.SHOW_POP_UP, onShowPopup);
				_player.addEventListener(ParanoiaCrossingEvent.HIDE_POP_UP, onHidePopup);

				if (contains(_finishedGamePopup) && _finishedGamePopup.visible) {
					setChildIndex(_finishedGamePopup, numChildren - 1);
				}

				numNPCSLoaded = 0;
				populateTipBoard();
			}
		}

		private function assignWinningHouse() : void {
			var r : RandomPlus = new RandomPlus(0, 5);
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

			sceneCharacters = null;
			sceneCharacters = new Vector.<String>();

			tableOfTruth = null;
			tableOfTruth = new Array();

			createNPCS();
		}

		private function addFinishedGamePopup(success : Boolean, characterArray : Array) : void {
			_finishedGamePopup.addGameData(success, npcs, []);
			addChildAt(_finishedGamePopup, numChildren - 1);
		}
	}
}
