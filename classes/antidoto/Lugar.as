package classes.antidoto
{
	public class Lugar
	{
		public function Lugar(lat:Number = undefined, lng:Number = undefined, nome:String = null)
		{
			this.lat = lat;
			this.lng = lng;
			this.nome = nome;
			this.index = index;
		}
		
		public var lat:Number;
		public var lng:Number;
		public var nome:String;
		public var index:Number;
		
	}
}