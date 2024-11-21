object resultadoNulo {
	method bonoPara(_unaPersona){
		return 0
	}	
}

object resultadoFijo {
	method bonoPara(unaPersona){
		return 88
	}	
}

object resultadoPorcentual  {
	method bonoPara(unaPersona){
		return unaPersona.sueldoNeto() * 0.1
	}	
}