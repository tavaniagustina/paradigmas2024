class Persona {
	const recuerdosDelDia = []
	const pensamientosCentrales = #{}
	const procesosMentales = []
	const recuerdosALargoPlazo = []
	
	var emocionDominate
	var felicidad
	var property edad
	var	pensamientoActual = null
	
	// 1) 
	method vivirEvento(unaDescripcion){
		recuerdosDelDia.add(self.nuevoRecuerdo(unaDescripcion))
	}
	
	method nuevoRecuerdo(unaDescripcion){
		return new Recuerdo(descripcion = unaDescripcion, emocion = emocionDominate, persona = self)
	}
	
	// ---------
	
	method felicidad() = felicidad
	
	method centralizar(unRecuerdo){
		pensamientosCentrales.add(unRecuerdo)
	}
	
	method entristecer(unPorcentaje){
		felicidad = felicidad * ((100 - unPorcentaje) / 100)
		self.validarFeliciadad()
	}
	
	method validarFeliciadad(){
		if(felicidad < 1){
			self.error("La felicidad no puede ser menor a uno")
		}
	}
	
	//----------
	
	// 3)
	method recuerdoRecientesDelDia(){
		return recuerdosDelDia.reverse().take(5)
	}
	
	// 4)
	method pensamientosCentrales() = pensamientosCentrales	
	
	// 5) 
	method pensamientosCentralesDificilesDeExplicar(){
		return pensamientosCentrales.filter{pensamiento => pensamiento.esDificilDeExplicar()}
	}
	
	// 6)
	method niega(unRecuerdo){
		return emocionDominate.niega(unRecuerdo.emocion())
	}
	
	// 7)
	method dormir(){
		self.desencadenarProcesosMentales()
	}
	
	method desencadenarProcesosMentales(){
		procesosMentales.forEach{procesoMental => procesoMental.apply(self)}
	}
	
	//--------
	
	method asentarRecuerdosDelDia(){
		self.asentarRecuerdos(recuerdosDelDia)
	}
	
	method asentarRecuerdos(unosRecuerdos){
		unosRecuerdos.forEach{recuerdo => recuerdo.asentarse()}
	}
	
	method asentarRecuerdosDelDiaSelectivo(unaClave){
		const recuerdos = recuerdosDelDia.filter{recuerdo => recuerdo.tiene(unaClave)}
		self.asentarRecuerdos(recuerdos)
	}
	
	method profundizar(){
		const recuerdosCentralesNoNegados = pensamientosCentrales.filter{recuerdo => !self.niega(recuerdo)}
		self.asentarRecuerdos(recuerdosCentralesNoNegados)
	}
	
	method puedeDesequilibrarse(){
		return self.tienePensamientoCentralEnMemoriaALargoPlazo() || self.mismaEmocionEnElDia()
	}
	
	method tienePensamientoCentralEnMemoriaALargoPlazo(){
		return !pensamientosCentrales.intersection(recuerdosALargoPlazo).isEmpty()
	}
	
	method mismaEmocionEnElDia(){
		return recuerdosDelDia.all{recuerdo => recuerdo.es(emocionDominate)}
	}
	
	method desequilibrarse(){
		self.entristecer(15)
		self.perderTresPensamientosCentralesMasAntiguos()	
	}
	
	method perderTresPensamientosCentralesMasAntiguos(){
		pensamientosCentrales.removeAll(self.tresPensamientosCentralesMasAntiguos())
	}
	
	method tresPensamientosCentralesMasAntiguos(){
		return self.pensamientosCentralesPorAntiguedad().take(3)
	}
	
	method pensamientosCentralesPorAntiguedad(){
		return pensamientosCentrales.sortBy{antiguo, reciente => antiguo.fecha() < reciente.fecha()} 
	}
	
	method restaurarFelicidad(unaCantidad){
		felicidad = 1000.min(felicidad + unaCantidad)
	}
	
	// 8)
	method rememorar(){
		pensamientoActual = recuerdosALargoPlazo.find{recuerdo => recuerdo.esAntiguo()}
	}
	
	// 9)
	method cantidadDeRepeticionesDe(unRecuerdo) = recuerdosALargoPlazo.occurrencesOf(unRecuerdo)
	
	// 10)
	method tieneUnDejaVu() = self.cantidadDeRepeticionesDe(pensamientoActual) > 1
}

const riley = new Persona(emocionDominate = alegria, felicidad = 1000, edad = 11)

// ---- Recuerdos ----

class Recuerdo {
	const property descripcion
	const property emocion
	const property fecha = new Date()
	const property persona
	
	// 2)
	method asentarse(){
		emocion.asentarPara(persona, self)
	}
	
	// -------
	
	method esDificilDeExplicar() = self.cantidadDePalabras() > 10
	
	method cantidadDePalabras() = self.palabras().size()
	
	method palabras() = descripcion.words()
	
	//------
	
	method es(unaEmocion){
		return unaEmocion == emocion
	}
	
	method esAntiguo() = persona.edad / 2 < self.aniosTranscurridos()
	
	method aniosTranscurridos() = new Date().year() - fecha.year() 
}

// ---- Emociones ----

class EmocionGenerica{
	method asentarPara(unaPersona, unRecuerdo){
		//No hace nada
	}
	
	method niega(_otraEmocion) = false
	
	method esAlegre() = false
}

object alegria{
	method asentarPara(unaPersona, unRecuerdo){
		if(unaPersona.felicidad() > 500){
			unaPersona.centralizar(unRecuerdo)
		}
	}
	
	method niega(otraEmocion) = !otraEmocion.esAlegre()
	
	method esAlegre() = true
}

object tristeza{
	method asentarPara(unaPersona, unRecuerdo){
		unaPersona.centralizar(unRecuerdo)
		unaPersona.entristecer(10)	
	}
	
	method niega(otraEmocion) = otraEmocion.esAlegre()
	
	method esAlegre() = false
}

class EmocionCompuesta{
	const emociones
	
	method asentarPara(unaPersona, unRecuerdo){
		emociones.forEach{emocion => emocion.asentarPara(unaPersona, unRecuerdo)}
	}
	
	method esAlegre() = emociones.any{emocion => emocion.esAlegre()}
	
	method niega(unRecuerdo) = emociones.all{emocion => emocion.niega(unRecuerdo)} 
}

const disgusto = new EmocionGenerica()
const furioso = new EmocionGenerica()
const temeroso = new EmocionGenerica()

// ---- Procesos Mentales ----

object asentamiento{
	method apply(unaPersona){
		unaPersona.asentarRecuerdosDelDia()
	}
}

class AsentamientoSelectivo{
	const clave
	
	method apply(unaPersona){
		unaPersona.asentarRecuerdosDelDiaSelectivo(clave)
	}
}

object profundizacion{
	method apply(unaPersona){
		unaPersona.profundizar()
	}
}

object controlHormonal{
	method apply(unaPersona){
		if(unaPersona.puedeDesequilibrarse()){
			unaPersona.desequilibrarse()
		}
	}
}

object restauracionCognitiva {
	method apply(unaPersona){
		unaPersona.restaurarFelicidad(100)
}
}

