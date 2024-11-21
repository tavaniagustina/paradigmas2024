import jugador.*
import tablero.*

class Juego {
	const property jugadores = []
	var property estaTerminado = false
	const tablero = new Tablero()
	
	method empezar() {
		if (not self.estaTerminado()) {
      		jugadores.forEach { jugador => self.queJuegue(jugador) }
    	}
  	}	
  	
	// 9)

	method queJuegue(unJugador) {
  		const numeroAMoverse = unJugador.tirarDados()
  		const casillerosAMoverse = tablero.casillerosDesdeHasta(unJugador.casilleroActual(), numeroAMoverse)
  		
  		unJugador.moverseSobre(casillerosAMoverse)
  	}
}