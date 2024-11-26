// Solucion del año pasado
class Jugador{
	const mochila = []
	var nivelSospecha = 40
	const property tareas = #{}
	
	method esSospechoso() = nivelSospecha > 40

	method buscarItem(unItem){
		mochila.add(unItem)
	}
	
	method completoTodasLasTares()
	
	method hacerTarea()
	
	method tieneItems(itemNecesarios){
		return mochila.all {item => self.tieneItem(itemNecesarios)}
	}
	
	method tieneItem(itemNecesarios){
		return mochila.contains(itemNecesarios)
	}
	
	method usarItems(itemNecesarios){
		return mochila.remove(itemNecesarios)
	}
	
	method aumentarNivelSospecha(unaCantidad){
		nivelSospecha += unaCantidad
	}
	
	method disminuirNivelSospecha(unaCantidad){
		nivelSospecha -= unaCantidad
	}
	
	method impugnate(){
		
	}

}

class Impostor inherits Jugador{
	override method completoTodasLasTares() = true
	
	override method hacerTarea(){
		// No hace nada
	}
	
	method realizarSabotaje(unSabotaje){
		self.aumentarNivelSospecha(5)
		unSabotaje.realizarse()
	}
}

class Tripulante inherits Jugador{
	override method completoTodasLasTares(){
		return tareas.isEmpty()
	}
	
	override method hacerTarea(){
		const tarea = self.tareaParaHacer()
		tarea.realizadaPor(self)
		self.tareaFinalizada(tarea)
	}
	
	method tareaParaHacer(){
		return tareas.find {tarea => tarea.puedeHacerla(self)}
	}
	
	method tareaFinalizada(unaTarea){
		tareas.remove(unaTarea)
		nave.tareaFinalizada(unaTarea)
	}
}

object nave{
	var property cantidadImpostoresEnNave = 2
	var property cantidadTripulantesEnNave = 8
	var oxigeno = 100
	
	const jugadores = #{}
	
	method tareaFinalizada(unaTarea){
		if(self.completaronTodasLasTarea()){
			self.throwTripulantesGanan()
		}
	}
	
	method completaronTodasLasTarea(){
		return jugadores.all {jugador => jugador.completoTodasLasTareas()}
	}
	
	method throwImpostoresGanan(){
		throw new Exception(message = "Impostores ganan")
	}

	method throwTripulantesGanan(){
		throw new Exception(message = "Tripulantes ganan")
	}
	
	method aumentarNivelOxigeno(unaCantidad){
		oxigeno += unaCantidad
	}
	
	method alguienTiene(unItem){
		return jugadores.any {jugador => jugador.tienetieneItem(unItem)}
	}
	
	method disminuirNivelOxigeno(unaCantidad){
		oxigeno -= unaCantidad
		if (oxigeno <= 0) {
			self.throwImpostoresGanan()
		}
	}
}

class Tarea{
	const itemNecesarios = []
	
	method puedeHacerla(unaPersona){
		return unaPersona.tieneItems(itemNecesarios)
	}
	
	method realizarsePor(unJugador){
		self.realizatePor(unJugador)
		unJugador.usarItems(itemNecesarios)
	}
	
	method realizatePor(unJugador)
	
}

object arreglarTableroElectrico inherits Tarea(itemNecesarios = [llaveInglesa]){
	override method realizatePor(unJugador){
		unJugador.aumentarNivelSospecha(10)
	}
}

object sacarBasura inherits Tarea(itemNecesarios = [bolsaConsorcio, escoba]){
	override method realizatePor(unJugador){
		unJugador.disminuirNivelSospecha(4)
	}
}

object ventilarNave inherits Tarea(itemNecesarios = []){
	override method realizatePor(unJugador){
		nave.aumentarNivelOxigeno(5)
	}
}

class Item{}

const llaveInglesa = new Item()
const bolsaConsorcio = new Item()
const escoba = new Item()
const tuboOxigeno = new Item()

class ImpugnarVoto{
	const jugador 
	
	method realizarse() {
		jugador.impugnate()
	}
}

class ReducirOxigeno{
	method realizarse() {
		if(nave.alguienTiene(tuboOxigeno)){
			nave.disminuirNivelOxigeno(10)
		}
	}
}