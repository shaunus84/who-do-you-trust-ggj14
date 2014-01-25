package com.ggj14.paranoiacrossing.tiledloader 
{
	import com.ggj14.paranoiacrossing.ParanoiaCrossing;

	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.utils.ByteArray;

	/**
	 * @author shaunmitchell
	 */
	public class TMXMap extends Sprite {
		private var mapLoader : URLLoader = new URLLoader();
		private var sheetLoader : Loader = new Loader();
		private var _sheet : Bitmap;
		private var numSheets : uint;
		private var sheetWidth:uint;
		private var sheetHeight:uint;
		private var mapXML : XML;
		private var mapWidth : int;
		private var mapHeight : int;
		private var sheetColumns : int;
		private var sheetRows : int;
		private var tileSize : int;
		private var mapCanvas : Bitmap;
		private var mapCanvasData : BitmapData;
		private var layers : Vector.<Array> = new Vector.<Array>();
		private var numLayers : int;

		public function TMXMap(file : String) : void {
			mapLoader.addEventListener(Event.COMPLETE, onMapXMLLoad);
			mapLoader.load(new URLRequest(ParanoiaCrossing.assetsLocation + file));
		}

		private function onMapXMLLoad(event : Event) : void {
			event.stopImmediatePropagation();
			mapLoader.removeEventListener(Event.COMPLETE, onMapXMLLoad);

			mapXML = new XML(mapLoader.data);

			mapWidth = mapXML.@width;
			mapHeight = mapXML.@height;
			tileSize = mapXML.@tilewidth;
			sheetColumns = int(mapXML.tileset[0].image.@width) / tileSize;
			sheetRows = int(mapXML.tileset[0].image.@height) / tileSize;
			sheetWidth = int(mapXML.tileset[0].image.@width);
			sheetHeight = int(mapXML.tileset[0].image.@height);

			numLayers = mapXML.layer.length();
			numSheets = mapXML.tileset.length();

			trace(mapWidth, mapHeight, numLayers);

			mapCanvasData = new BitmapData(mapWidth * tileSize, mapHeight * tileSize, true, 0xff0000);
			mapCanvas = new Bitmap(mapCanvasData);

			addChild(mapCanvas);

			sheetLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, onSheetLoaded);
			sheetLoader.load(new URLRequest(ParanoiaCrossing.assetsLocation + mapXML.tileset[0].image.@source));
		}

		private function onSheetLoaded(event : Event) : void {
			event.stopImmediatePropagation();
			sheetLoader.contentLoaderInfo.removeEventListener(Event.COMPLETE, onSheetLoaded);

			_sheet = Bitmap(sheetLoader.content);

			loadMapData();
		}

		private function loadMapData() : void {
			for (var i : int = 0; i < numLayers; i++) {
				trace("loading map data");
				var ba : ByteArray = Base64.decode(mapXML.layer[i].data);
				ba.uncompress();

				var data : Array = new Array();

				for (var j : int = 0; j < ba.length; j += 4) {
					// Get the grid ID

					var a : int = ba[j];
					var b : int = ba[j + 1];
					var c : int = ba[j + 2];
					var d : int = ba[j + 3];

					var gid : int = a | b << 8 | c << 16 | d << 24;

					data.push(gid);
				}

				layers.push(data);
			}

			drawLayers();
		}

		private function drawLayers() : void {
			trace("drawing layers");
			for (var i : int = 0; i < numLayers; i++) {
				trace("drawing layers");
				var row : int = 0;
				var col : int = 0;
				for (var j : int = 0; j < layers[i].length; j++) {
					if (col > (mapWidth - 1) * tileSize) {
						col = 0;
						row += tileSize;
					}

					if (layers[i][j] != 0) 
					{
						var y:int = Math.floor((layers[i][j] - 1) / sheetRows);
						trace((layers[i][j] - 1) % sheetColumns);
						mapCanvasData.copyPixels(_sheet.bitmapData, new Rectangle(((layers[i][j] - 1) % sheetColumns) * tileSize, Math.round((layers[i][j] - 1) / sheetColumns) * tileSize, tileSize, tileSize), new Point(col, row));
					}

					col += tileSize;
				}
			}
		}
	}
}
