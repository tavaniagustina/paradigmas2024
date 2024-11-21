import provincia.*
import tablero.*

class Jugador {
	var property dinero 
	const property propiedades = #{}
	var property casilleroActual 
	var tiradasDoblesAnteriores = 0
	var turnosRestantesEnPrision = 0
	
	// 1) b.
    
    method construirEstancia(unCampo) {
    	self.pagarA(unCampo.valorConstruccionEstancia(), banco)
    }
    
	// 2) b.
	
	method cantidadEmpresas() {
		return propiedades.filter { propiedad => propiedad.sosEmpresa() }.size()
	}
	
	// 3)
	
	method tirarDados() {
		const primerDado = 1.randomUpTo(7)
        const segundoDado = 1.randomUpTo(7)
        
        // 1) Extension
        
        if(primerDado == segundoDado) {
        	tiradasDoblesAnteriores++
        } else {
        	tiradasDoblesAnteriores = 0
        }
        
        if(tiradasDoblesAnteriores == 2) {
        	casilleroActual = prision
        	turnosRestantesEnPrision = 3
        	tiradasDoblesAnteriores = 0
        	return 0
        } else {
        	return primerDado + segundoDado
        }
	}
	
	// 5) 
	
	method pagarA(unDinero, unAcreedor) {
		self.tieneSuficienteDinero(unDinero)	
		self.pagar(unDinero)
		unAcreedor.cobrar(unDinero)
	}
	
	// 2) Extension
	
	method tieneSuficienteDinero(unDinero) {
		if(dinero < unDinero) {
			self.hipotecar(unDinero)
		}
	}
	
	method hipotecar(unDinero) {
		self.venderPropiedades(unDinero)
		
		if(dinero < unDinero) {
			self.error('No tiene suficiente dinero')
		}
	}
	
	method venderPropiedades(unDinero) {
		self.propiedades().forEach { propiedad => propiedad.hipotecate(unDinero) }
	}
	
	method pagar(unDinero) {
		dinero -= unDinero
	}
	
	method cobrar(unDinero) {
		dinero += unDinero
	}
	
	// 8)
	
	method moverseSobre(unosCasilleros) {
		if(!self.casilleroActual().esPrision() || self.tireDoble() || self.esTercerTurnoEnPrision()) {
			unosCasilleros.forEach{ casillero => casillero.paso(self) }
			unosCasilleros.cayo(self)
			casilleroActual = unosCasilleros.last()
		} else {
			turnosRestantesEnPrision--
		}
	}
	
	method tireDoble() {
		return tiradasDoblesAnteriores == 1
	}
	
	method esTercerTurnoEnPrision() {
		return turnosRestantesEnPrision == 0
	}
	
	// 2) Extension
	
    method comprarPropiedad(unaPropiedad) {    	
    	self.tieneSuficienteDinero(unaPropiedad.valorCompraInicial())
    	self.pagarA(unaPropiedad.valorCompraInicial(), banco)
    	propiedades.add(unaPropiedad)
    	
    	if (unaPropiedad.sosEmpresa()) {
        	banco.vendisteEmpresa()
        }
    }
    
    // ------
    
    method tieneAlgunCampo(unJugador) {
    	return  (propiedades.any{ propiedad => !propiedades.sosEmpresa() }) || 
                (propiedades.all{ propiedad => propiedades.duenio() == banco })
    }
}

// ------

object standard {
	method evaluarPropiedad(unaPropiedad, unJugador) {
		unJugador.comprarPropiedad(unaPropiedad)
	}
}

object garca {
	method evaluarPropiedad(unaPropiedad, unJugador) {
		if(unaPropiedad.tieneDuenioDiferente(unJugador)) {
			unJugador.comprarPropiedad(unaPropiedad)
		}
	}
}

object imperialista {
	method evaluarPropiedad(unaPropiedad, unJugador) {
		if(unaPropiedad.esEmpresa() && banco.cantidadEmpresas() == 3) {
			unJugador.comprarPropiedad(unaPropiedad)
		} else if (unaPropiedad.provincia().dueniosCampos().size() == 0 || unaPropiedad.provincia().tieneAlgunCampo(unJugador)) {
			unJugador.comprarPropiedad(unaPropiedad)
		}
	}
}

// ------

object banco {
	var property cantidadEmpresas = 3
	
	method cobrar(_unDinero) {
        // No hace nada
    }
    
    method vendisteEmpresa() {
    	cantidadEmpresas --
    }
}