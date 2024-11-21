class Persona {
	const enfermedades = #{}
	var property temperatura = 36
	var property cantidadCelulas = 3000000
	
	// punto01
	method contraer(unaEnfermedad){
		enfermedades.add(unaEnfermedad)
	}
	
	// punto03
	method vivirUnDia(){
		enfermedades.forEach {enfermedad => enfermedad.afectarA(self)}	
	}

	method aumentarTemperatura(unosGrados){
		return 45.min(temperatura + unosGrados)
	}
	
	method enfermedadMasAmenazante(){
		enfermedades.max {enfermedad => enfermedad.cantidadCelulasAmenazadas()}
	}
	
	method estaEnComa(){
		return temperatura == 45 || cantidadCelulas < 1000000
	}
	
	method cantidadCelulasAmenazadasPorEnfermedadesAgresivas(){
		return self.enfermedadesAgresivas().sum {enfermedad => enfermedad.cantidadCelulasAmenazadas()}
	}
	
	method enfermedadesAgresivas(){
		return enfermedades.filter {enfermedad => enfermedad.esAgresivaPara(self)}
	}
	
	method destruirCantidadCelulas(unaCantidadCelulas){
		cantidadCelulas = 0.max(cantidadCelulas - unaCantidadCelulas)
	}
	
	method vivirDias(unosDias){
		unosDias.times {dia => self.vivirUnDia()}
	}
	
	method medicateCon(dosis){
		enfermedades.forEach {enfermedad => enfermedad.atenuatePara(self, dosis)}
	}
	
	method curarseDe(unaEnfermedad){
		enfermedades.remove(unaEnfermedad)
	}
	
	method morir(){
		temperatura = 0
	}
}

class Enfermedad {
	var property cantidadCelulasAmenazadas	
	
	method atenuarseEn(unaCantidadDeCelulas){
		cantidadCelulasAmenazadas = 0.max(cantidadCelulasAmenazadas - unaCantidadDeCelulas)
	}
	
	method atenuatePara(unaPersona, dosis){
		self.atenuarseEn(dosis * 15)
		self.validarCuracion(unaPersona)
	}
	
	method validarCuracion(unaPersona){
		if(cantidadCelulasAmenazadas == 0){
			unaPersona.curarseDe(self)
		}
	}
}

class EnfermedadInfecciosa inherits Enfermedad {
	
	// punto02
	method reproducirse() {
		 cantidadCelulasAmenazadas *= 2
	}
	
	method afectarA(unaPersona){
		unaPersona.aumentarTemperatura(cantidadCelulasAmenazadas / 10000)
	}
	
	method esAgresivaPara(unaPersona){
		return cantidadCelulasAmenazadas > unaPersona.cantidadCelulas() / 10
	}
}

class EnfermedadAutoinmune inherits Enfermedad {
	var cantidadDias = 0
	
	method afectarA(unaPersona){
		unaPersona.destruirCantidadCelulas(cantidadCelulasAmenazadas)
		cantidadDias++
	}
	
	method esAgresivaPara(unaPersona){
		return cantidadDias > 30
	}
}

class Medico inherits Persona {
	const dosis
	
	method atenderA(unaPersona){
		unaPersona.medicateCon(dosis)
	}
	
	override method contraer(unaEnfermedad){
		super(unaEnfermedad)
		self.atenderA(self)
	}	
}

class JefeDeDepartamento inherits Medico(dosis = 0) {
	const subordinados = #{}
	
	override method atenderA(unaPersona){
		subordinados.anyOne().atenderA(unaPersona)
	}	
}

object muerte {
	method atenuatePara(_unaPersona, _dosis){
		// no hace nada
	}
	
	method afectaA(unaPersona){
		unaPersona.morir()
	}
	
	method esAgresivaPara(_unaPersona){
		return true
	}
	
	method cantidadCelulasAmenazadas(){
		return 0
	}
}