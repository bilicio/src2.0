package classes.antidoto
{
	import flash.events.Event;

	public class AsyncCameraRollEvent extends Event 
	{
		
		public static const CARREGADO:String = "carregado";
		public static const BITMAPDATA_PRONTO:String = "bitmapdata_pronto";
		public static const MOLDURA_APLICADA:String = "moldura_aplicada";
		
		public static const GALERIA_XML_CARREGADO:String = "xml_galeria_carregado";
		public static const ERRO_NA_GALERIA:String = "erro_na_galeria";		
		
		public static const SELECAO_CANCELADA:String = "selecao_cancelada";
		public static const SELECAO_NATIVA_CONCLUIDA:String = "selecao_nativa_concluida";
		
		public function AsyncCameraRollEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false)
		{
			super(type, bubbles, cancelable);
		}
	}
}