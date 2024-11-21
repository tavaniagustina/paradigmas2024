import celulares.*
import companias.*

object juliana {
	var property celular = samsungS21
	var property compania = personal
	var property plataGastada = 0
	
	method llamar(unaDuracion) {
		celular.consumirBateria(unaDuracion)
		plataGastada = compania.costoDeLlamada(unaDuracion)
	}
	
	method bateria(){
		celular.bateria()
	}
	
	method elCeluEstaApagado(){
		return celular.estaApagado()
	}
	
	method recargar(){
		celular.recargar()
	}
}

object catalina {
	var property celular = iphone
	var property compania = movistar
	var property plataGastada = 0

	method llamar(unaDuracion) {
		celular.consumirBateria(unaDuracion)
		plataGastada = compania.costoDeLlamada(unaDuracion)
	}
	
	method bateria(){
		celular.bateria()
	}
	
	method elCeluEstaApagado(){
		return celular.estaApagado()
	}
	
	method recargar(){
		celular.recargar()
	}
	
}