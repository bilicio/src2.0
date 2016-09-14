package classes.antidoto
{
	public class Local
	{
		public function Local(id:Number = undefined, 
								titulo:String = null,
								img:String = null, 
								endereco:String = null,
								cat:XML = null,
								sub:String = null,
								lat:Number = undefined, 
								lng:Number = undefined,
								sobre:String = null,
								preco_dur:String = null
								)
		{
			this.id = id;
			this.titulo = titulo;
			this.endereco = endereco;
			this.preco_dur = preco_dur;
			this.cat = cat;
			this.sub = sub;
			this.lat = lat;
			this.lng = lng;
			this.img = img;
			this.sobre = sobre;
		}
		
		public var id:Number;
		public var titulo:String;
		public var cat:XML;
		public var sub:String;
		public var lat:Number;
		public var lng:Number;
		public var img:String;
		public var preco_dur:String;
		public var endereco:String;
		public var sobre:String;
		
	}
}
