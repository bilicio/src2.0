package classes.antidoto
{
	import com.bit101.components.ComboBox;
	import com.greensock.TweenMax;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.FileFilter;
	import flash.utils.ByteArray;
	
	import classes.antidoto.propagaEvento;
	import classes.antidoto.builders.buildVars;
	import classes.antidoto.builders.buildXML;
	import classes.antidoto.builders.config_image;
	
	import uk.co.soulwire.gui.SimpleGUI;

	public class ParsePages extends Sprite
	{
		public static var id:Number;
		public var pageImages:Array = new Array();
		private var layer:Boolean = false;
		public var codeMount:Array = [];
		private var camposArr:Array = new Array('TOP','LEFT','RIGHT','BOTTOM','WIDTH','HEIGHT');
		
		private var page:Sprite;
		
		private var _globalPages:Array = new Array();
		
		private var _xml:XML;
		
		private var cont:Number = 0;
		
		public var global:Object = {};
		
		private var gui:SimpleGUI;
		
		//public var _pagina:ComboBox = new ComboBox();
		public var _pagina:* = 'none';
		
		private var toSaveConfig:Array;
		
		public var paginaAtual:int = 0;
		
		private var sortArr:Array = [];
		
		private var prop:Object;
		
		public var rfid:String;
		
		private var xmlBuilded:XML = new XML();
		
		private var saveXml:buildXML;
		
		private var tempArr:Array;
		
		private var paginasSetadas:Array = new Array();
		
		private var timeGo:Number = 0;
		
		private var saving:Boolean = false;
		
		public function ParsePages(xml:XML){
			this.addEventListener(Event.ADDED_TO_STAGE, added);
			_xml = xml;
		}
		
		protected function added(event:Event):void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, added)
			montaPagina(_xml);
		}
		
		private function montaPagina(xml):void
		{
			
			//_pagina.defaultLabel = 'none';
			//_pagina.defaultColor = 0xff0000

			
			prop = {};
			for (var a:int = 0; a < buildVars._xmlConfig.config.global_page_properties.type.length(); a++) 
			{
				if(buildVars._xmlConfig.config[0].global_page_properties[0].type[a].length() > 1){
					
					var propArr2:Array = new Array();
					for (var k:int = 0; k < buildVars._xmlConfig.config.global_page_properties[0].type[a].type.length(); k++) 
					{
						propArr2.push(buildVars._xmlConfig.config[0].global_page_properties[0].type[a].type[k]);
					}
					
					prop[buildVars._xmlConfig.config[0].global_page_properties[0].type[a].@name] = propArr2;
					prop[buildVars._xmlConfig.config[0].global_page_properties[0].type[a].@name]['I'] = buildVars._xmlConfig.config[0].global_page_properties[0].type[a].type[0];
					
				}else{
					
					if(buildVars._xmlConfig.config[0].global_page_properties[0].type[a].toString() != 'input'){
						prop[buildVars._xmlConfig.config[0].global_page_properties[0].type[a].@name] =  false;
					}else{
						prop[buildVars._xmlConfig.config[0].global_page_properties[0].type[a].@name] = 'input';
					}
					//prop[buildVars._xmlConfig.config[0][global['modules'].I].type[a].@name]['I'] = false;
					
				}
				
				//trace('lenght: ' + buildVars._xmlConfig.config[0][global['modules'].I].type[a].@name);
			}
			
			for (var i:int = 0; i < xml.LAYER.length(); i++) 
			{
				if(layer){
					if(!isFolder(xml.LAYER[i])){
						codeMount.push(addModule(xml.LAYER[i]));
					}
				}

				if(xml.LAYER[i].@NAME.indexOf('Layer group') != -1){
					layer == false ? layer = true : layer = false;
				}
				
				if(xml.LAYER[i].@NAME.indexOf('Layer group') == -1 && isFolder(xml.LAYER[i])){
					pageImages.push(codeMount)
					codeMount = [];
					
					_globalPages.push({label:xml.LAYER[i].@NAME.toString(), data:cont, prop:prop});
					cont++;
					
					layer == false ? layer = true : layer = false;
				}
			}
			
			
			//trace('TRACE: ' + _globalPages[0].label)
			
			//var evt:propagaEvento = new propagaEvento(propagaEvento.COMPLETED,{ok:'ok'});
			//this.dispatchEvent(evt);
			
		
			tempArr = [];
			tempArr = clone(_globalPages);

			
			_globalPages.reverse();
			
			buildVars._savedPages = [];
			buildVars._pages = _globalPages;
			
			pageImages.reverse();
			
			makeControllers();
			
			
		}
		
		private function clone(source:Object):* 
		{ 
			var myBA:ByteArray = new ByteArray(); 
			myBA.writeObject(source); 
			myBA.position = 0; 
			return(myBA.readObject()); 
		}
		
		private function makeControllers():void{
			for (var i:int = 0; i < buildVars._xmlConfig.config.global_app_properties[0].type.length(); i++) 
			{
				if(buildVars._xmlConfig.config[0].global_app_properties[0].type[i].type.length() > 1){
					
					var propArr:Array = new Array();
					for (var j:int = 0; j < buildVars._xmlConfig.config[0].global_app_properties[0].type[i].type.length(); j++) 
					{
						propArr.push(buildVars._xmlConfig.config[0].global_app_properties[0].type[i].type[j]);
					}
					
					global[buildVars._xmlConfig.config[0].global_app_properties[0].type[i].@name] = propArr;
					global[buildVars._xmlConfig.config[0].global_app_properties[0].type[i].@name]['I'] = buildVars._xmlConfig.config[0].global_app_properties[0].type[i].type[0];
					
				}else{
					
					global[buildVars._xmlConfig.config[0].global_app_properties[0].type[i].@name] = false;
				//	global[buildVars._xmlConfig.config[0].global_app_properties[0].type[i].@name]['I'] = buildVars._xmlConfig.config[0].global_app_properties[0].type[i];
					
					
				}

				//trace('lenght: ' + buildVars._xmlConfig.config[0].global_app_properties[0].type[i].@name);
			}
			
			createGui();
		}
		
		private function createGui():void{
			if(!gui){
				
				gui = new SimpleGUI(this, null, null, true);
				
				gui.addColumn("Configurações");
				
				gui.addComboBox('_pagina', buildVars._pages);
				gui.addButton("Abrir Pagina", {callback:attachPage});
				
				for (var i:* in global) 
				{
					//trace(i);
					sortArr.push(i);

				}
				
				for (var j:int = 0; j < sortArr.length; j++) {
					
					var node:* = getSort(buildVars._xmlConfig.config.global_app_properties[0].type[j].@name);

					switch(global[node] is Array)
					{
						case true:
						{
							
							gui.addComboBox('global.'+node+'.I', getArrayProps(global[node]))
							
							//trace('prop: ' + getArrayProps(global[i])[0].label);
							
							break;
						}
							
						case false:
						{
							//trace('toggle: ' + global[node]);
							gui.addToggle('global.'+node, {selected:global[node].toString()});
							break;
						}
							
						default:
						{
							break;
						}
					}
				}
				
				
				gui.addButton("Salvar", {callback:saveConfig});
				
				gui.show();
				
			}
		
		}
		
		private function getSort(arr):*{
			for (var j:int = 0; j < sortArr.length; j++) {
				if(arr == sortArr[j]){
					return sortArr[j]
				}
			}
		}
		
		private function setPageDone(pageAdd):void{
			for(var i:Number=0; i<tempArr.length; i++){
				if(paginasSetadas[i] == pageAdd){
					break
				}
				if(i == tempArr.length-1){
					paginasSetadas.push(pageAdd);
				}
			}
			
			trace('PAGE DONE INICIO: ' + paginasSetadas)
		}

		private function saveConfig():void{

			if(paginasSetadas.length == tempArr.length){
				saveXml = new buildXML(sortArr, global);
			}else if(_pagina == 'none'){
				_pagina = 0;
				attachPage();
				TweenMax.delayedCall(.3, saveConfig);
			}else{
				for(var a:Number=0; a<tempArr.length; a++){
					for(var b:Number=0; b<paginasSetadas.length; b++){
						trace(tempArr[a].label + ' | ' + paginasSetadas[b]);
						if(paginasSetadas[b] == tempArr[a].label){
							trace('pulou')
							break;
						}
						if(b == paginasSetadas.length-1){
							trace('setNewPage - ' + tempArr[a].label);
							//_pagina = a;
							TweenMax.delayedCall(timeGo, attachPage, [a]);
							timeGo+=.3;
						}
					}
				}
			}
		}
		
		private function getArrayProps(obj):Array{
			var arr:Array = new Array();
			
			for (var i:int = 0; i < obj.length; i++) 
			{
				arr.push({label:String(obj[i]),	data:String(obj[i])})
			}
			
			return arr;
			
		}
		
		private function attachPage(num=null):void // ---------------------------------------------------------------- | Adiciona nova página e salva as configurações de cada Placeholder
		{
			//trace('pagina: ' + _pagina);
			
			setPageDone(tempArr[num==null?_pagina:num].label);
			
			if(_pagina == 'none'){
				//trace('mesma pagina ou none');
				return
			}

			if(page){
				
				
				toSaveConfig = [];
				for (var j:int = 0; j< page.numChildren; j++) 
				{
					toSaveConfig[j] = (page.getChildAt(j) as Object).saveConfig();
				}
				
				buildVars._savedPages[buildVars._id] = toSaveConfig;
				
				//trace('load config: ' + buildVars._savedPages[0][0]);
				
				while (page.numChildren>0) 
				{
					page.getChildAt(0).removeEventListener(MouseEvent.CLICK, toTop);
					page.removeChildAt(0)
					//var holder = page.getChildAt(h);
					//holder = null;
				}
				
				removeChild(page);
				page = null;
				
				remove();
			}
			
			trace('LABEL: ' + tempArr[num==null?_pagina:num].label + ' numero: ' + num);
			
			buildVars._id = buildVars._pages[num==null?_pagina:num].data;
			
			page = new Sprite();
			for (var i:int = 0; i < pageImages[buildVars._pages[num==null?_pagina:num].data].length; i++) 
			{
				pageImages[buildVars._pages[num==null?_pagina:num].data][i]._id = i;
				page.addChild(pageImages[buildVars._pages[num==null?_pagina:num].data][i])
				
				if(pageImages[buildVars._pages[num==null?_pagina:num].data][i].x != 0 && pageImages[buildVars._pages[num==null?_pagina:num].data][i].y != 0){
					pageImages[buildVars._pages[num==null?_pagina:num].data][i].addEventListener(MouseEvent.CLICK, toTop);
				}
				
				//trace('- ' + _parsePages.pages[0][i]);
			}

			
			
			addChildAt(page, 0);

			gui.hide();
			
			sortArr = [];
			
			geraPageInfo();
			
			if(paginasSetadas.length == tempArr.length && num != null && num != 0){
				TweenMax.delayedCall(.3, attachPage, [0]);
				TweenMax.delayedCall(.6, geraXml);
			}
			
		}
		
		protected function geraXml():void{
			saveXml = new buildXML(sortArr, global);
		}
		
		protected function toTop(evt:MouseEvent):void
		{
			page.setChildIndex(evt.currentTarget as DisplayObject, page.numChildren-1);
		}
		
		private function remove():void{
			gui.dispose();
			gui = null;
			
			//savedConf = false;
			
			createGui();
			gui.show();
		}
		
		private function geraPageInfo():void{
			gui.addColumn("Propriedades da Pagina");
			
			//createConfigVars(global['modules'].I.toUpperCase())
			
			
			for (var i:* in prop) 
			{
				sortArr.push(i);
			}
			
			for (var j:int = 0; j < sortArr.length; j++) {
				
				//trace('-> : ' + buildVars._xmlConfig.config.global_page_properties[0].type);
				var node:* = getSort(buildVars._xmlConfig.config[0].global_page_properties[0].type[j].@name);
				
				switch(prop[node] is Array)
				{
					case true:
					{
						trace('globalpages: ' + _globalPages);
						gui.addComboBox('prop.'+node+'.I',getArrayProps(prop[node]))
						
						//trace('prop: ' + getArrayProps(global[i])[0].label);
						
						break;
					}
						
					case false:
					{
						//trace('property: ' + prop[node].toString());
						if(node == 'pagina'){
							gui.addComboBox("_pagina", buildVars._pages);
						}else if(prop[node].toString() == 'input'){
							trace('prop node: ' + buildVars._pages[_pagina].prop[node]);
							gui.addInput('prop.'+node, {text:prop[node].toString()});
							
						}else{
							gui.addToggle('prop.'+node, {selected:prop[node].toString()});
						}
						
						break;
					}
						
					default:
					{
						break;
					}
				}
			}
			sortArr = [];
		}
		
		private function addModule(module):Sprite
		{
			return new config_image(String(module.PNG[0].@FILE.substr(8, 30)), String(module.@LEFT), String(module.@TOP), String(module.@NAME));
		}
		
		private function isFolder(xml):Boolean{

			for (var i:int = 0; i < camposArr.length; i++) 
			{
				if(Number(xml['@'+camposArr[i]]) != 0){
					return false;
				}
			}

			return true;
		}
	}
}
