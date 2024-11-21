object movistar {
	method costoDeLlamada(unaDuracion) {
		return unaDuracion * 60
	}
}

object personal {
	method costoDeLlamada(unaDuracion){
		if(unaDuracion <= 10) {
			return unaDuracion * 70
		}else{
			return 70 * 10 + (unaDuracion - 10) * 40 
		}
	}
}

object claro {
	method costoDeLlamada(unaDuracion) {
		return unaDuracion * 50 + (unaDuracion * 50 * 0.21)
	}
}