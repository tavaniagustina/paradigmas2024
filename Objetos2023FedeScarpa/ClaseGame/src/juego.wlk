import wollok.game.*
import personaje.*

object juego {
	method inicializar() {
		game.width(32)
		game.height(18)
		game.addVisualCharacter(homero)
		
		30.times { vez => game.addVisual(new Dona()) }
		
		game.onTick(1000, "Alguien que hable", 
			{ self.hablen() }
		)
		
		game.onCollideDo(homero,
			{ elemento => self.comer(elemento) }
		)
		
		
		
		keyboard.space().onPressDo{ homero.preguntarAMarge() }
	}
	
	method hablen(){
		game.allVisuals().anyOne().hablar()
	}
	
	method comer(dona){
		homero.comer()
		game.removeVisual(dona)
	}
	
	
	
}
