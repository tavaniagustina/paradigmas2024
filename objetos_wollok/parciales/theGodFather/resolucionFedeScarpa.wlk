class Integrante {

	const armas = [new Escopeta()]
	
	var estaHerido = false
	var estaMuerto = false
	
	var rango = new Soldado()
	var lealtad

	method estaDurmiendoConLosPeces() {
		return estaMuerto
	}

	method cantidadArmas() {
		return armas.size()
	}

	method armarse() {
		self.agregarArma(new Revolver(cantidadBalas = 6))
	}

	method agregarArma(unArma) {
		armas.add(unArma)
	}

	method sabeDespacharElegantemente() {
		return rango.sabeDespacharElegantemente(self)
	}

	method tieneArmaSutil() {
		return armas.any{ arma => arma.esSutil() }
	}

	method atacarFamilia(unaFamilia) {
		const atacado = unaFamilia.mafiosoMasPeligroso()
		if (atacado.estaVivo()) {
			self.atacarIntegrante(atacado)
		}
	}

	method estaVivo() {
		return not estaMuerto
	}

	method atacarIntegrante(unaPersona) {
		rango.atacar(self, unaPersona)
	}

	method armaCualquiera() {
		return armas.anyOne()
	}

	method armaMasCercana() {
		return armas.first()
	}
	
	method morir() {
		estaMuerto = true
	}
	
	method herir() {
		if (estaHerido) {
			self.morir()
		} else {
			estaHerido = true
		}
	}

	method ascenderASubjefe() {
		rango = new Subjefe()
	}
	
	method esSoldado() {
		return rango.esSoldado()
	}
	
	method ascenderADonDe(unaFamilia) {
		rango = new Don(subordinados = self.subordinados())
		unaFamilia.ascenderADon(self)
	}
	
	method subordinados() {
		return rango.subordinados()
	}
	
	method aumentarLealtadPorLuto() {
		lealtad *= 1.1
	}
	
	method lealtad() {
		return lealtad
	}
	
}

class Familia {

	const integrantes = []
	var don

	method mafiosoMasPeligroso() {
		return self.integrantesVivos().max{ integrante => integrante.cantidadArmas() }
	}

	method armarFamilia() {
		self.integrantesVivos().forEach{ integrante => integrante.armarse()}
	}

	method atacarFamilia(unaFamilia) {
		self.integrantesVivos().forEach{ integrante => integrante.atacarFamilia(unaFamilia)}
	}
	
	method integrantesVivos() {
		return integrantes.filter { integrante => integrante.estaVivo() }
	}
	
	method reorganizarse() {
		self.ascenderSoldadosConArmas()
		self.elegirNuevoDon()
		self.aumentarLealtad()
	}

	method ascenderSoldadosConArmas() {
		self.soldadosVivos()
			.sortBy { int1, int2 => int1.cantidadArmas() > int2.cantidadArmas() }
			.take(5)
			.forEach { integrante => integrante.ascenderASubjefe() } 
	}
	
	method soldadosVivos() {
		return self.integrantesVivos().filter { integrante => integrante.esSoldado() }
	}
	
	method elegirNuevoDon() {
		don.subordinadoMasLeal().ascenderADonDe(self)
	}
	
	method ascenderADon(unIntegrante) {
		don = unIntegrante
	}
	
	method aumentarLealtad() {
		integrantes.forEach { integrante => integrante.aumentarLealtadPorLuto() }
	}

}

class Revolver {

	var cantidadBalas

	method esSutil() {
		return cantidadBalas == 1
	}

	method usarContra(unaPersona) {
		if (self.estaCargada()) {
			unaPersona.morir()
			cantidadBalas--			
		}
	}
	
	method estaCargada() {
		return cantidadBalas > 0
	}

}

class CuerdaDePiano {

	const esDeBuenaCalidad

	method esSutil() {
		return true
	}
	
	method usarContra(unaPersona) {
		if (esDeBuenaCalidad) {
			unaPersona.morir()			
		}
	}

}

class Escopeta {

	method esSutil() {
		return false
	}

	method usarContra(unaPersona) {
		unaPersona.herir()
	}

}

class Don {

	const property subordinados = #{}

	method sabeDespacharElegantemente(unaPersona) {
		return true
	}

	method atacar(unAtacante, unAtacado) {
		subordinados.anyOne().atacarIntegrante(unAtacado)
	}
	
	method esSoldado() {
		return false
	}
	
	method subordinadoMasLeal() {
		return subordinados.max { subordinado => subordinado.lealtad() }
	}

}

class Subjefe {

	const property subordinados = #{}

	method sabeDespacharElegantemente(unaPersona) {
		return subordinados.any{ subordinado => subordinado.tieneArmaSutil() }
	}

	method atacar(unAtacante, unAtacado) {
		unAtacante.armaCualquiera().usarContra(unAtacado)
	}

	method esSoldado() {
		return false
	}

}

class Soldado {

	method sabeDespacharElegantemente(unaPersona) {
		return unaPersona.tieneArmaSutil()
	}

	method atacar(unAtacante, unAtacado) {
		unAtacante.armaMasCercana().usarContra(unAtacado)
	}

	method esSoldado() {
		return true
	}
	
	method subordinados() {
		return #{}
	}

}

object donCorleone inherits Don {	
	override method atacar(unAtacante, unAtacado) {
		super(unAtacante, unAtacado)
		super(unAtacante, unAtacado)
	}
}


class Traicion {
	const traidor
	const victimas = #{}
	
	const fechaTentativa
	
	method ajusticiar() {
		// Esto se lo dejo a ustedes, es fácil
	}

	method concretarse() {
		// Esto se lo dejo a ustedes, es fácil
	}
}