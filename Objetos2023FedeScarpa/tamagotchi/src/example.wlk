class Tamagotchi {
	var felicidad = 0
	var property animo = new Contento() 
	
	method comer(){
		animo.comer(self)
	}
		
	method poneteContento(){
		if(!self.estoyContento()){
			self.animo(new Contento())
		}
	}
	
	method estoyContento(){
		return animo.esContento()
	}
	
	method aumentarFelicidad(unaCantidad){
		felicidad += unaCantidad
	}
	
	method jugar(){
		animo.jugar(self)
	}
	
	method poneteHambriento(){
		if(self.estoyContento()){
			self.animo(new Hambriento())
		}
	}
	
	method disminuirFelicidad(unaCantidad){
		felicidad -= unaCantidad
	}
	
	method jugarCon(otroTamagotchi){
		animo.jugarCon(self, otroTamagotchi)
	}
	
	method poneteTriste(){
		if(!animo.estoyTriste()){
			self.animo(new Triste())
		}
	}
	
	method estoyTriste(){
		return animo.esTriste()
	}
	
	method poneteCansado(){
		self.animo(cansado)
	}
	
	method dormir(){
		self.poneteContento()
	}
}

class Triste {
	const tiempo = new Date()
	
	method esTriste() = false
	
	method comer(unTamagotchi){
		if(self.pasoMuchoTiempo()){
			unTamagotchi.poneteContento()
		}
	}
	
	method pasoMuchoTiempo(){
		return tiempo.plusDays(2) < new Date()
		// Esto es para 2 días y no dos minutos... 
		// Wollok no maneja la idea de tiempo, solo de fechas, entonces en lugar de dos minutos
		// decidí unilateralmente que sean 2 días en lugar de 2 minutos
	}
	
	method jugar(unTamagotchi){
		unTamagotchi.poneteContento()
	}
	
	method jugarCon(unTamagotchi, otroTamagotchi){
		unTamagotchi.poneteContento()
		otroTamagotchi.poneteContento()
	}
}

class Hambriento {
	method comer(unTamagotchi){
		unTamagotchi.poneteContento()
	}
	
	method jugar(unTamagotchi){
		unTamagotchi.disminuirFelicidad(4)
	}
	
	method jugarCon(unTamagotchi, otroTamagotchi){
		// No hace nada, dejo el método vacío para no romper la interfaz de los distintos ánimos
	}
}

class Contento {
	var cantidadDeVecesQueHaJugado = 0
	
	method esContento() = true
	
	method comer(unTamagotchi){
		unTamagotchi.aumentarFelicidad(1)
	}
	
	method jugar(unTamagotchi){
		self.cambiaAHambriento(unTamagotchi)
		unTamagotchi.aumentarFelicidad(2)
		cantidadDeVecesQueHaJugado++
	}
	
	method cambiaAHambriento(unTamagotchi){
		if(cantidadDeVecesQueHaJugado > 2){
			unTamagotchi.poneteHambriento()
		}
	}
	
	method jugarCon(unTamagotchi, otroTamagotchi){
		unTamagotchi.jugar()
		otroTamagotchi.jugar()
		otroTamagotchi.aumentarFelicidad(4)
	}
}

class Gloton inherits Tamagotchi {
	override method comer(){
		animo.aumentarFelicidad(5)
		super()
	}
}

class Antisocial inherits Tamagotchi {
	override method jugarCon(otroTamagotchi){
		self.poneteTriste()
}

class Dormilon inherits Tamagotchi {
	override method jugar(){
		super()
		if(felicidad < 10){
			self.poneteCansado()
		}
	}
}

object cansado {
	method comer(unTamagotchi) {
		unTamagotchi.disminuirFelicidad(5)
	}
	
	method jugar(unTamagotchi) {
		self.error("no puedo jugar")
	}
	
	method jugarCon(unTamagotchi, otroTamagotchi) {
		self.jugar(unTamagotchi)
	}	
	
	method esContento() = false
	}
}