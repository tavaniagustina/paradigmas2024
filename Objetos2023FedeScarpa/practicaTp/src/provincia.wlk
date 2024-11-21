import jugador.*

class Provincia {
	const property campos = #{}
	
	// 1) a.
	
	method dueniosCampos() {
		return campos.map { campo => campo.duenio() }
	}
	
	// ------
	
	method esMonopolio() {
		return self.dueniosCampos().size() == 1
	}
	
	method tieneConstruccionPareja(unCampo) {
		return campos.all { campo => campo.menorCantidadEstancias(unCampo.estancias()) }
	}
	
	// ------
	
	method tieneAlgunCampo(unJugador) {
		return self.dueniosCampos().any { duenio => duenio === unJugador}
	}
}

class Campo {
	const property valorRentaFijo
	const property valorConstruccionEstancia
	var property estancias = 0
	var property duenio = banco
	const property provincia
	var property valorCompraInicial
	
	// 1) b.
	 
	method agregarEstancia() {
		self.sePuedeConstruir(self)
		duenio.construirEstancia(self)
	}
	
	method sePuedeConstruir(unCampo) {
		if(!provincia.esMonopolio() || !provincia.tieneConstruccionPareja(unCampo)) {
			self.error('La construccion de la estancia es invalida')
		}else{
			estancias++
		}
	}
	
	// ------
	
	method menorCantidadEstancias(unasEstancias) = unasEstancias <= estancias
	
	// ------
	
	// 2) a.
	
	method sosEmpresa() {
		return false
	}
	
	// 4)
	
	method rentaPara(jugadorQueCayo) {
		return (2 ** estancias) * valorRentaFijo
	}
	
	// ------
	
	method cayo(unJugador) {
		if(self.esDuenioElBanco()) {
			
		} else {
			if(duenio != unJugador) {
				unJugador.pagarA(self.rentaPara(unJugador), duenio)
			}
		}
	}
	
	method esDuenioElBanco() = duenio == banco
	
	// ------
	
	method tieneDuenioDiferente(unJugador) {
		return provincia.dueniosCampos().any { duenio => duenio != unJugador && unJugador != banco}
	}
	
	// ------
	
	method hipotecate(unDinero) {
		if(duenio.dinero() < unDinero) {
			const valor = (valorCompraInicial / 2) + estancias * (valorConstruccionEstancia / 2)
			duenio.cobrar(valor)
			duenio = banco
			valorCompraInicial = valorCompraInicial * 1.5
		}
	}
}

class Empresa {
	var property duenio = banco
	var property valorCompraInicial
	
	// 2) a.
	
    method sosEmpresa() {
        return true
    }
    
    // 4)
	
	method rentaPara(jugadorQueCayo) {
		return jugadorQueCayo.tirarDados() * 30000 * duenio.cantidadEmpresas()
	}
	
	// ------
	
	method cayo(unJugador) {
		if(self.esDuenioElBanco()) {
			
		} else {
			if(duenio != unJugador) {
				unJugador.pagarA(self.rentaPara(unJugador), duenio)
			}
		}
	}
	
	method esDuenioElBanco() = duenio == banco
	
	// ------
	
	method tieneDuenioDiferente(unJugador) {
		return banco.cantidadEmpresas() + unJugador.cantidadEmpresas() < 3
	}
	
	// ------
	
	method hipotecate(unDinero) {
		if(duenio.dinero() < unDinero) {
    		const valor = valorCompraInicial / 2
			duenio.cobrar(valor)
    		duenio = banco
   			valorCompraInicial = valorCompraInicial * 1.5
   		}
	}
}