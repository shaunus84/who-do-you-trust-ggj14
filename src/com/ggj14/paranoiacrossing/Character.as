package com.ggj14.paranoiacrossing {
	import com.ggj14.paranoiacrossing.util.RandomPlus;
	import com.ggj14.paranoiacrossing.events.ParanoiaCrossingEvent;

	import flash.net.URLRequest;
	import flash.events.Event;
	import flash.net.URLLoader;

	/**
	 * @author shaunmitchell
	 */
	public class Character extends AnimatedCharacter {
		[Embed(source="../../../../assets/chat/Houses.xml", mimeType="application/octet-stream")]
		private var _data : Class;
		private var houseDescriptions : XML;
		private var _xmlLoader : URLLoader = new URLLoader();
		private var _xml : XML;
		private var _truthsAndLies : Array = new Array();
		private var _meanAndNice : Array = new Array();
		private var _randomComments : Array = new Array();
		public static const CONVERSATION_TYPE_TIP : int = 0;
		public static const CONVERSATION_TYPE_CHARACTER : int = 1;
		public static const CONVERSATION_TYPE_RANDOM : int = 2;
		public static const CHARACTER_DESCRIPTOR_GOSSIP : int = 0;
		public static const CHARACTER_DESCRIPTOR_HONEST : int = 1;
		public static const CHARACTER_DESCRIPTOR_LIAR : int = 2;
		public static const CHARACTER_DESCRIPTOR_RANDOM : int = 3;
		private var _greetingDemeanours : Array = ["friendly", "neutral", "rude"];
		private var _conversation : Vector.<String> = new Vector.<String>();
		private var _greetingDemeanour : String;
		private var _losingHouses : Array = new Array();
		private var houseForTip : int;
		private var _charname : String;

		public function Character(name : String) {
			super();
			_charname = name;
			houseDescriptions = new XML(new _data);

			_spriteFile = name + ".png";

			this.addGraphics();

			_xmlLoader.addEventListener(Event.COMPLETE, parseXML);
			_xmlLoader.load(new URLRequest(ParanoiaCrossing.assetsLocation + "chat/" + name + ".xml"));
		}

		private function parseXML(e : Event) : void {
			_xml = XML(_xmlLoader.data);

			for (var i : int = 0; i < _xml.HOUSES.HOUSE.length(); i++) {
				_truthsAndLies[i] = [_xml.HOUSES.HOUSE[i].@opening, _xml.HOUSES.HOUSE[i].@ending];
			}

			for (var j : int = 0; j < _xml.MEANANDNICE.COMMENT.length(); j++) {
				_meanAndNice[j] = [_xml.MEANANDNICE.COMMENT[j].@character, _xml.MEANANDNICE.COMMENT[j].@mean, _xml.MEANANDNICE.COMMENT[j].@nice];
			}

			for (var k : int = 0; k < _xml.RANDOMS.RANDOM.length(); k++) {
				_randomComments[k] = _xml.RANDOMS.RANDOM[k].@comment;
			}

			dispatchEvent(new ParanoiaCrossingEvent(ParanoiaCrossingEvent.CHARACTER_LOADED));
		}

		public function buildConversation() : void {
			_greetingDemeanour = _greetingDemeanours[Math.floor(Math.random() * _truthsAndLies.length)];

			var conversationType : int = (Math.random() > .5) ? CONVERSATION_TYPE_CHARACTER : CONVERSATION_TYPE_RANDOM;

			var honest : Boolean = (Math.random() > .5) ? true : false;
			for (var i : int = 0; i < 6; i++) {
				if (i != ParanoiaCrossing._winningHouse) {
					_losingHouses.push(i);
				}
			}
			houseForTip = (honest) ? ParanoiaCrossing._winningHouse : _losingHouses[Math.floor(1 + (Math.random() * _losingHouses.length))];
			
			ParanoiaCrossing.tableOfTruth[this.charname] = honest;

			switch(conversationType) {
				case CONVERSATION_TYPE_CHARACTER:
					_conversation.push(this.getMeanOrNiceCommentAbout(ParanoiaCrossing.sceneCharacters[Math.floor(Math.random() * ParanoiaCrossing.sceneCharacters.length)]));
					break;
				case CONVERSATION_TYPE_RANDOM:
					_conversation.push(this.getRandomComment());
					break;
				default:
					break;
			}

			var tip : Array = getTip();
			var r : int = Math.floor(Math.random() * houseDescriptions[0].HOUSE[houseForTip - 1].DESCRIPTION.length());
			trace(houseDescriptions[0].HOUSE[houseForTip].DESCRIPTION[r].@info, r, houseForTip, ParanoiaCrossing._winningHouse, honest)
			var finalTip : String = tip[0] + houseDescriptions[0].HOUSE[houseForTip].DESCRIPTION[r].@info + tip[1];
			_conversation.push(finalTip);
		}

		public function getTip() : Array 
		{
			return _truthsAndLies[Math.floor(Math.random() * _truthsAndLies.length)];
		}

		public function getMeanOrNiceCommentAbout(about : String) : String {
			for (var i : int = 0; i < _meanAndNice.length; i++) {
				var mean : int = (Math.random() > .5) ? 1 : 2;
				if (_meanAndNice[i][0] == about.toLowerCase()) {
					return _meanAndNice[i][mean];
				}
			}

			return "";
		}

		public function getRandomComment() : String {
			return _randomComments[Math.floor(Math.random() * _truthsAndLies.length)];
		}

		public function get conversation() : Vector.<String> {
			return _conversation;
		}

		public function get greetingDemeanour() : String {
			return _greetingDemeanour;
		}

		public function get charname() : String {
			return _charname;
		}
	}
}
