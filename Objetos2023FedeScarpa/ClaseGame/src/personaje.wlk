import wollok.game.*

object homero {
	var property position = game.center()
	var peso = 108
	var gordura = flaco
	
	method image() = gordura.image()
	
	method hablar(){
		// NADA
	}
	
	method comer(){
		peso++
		game.say(self, "MMMM, rosquillas")
		if(peso > 110){
			gordura = gordo
		}
		if (peso > 115){
			gordura = gelatina
		}
	}
	
	method preguntarAMarge(){
		game.say(self, "Estoy gordo marge?")
	} 
}
object flaco{
	method image() = "homeroTanque.png"
}

object gordo{
	method image() = "homeroGordo.png"
}

object gelatina{
	method image() = "homeroGelatina.png"
}
object homeroGordo{
	var property position = game.center()
	var peso = 115
	method image() = "homeroGordo.png"
	
	method hablar(){
		//NADA
	}
	
	method comerMucho(){
		peso += 20
	}
}
class Dona{
	var property position = new Position(
		x = 0.randomUpTo(game.width()),
		y = 0.randomUpTo(game.height()) 
	)
	
	method image() = "dona.png"
	
	method hablar() {
		game.say(self, "Comeme todo")
	}
	
}