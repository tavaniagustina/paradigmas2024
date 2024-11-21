class Tablero {
	const property casilleros = []
	
	method casillerosDesdeHasta(unCasillero, unNumero) {
		return self.casillerosDesde(casilleros.copy(), unCasillero).take(unNumero)
  	}

  	method casillerosDesde(unosCasilleros, unCasillero) {
    	const primero = unosCasilleros.first()
    	unosCasilleros.remove(primero) // Remueve el primero
    	unosCasilleros.add(primero)    // Lo agrega al final
    	
    	return if (primero == unCasillero) unosCasilleros 
           else self.casillerosDesde(unosCasilleros, unCasillero)
  	}
}

class Casillero {
	const propiedad = null
	
	// 6)
	
	method paso(_unJugador) {
		// No hace nada
	}	
	 
	// 7)
	
	method cayo(unJugador) {
		propiedad.cayo(unJugador)
	}	 
}

object salida {
	// 6)
	
	method paso(unJugador) {
	 	unJugador.cobrar(5000)
	}	
	
	// 7)
	
	method cayo(_unJugador) {
		// No hace nada
	}
	 
}

object premioGanadero {
	method paso(_unJugador) {
		// No hace nada
	}	
	 
	// 7)
	
	method cayo(unJugador) {
		unJugador.cobrar(2500)
	}
}

object prision {
	
	// 1) Extension
	
	method cayo(_unJugador) {
		// No hace nada
	}
	
	method paso(_unJugador) {
		// No hace nada
	}
	
	method esPrision() = true
}