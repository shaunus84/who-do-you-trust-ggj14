package com.ggj14.paranoiacrossing {
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.net.URLRequest;

	/**
	 * @author shaunmitchell
	 */
	public class AnimatedCharacter extends Sprite 
	{
		protected static const MAX_SPEED : Number = 5;
		protected var _velocity : Point = new Point();
		protected var _spriteWidth : uint = 55;
		protected var _spriteHeight : uint = 72;
		protected var _sheet : Bitmap;
		protected var _canvas : Bitmap = new Bitmap();
		protected var _bitmapData : BitmapData;
		protected var _imageLoader : Loader = new Loader();
		protected var _currentRow : uint = 0;
		protected var _currentFrame : uint = 0;
		protected var _maxFrames : uint = 3;
		protected var _animSpeed : uint = 10;
		protected var _animSpeedCounter : uint = 0;
		protected var _spriteFile:String;

		public function AnimatedCharacter(xml:XML)  // pass in some XML data to set up the character
		{
			this.addGraphics();
			
			_spriteFile = "";
		}
		
		protected function load():void
		{
			// ready for dialog shiz
		}
		
		private function addGraphics() : void 
		{
			_imageLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, onImageLoaded);
			_imageLoader.load(new URLRequest(ParanoiaCrossing.assetsLocation + "sprites/" + _spriteFile));
		}

		private function onImageLoaded(event : Event) : void {
			_sheet = Bitmap(_imageLoader.content);
			_bitmapData = new BitmapData(_spriteWidth, _spriteHeight, true, 0xff0000);
			_canvas = new Bitmap(_bitmapData);

			addChild(_canvas);

			this.addEventListener(Event.ENTER_FRAME, update);
		}

		private function update(event : Event) : void {
			_animSpeedCounter++;
			if (_animSpeedCounter == _animSpeed) {
				_currentFrame++;
				_animSpeedCounter = 0;
			}

			if (_currentFrame == _maxFrames) {
				_currentFrame = 0;
			}
			
			// update shit
			this.x += _velocity.x;
			this.y += _velocity.y;

			if (_velocity.x > 0) {
				_currentRow = 1;
			} else if (_velocity.x < 0) {
				_currentRow = 3;
			}

			if (_velocity.y > 0) {
				_currentRow = 2;
			} else if (_velocity.y < 0) {
				_currentRow = 0;
			}
			///////

			_bitmapData.copyPixels(_sheet.bitmapData, new Rectangle(_currentFrame * _spriteWidth, _currentRow * _spriteHeight, _spriteWidth, _spriteHeight), new Point(0, 0));
		}
	}
}
