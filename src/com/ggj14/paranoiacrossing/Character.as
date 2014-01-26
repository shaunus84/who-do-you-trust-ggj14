package com.ggj14.paranoiacrossing {
	import com.ggj14.paranoiacrossing.events.ParanoiaCrossingEvent;
	import flash.net.URLRequest;
	import flash.events.Event;
	import flash.net.URLLoader;

	/**
	 * @author shaunmitchell
	 */
	public class Character extends AnimatedCharacter {
		private var _xmlLoader : URLLoader = new URLLoader();
		private var _xml : XML;
		private var _truthsAndLies : Array = new Array();
		private var _meanAndNice : Array = new Array();
		private var _randomComments : Array = new Array();

		public function Character(name : String) {
			super();

			_spriteFile = name + ".png";

			this.addGraphics();

			_xmlLoader.addEventListener(Event.COMPLETE, parseXML);
			_xmlLoader.load(new URLRequest(ParanoiaCrossing.assetsLocation + "chat/" + name + ".xml"));
		}

		private function parseXML(e : Event) : void {
			_xml = XML(_xmlLoader.data);

			for (var i : int = 0; i < _xml.HOUSES.HOUSE.length(); i++) 
			{
				_truthsAndLies[i] = [_xml.HOUSES.HOUSE[i].@opening, _xml.HOUSES.HOUSE[i].@ending];
			}

			for (var j : int = 0; j < _xml.MEANANDNICE.COMMENT.length(); j++) 
			{
				_meanAndNice[j] = [_xml.MEANANDNICE.COMMENT[j].@character,_xml.MEANANDNICE.COMMENT[j].@mean, _xml.MEANANDNICE.COMMENT[j].@nice];
			}

			for (var k : int = 0; k < _xml.RANDOMS.RANDOM.length(); k++) {
				_randomComments[k] = _xml.RANDOMS.RANDOM[k].@comment;
			}
			
			dispatchEvent(new ParanoiaCrossingEvent(ParanoiaCrossingEvent.CHARACTER_LOADED));
		}

		public function getTip() : Array 
		{
			return _truthsAndLies[Math.floor(Math.random() * _truthsAndLies.length)];
		}

		public function getMeanOrNiceCommentAbout(about : String) : String 
		{
			for(var i:int = 0; i < _meanAndNice.length; i++)
			{
				var mean:int = (Math.random() > .5) ? 1 : 2;
				if(_meanAndNice[i][0] == about)
				{
					return _meanAndNice[i][mean];
				}
			}
			
			return "";
		}

		public function getRandomComment() : String {
			return _randomComments[Math.floor(Math.random() * _truthsAndLies.length)];
		}
	}
}