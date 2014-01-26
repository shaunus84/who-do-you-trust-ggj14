package com.ggj14.paranoiacrossing {
	import flash.net.URLRequest;
	import flash.events.Event;
	import flash.net.URLLoader;

	/**
	 * @author shaunmitchell
	 */
	public class Character extends AnimatedCharacter 
	{
		private var _xmlLoader:URLLoader = new URLLoader();
		private var _xml:XML;
		
		private var _truthsAndLies:Array;
		private var _meanAndNice:Array;
		private var _randomComments:Array;
		public function Character(name:String) 
		{
			super();
			
			_spriteFile = name + ".png";
			
			this.addGraphics();
			
			_xmlLoader.addEventListener(Event.COMPLETE, parseXML);
			_xmlLoader.load(new URLRequest(ParanoiaCrossing.assetsLocation + "chat/" + name + ".xml"));
		}
		
		private function parseXML(e:Event):void
		{
			_xml = XML(_xmlLoader.data);
			for(var i:int = 0; i < _xml.HOUSES.length; i++)
			{
				_truthsAndLies[i] = [_xml.HOUSES.HOUSE[i].@opening, _xml.HOUSES.HOUSE[i].@ending];
			}
			
			for(var j:int = 0; j < _xml.MEANANDNICE.length; j++)
			{
				_meanAndNice[_xml.MEANANDNICE.COMMENT[j].@character] = [_xml.MEANANDNICE.COMMENT[j].@mean, _xml.MEANANDNICE.COMMENT[j].@nice];
			}
			
			for(var k:int = 0; k < _xml.HOUSES.length; k++)
			{
				_randomComments[k] = _xml.RANDOMS.RANDOM[k].@comment;
			}
		}
		
		public function getTip():Array
		{
			return _truthsAndLies[Math.random() * _truthsAndLies.length];
		}
		
		public function getMeanOrNiceCommentAbout(about:String):String
		{
			return _meanAndNice[about][Math.round(Math.random())];
		}
		
		public function getRandomComment():String
		{
			return _randomComments[Math.random() * _randomComments.length]
		}
	}
}
