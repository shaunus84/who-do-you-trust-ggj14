package com.ggj14.paranoiacrossing.mainmenu {
	import com.ggj14.paranoiacrossing.events.ParanoiaCrossingEvent;
	import flash.events.MouseEvent;
	import com.shaunus84.assets.ggj14.mainmenu.BackButton;
	import flash.text.AntiAliasType;
	import com.ggj14.paranoiacrossing.ParanoiaCrossing;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Rectangle;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	/**
	 * @author jamie
	 */
	public class Instructions extends Sprite {
		protected var _headingFont : Font043B0Regular = new Font043B0Regular();
		protected var _textFont : FontMinecraftiaRegular = new FontMinecraftiaRegular();
		protected var _instructionsText : String = "";
		protected var _size : Rectangle;
		protected var _backButton : BackButton;
		
		public function Instructions(width : int = 0, height : int = 0) {
			_size = new Rectangle(0, 0, width, height);
			
			initView();
			
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
		}

		private function onAddedToStage(event : Event) : void {
			_backButton.addEventListener(MouseEvent.CLICK, onClick);
		}
		
		private function onRemovedFromStage(event : Event) : void {
			_backButton.removeEventListener(MouseEvent.CLICK, onClick);
		}

		private function initView() : void {
			var headerTextFormat : TextFormat = new TextFormat(_headingFont.fontName),
				bodyTextFormat : TextFormat = new TextFormat(_textFont.fontName),
				header : TextField = new TextField(),
				body : TextField = new TextField();
			
			if(!_instructionsText || _instructionsText == "") {
				var url:URLRequest = new URLRequest(ParanoiaCrossing.assetsLocation + "instructions/instructions.txt");

				// Define the URLLoader.
				var loader:URLLoader = new URLLoader();
				loader.load(url);
				
				// Listen for when the file has finished loading.
				loader.addEventListener(Event.COMPLETE, loaderComplete);
				function loaderComplete(e:Event):void
				{
				    _instructionsText = loader.data;
					body.htmlText = _instructionsText.toUpperCase();
				}
			}
			
			headerTextFormat.size = 35;
			headerTextFormat.align = TextFormatAlign.CENTER;
			headerTextFormat.color = 0x424242;
			
			header.defaultTextFormat = headerTextFormat;
			header.text = "INSTRUCTIONS";
			header.x = 0;
			header.y = _size.height >> 2;
			header.width = _size.width;
			header.selectable = false;
			addChild(header);
			
			bodyTextFormat.size = 25;
			bodyTextFormat.align = TextFormatAlign.JUSTIFY;
			bodyTextFormat.color = 0x000000;
			
			body.defaultTextFormat = bodyTextFormat;
			body.antiAliasType = AntiAliasType.ADVANCED;
			body.htmlText = _instructionsText.toUpperCase();
			body.width = _size.width * 0.75;
			body.x = (_size.width - body.width) >> 1;
			body.y = header.y + header.textHeight + 15;
			body.height = _size.height - body.y - 50;
			body.multiline = true;
			body.wordWrap = true;
			body.selectable = false;
			
			addChild(body);
			addBackButton();
			
			alpha = 0;
		}

		private function addBackButton() : void {
			if(!_backButton) {
				_backButton = new BackButton();
			}
			
			_backButton.x = _size.width >> 4;
			_backButton.y = (_size.height - _backButton.height) - 20;
			
			addChild(_backButton);
			
			_backButton.mouseEnabled = true;
			_backButton.mouseChildren = false;
			
			_backButton.addEventListener(MouseEvent.CLICK, onClick);
		}
		
		private function onClick(evt : MouseEvent) : void {
			dispatchEvent(new ParanoiaCrossingEvent(ParanoiaCrossingEvent.INSTRUCTIONS_BACK_CLICK));
			
			_backButton.removeEventListener(MouseEvent.CLICK, onClick);
		}
	}
}
