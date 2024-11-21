class Integrante{
	var estaMuerto = false
	var estaHerida = false
	const armas = [new Escopeta()]
	var rango = new Soldado()
	var property lealtad
	
	method duermeConLosPeces(){
		return estaMuerto
	}
	
	method masArmado(){
		return armas.size()
	}
	
	method estaVivo(){
		return not estaMuerto
	}
	
	method armarse(){
		self.agregarArma(new Revolver(cantidadBalas = 6))
	}
	
	method agregarArma(unArma){
		armas.add(unArma)
	}
	
	method tieneArmaSutil(){
		return armas.any {arma => arma.esSutil()}
	}
	
	method atacarFamilia(unaFamilia){
		const victima = unaFamilia.mafiosoMasPeligroso()
		if(victima.estaVivo()){
			self.atacarIntegrante(victima)	
		}
	}
	
	method atacarIntegrante(unaVictima){
		rango.ataqueEntre(self, unaVictima)
	}
	
	method armaCualquiera(){
		return armas.anyOne()
	}
	
	method morir(){
		estaMuerto = true
	}
	
	method herir(){
		if(estaHerida){
			self.morir()
		}else{
			estaHerida = true
		}
	}
	
	method esSoldado(){
		return rango.esSoldado()
	}
	
	method armaMasCercana(){
		return armas.first()
	}
	
	method ascenderASubjefe(){
		rango = new Subjefe()
	}
	
	method ascenderADonDe(unaFamilia){
		rango = new Don(subordinados = rango.subordinados()) 
		unaFamilia.ascenderADon(self)
	}
	
	method subordinados(){
		return rango.subordinado() && rango.sabeDespacharElegantemente()
	}
	
	method aumentarLealtad(){
		lealtad *= 1.1
	}
}

class Familia{
	const integrantes = #{}
	var don
	
	method mafiosoMasPeligroso(){
		return self.integranteVivo().max {integrante => integrante.masArmado()}
	}	
	
	method integranteVivo(){
		return integrantes.filter {integrante => integrante.estaVivo()}
	}
	
	method armarFamilia(){
		return self.integranteVivo().forEach {integrante => integrante.armarse()}
	}
	
	method atacarFamilia(unaFamilia){
		return integrantes.forEach {integrante => integrante.atacarFamilia(unaFamilia)}
	}
	
	method reorganizarse(){
		self.ascenderSoldadosConArmas()
		self.elegirNuevoDon()
		self.aumentarLealtad()
	}
	
	method ascenderSoldadosConArmas(){
		self.soldadosVivos().sortBy {int1, int2 => int1.masArmado() > int2.masArmado()}.take(5)
			.forEach {integrante => integrante.ascenderASubjefe()}
	}
	
	method soldadosVivos(){
		return self.integranteVivo().filter {integrante => integrante.esSoldado()}
	}
	
	method elegirNuevoDon(){
		don.subordinadoMasLeal().ascenderADonDe(self)
	}	
	
	method ascenderADon(unaPersona){
		don = unaPersona
	}
	
	method aumentarLealtad(){
		integrantes.forEach {integrante => integrante.aumentarLealtad()}
	}
}

class Revolver{
	var cantidadBalas 
	
	method esSutil() = cantidadBalas == 1
	
	method usarContra(unaPersona){
		if(cantidadBalas > 0){
			unaPersona.morir()
			cantidadBalas--
		}
	}
}

class Escopeta{
	method esSutil() = false
	
	method usarContra(unaPersona){
		unaPersona.herir()
	}
}

class CuerdaDePiano{
	var esDeBuenaCalidad 
	
	method esSutil() = true
	
	method usarContra(unaPersona){
		if(esDeBuenaCalidad){
			unaPersona.morir()
		}
	}
}

class Don{
	const property subordinados = #{}
	
	method sabeDespacharElegantemente() = true
	
	method ataqueEntre(unAtacante, unAtacado){
		subordinados.anyOne().atacarIntegrante(unAtacado)
	}
	
	method esSoldado() = false
	
	method subordinadoMasLeal(){
		return subordinados.max {subordinado => subordinado.lealtad()}
	}
}

class Subjefe{
	const property subordinados = #{} 
	
	method sabeDespacharElegantemente(){
		return subordinados.any {subordinado => subordinado.tieneArmaSutil()}
	}
	
	method ataqueEntre(unAtacante, unAtacado){
		unAtacante.armaCualquiera().usarContra(unAtacado)
	}
	
	method esSoldado() = false
}

class Soldado{
	method sabeDespacharElegantemente(unaPersona){
		return unaPersona.tieneArmaSutil()
	}
	
	method ataqueEntre(unAtacante, unAtacado){
		unAtacante.armaMasCercana().usarContra(unAtacado)
	}
	
	method esSoldado() = true
	
	method subordinados(){
		return #{}
	}
}

object donCorleone inherits Don{
	override method ataqueEntre(unAtacante, unAtacado){
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