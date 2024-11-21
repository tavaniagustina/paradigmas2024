object samsungS21 {
	var property bateria = 5 
	
	method consumirBateria(_unaDuracion) {
		bateria -= 0.25 
	}

	method estaApagado() {
		return bateria == 0
	}
	
	method recargar() {
		bateria = 5
	}
}

object iphone {
	var property bateria = 5 
	
	method consumirBateria(unaDuracion) {
		bateria = bateria - unaDuracion * 0.001 
	}
	
	method estaApagado() {
		return bateria == 0
	}
	
	method recargar() {
		bateria = 5
	}

}
