// no lo termine muy dificil
object nave
{
    const property jugadores = #{}
    var property tripulantes = #{}
    var property impostores = #{}
    var property nivelOxigeno = 60

    method aumentarOxigeno(cantidad)
    {
        nivelOxigeno += cantidad
    }

    method disminuirOxigeno(cantidad)
    {
        nivelOxigeno += cantidad
    }

    method tareaFinalizada(tarea)
    {
        if(self.terminaronTodasLasTareas())
        {
            throw new Exception (message = "Ganaron los tripulantes")
        }
    }

    method terminaronTodasLasTareas() = jugadores.all { jugador => jugador.completoTodasSusTareas() }

    // Punto 5
    method alguienTiene(item) = jugadores.any { jugador => jugador.tieneItem(item) }
}

class Jugador
{
    const property color
    const property mochila = []
    var property sospecha = 40
    var property tareas = []
    var property votarEnBlanco = false

    // Punto 1
    method esSospechoso() = sospecha > 50

    // Punto 2
    method buscarItem(item)
    { 
        mochila.add(item) 
    }

    // Punto 3 y 4
    method hacerTarea() 

    method completoTodasLasTares() 

    method completoTodasSusTareas(jugador) = tareas.forEach { tarea => tarea.realizarTarea(jugador) }

    method tieneItems(items) = mochila.all { item => self.tieneItem(items) }

    method tieneItem(item) = mochila.contains(item)
    
    method disminuirSospecha(cantidad)
    {
        sospecha -= cantidad
    }

    method aumentarSospecha(cantidad)
    {
        sospecha += cantidad
    }

    method removerItems(itemsNecesarios)
    {
        itemsNecesarios.forEach { item => mochila.remove(item) }
    }

    method impugnate() 
    {
        votarEnBlanco = true
    }
}

class Tripulante inherits Jugador
{
    override method completoTodasLasTares() = tareas.isEmpty()

    override method hacerTarea() 
    {
        const tarea = self.tareaParaHacer()
        self.tareaFinalizada(tarea)
    }

    method tareaParaHacer() = tareas.find {tarea => tarea.puedeHacerla(self)}

    method tareaFinalizada(tarea)
    {
        tareas.remove(tarea)
        nave.tareaFinalizada(tarea)
    }
}

class Impostor inherits Jugador
{
    override method hacerTarea() 
    {
        // No hace nada
    }

    override method completoTodasLasTares() = true

    method realizarSabotaje(sabotaje)
    {
        self.aumentarSospecha(5)
        sabotaje.hacerSabotaje()
    }
}

class Tarea
{
    var property itemsNecesarios = []

    method puedeHacerla(persona)
    {
        if(persona.tieneItems(itemsNecesarios))
        {
            self.realizarTarea(persona)
            persona.removerItems(itemsNecesarios)
        }
    }

    method realizarTarea(persona)
}

object arreglarTableroElectrico inherits Tarea(itemsNecesarios = ([llaveInglesa]))
{ 
    override method realizarTarea(jugador) 
    {
        jugador.aumentarSospecha(10)
    }
}

object sacarbasura inherits Tarea(itemsNecesarios = ([escoba, bolsaDeConsorcio]))
{ 
    override method realizarTarea(jugador) 
    {
        jugador.disminuirSospecha(5)
    } 
}

object ventilarNave inherits Tarea
{ 
    override method realizarTarea(jugador) 
    { 
        nave.aumentarOxigeno(5) 
    }
}

class Item {}
const escoba = new Item()
const bolsaDeConsorcio = new Item()
const llaveInglesa = new Item()
const tuboOxigeno = new Item()

// los importores pueden realizar DIVERSOS sabotajes
class ReducirOxigeno 
{
    method hacerSabotaje()
    {
        if(nave.alguienTiene(tuboOxigeno))
        {
            nave.disminuirOxigeno(10)
        }
    }
}

class ImpugnarJugador 
{
    const jugador 

    method hacerSabotaje()
    {
        jugador.impugnate()
    }
}