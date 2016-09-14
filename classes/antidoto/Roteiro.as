package classes.antidoto
{
	public class Roteiro
	{
		public function Roteiro(nome:String = null, rotas:Array = null)
		{
			this.nome = nome;
			this.rotas = rotas;
		}
		
		public var rotas:Array;
		public var nome:String;
	
	}
}