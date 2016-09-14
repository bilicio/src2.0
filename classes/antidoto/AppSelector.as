package classes.antidoto {
	
	public class AppSelector {	
		
		private static var pesos:Array = [
			[0,1,0,0], //1.	Pagar várias contas ao mesmo tempo – B
			[1,1,0,0], //2.	Usa a câmera do celular como leitor de código de barras – B – A 
			[1,1,0,0], //3.	Não gosta de digitar o código de barras – B – A 
			[0,0,1,0], //4.	Precisa cobrar alguém que não está por perto – C
			[0,0,1,0], //5.	Precisa pagar alguém de sua lista de contatos – C
			[1,0,1,0], //6.	Costuma fazer DOC/TED – A – C 
			[0,0,0,1], //7.	Não usa Smartphone – D 
			[0,0,0,1], //8.	Tem um plano de dados limitado no celular – D 
			[0,0,0,1], //9.	Frequenta locais distantes e sem sinal de internet – D 
			[1,0,0,0], //10.	Vai no PAB para contratar produtos – A 
			[1,0,0,0], //11.	Consulta extrato dos últimos 30 dias – A 
			[1,0,1,0], //12.	Precisa enviar comprovante de transação – A – C
			[0,0,0,0], //13.	Não tem tempo de ir até o PAB – TODAS
			[0,0,0,0], //14.	Costuma usar o celular – TODAS
			[0,0,0,0] //15.	Tem uma rotina corrida – TODAS
		];	
		
		public static function EscolherAplicativos( respostas:Array ):Array
		{
			var pontuacaoFinal:Array = [{peso:0, app:"A"},{peso:0, app:"B"},{peso:0, app:"C"},{peso:0, app:"D"}];
			
			for (var i:int = 0; i < respostas.length; i++){				
				for (var p:int = 0; p < pontuacaoFinal.length; p++){
					
					pontuacaoFinal[p].peso += pesos[respostas[i]][p];
				}		
			}							
			
			pontuacaoFinal.sortOn("peso", Array.DESCENDING);						
			var retorno:Array = [pontuacaoFinal[0].app]	
			
			if (pontuacaoFinal[1].peso > 0){
				retorno.push(pontuacaoFinal[1].app);
			}
			
			return retorno;			
			
			
		}

		
		
	}	
}
