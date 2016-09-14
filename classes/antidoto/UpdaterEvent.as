package classes.antidoto
{
	import flash.events.Event;
	
	public class UpdaterEvent extends Event
	{
		public static const UPDATE_INICIADO:String = "update_iniciado";
		public static const CHECAGEM_COMPLETA:String = "checagem_completa";
		public static const UPDATE_COMPLETO:String = "update_completo";
		
		public static const ZIPDOWNLOADED:String = "ZIPDOWNLOADED";
		
		public static const PINCODE_VALIDADO:String = "pincode_validado";
		public static const PINCODE_INVALIDADO:String = "pincode_invalidado";
		public static const CONTEUDO_ESPECIFICO_CARREGADO:String = "conteudo_especifico_carregado";
		
		public static const FORMULARIO_ENVIADO:String = "formulario_enviado";
		
		public static const CONEXAO_INDISPONIVEL:String = "conexao_indisponivel";
		
		public function UpdaterEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type,bubbles,cancelable);
		}
	}
}