// Cada equipo tiene: un guardian, dos golpeadores, tres cazadores y un buscador.
// hay tres tipos de pelotas distintas
    // quaffle: los cazadores suman 10 puntos si meten la quaffle en los aros, el guardian protege los aros, y hay una unica pelota en el campo
    // bludger: aportan emocion y violencia. Los grosos pueden evitar goles. Hay dos en un partido
    // snitch: el buscador que la atrape gana 150 puntos para el equipo y termina el partido

class Equipo
{
    var property integrantes = #{}
    var property tieneLaQuaffle
    var property puntos

    method promedioDeHabilidad() = self.habilidadTotal() / integrantes.size()
    
    method habilidadTotal() = integrantes.sum {integrante => integrante.habilidadDeJugador()}  

    // Punto 2 c
    method tieneJugadorEstrella(equipoContrario) = integrantes.any { integrante => integrante.lePasaElTrapoATodoElEquipo(equipoContrario) }

    method lePasaElTrapoATodoElEquipo(equipoContrario) = equipoContrario.integrantes().all { integrante => integrante.lePasaElTrapo(self, integrante) }

    // Punto 3
    method jugarContra(equipoContrario) = integrantes.forEach { integrante => integrante.turnoDeJugar(equipoContrario) }

    // -------------------------------
    
    method ganarPuntos(cantidad)
    {
        puntos += cantidad
    }
}

class Jugador
{
    var property skills
    var property peso
    var property escoba 
    var property velocidad 
    var property punteria
    var property fuerza
    var property nivelDeReflejos
    var property nivelDeVision
    var property equipo

    // Punto 1 a
    method nivelDeManejoDeEscoba() = skills / peso

    // Punto 1 b
    method velocidad() = escoba.velocidad() * self.nivelDeManejoDeEscoba()

    // Punto 1 c
    method habilidadDeJugador() = velocidad + skills + self.habilidadSegunPosicion()

    method habilidadSegunPosicion()

    // Punto 2 a
    method lePasaElTrapo(unJugador, otroJugador) = self.habilidadDeJugador() >= unJugador.habilidadDeJugador() * 2

    // Punto 2 b
    method esGroso() = self.habilidadMayorAlPromedio() && self.velocidadMayorAlValorDelMercado()

    method habilidadMayorAlPromedio() = self.habilidadDeJugador() > self.promedioDeHabilidadDeEquipo()

    method promedioDeHabilidadDeEquipo() = equipo.promedioDeHabilidad()
    
    method velocidadMayorAlValorDelMercado() = velocidad > escoba.valorArbitrario()

    // Punto 4 c
    method esGolpeadoPorBludger() = skills.perderSkills(2) && escoba.recibirGolpe() && self.golpeadoPorBludger()

    method perderSkills(cantidad) 
    {
        skills -= cantidad
    }

    method golpeadoPorBludger()

    method aumentarSkills(cantidad) 
    {
        skills += cantidad
    } 

    method valorRandom(primerValor, segundoValor) = [primerValor .. segundoValor].anyOne()
}

class Cazador inherits Jugador
{
    var property tieneQuaffle

    override method habilidadSegunPosicion() = punteria * fuerza

    // Punto 4 a
    method puedeBloquear(cazador) = self.lePasaElTrapo(self, cazador)

    // Punto 4 b
    method esBlancoUtil() = self.tieneQuaffle()

    // Punto 4 c
    override method golpeadoPorBludger() 
    {
        if (tieneQuaffle) 
        {
            tieneQuaffle = false
        }
    }

    // -------------------------------

    method turnoDeJugar(equipoContrario) 
    {
        if(self.puedeBloquearA(equipoContrario))
        {
            equipo.ganarPuntos(10)
            self.aumentarSkills(5)
        }else{
            self.perderSkills(2)
            // el q bloqueo gana 10 puntos
        }

        tieneQuaffle = false
    }
    
    method puedeBloquearA(equipoContrario) = equipoContrario.forEach { integrante => integrante.puedeBloquear(self) }
}

class Buscador inherits Jugador
{
    var property kmRecorridos
    var property estaBuscandoLaSnitch  
    var property cantidadDeTurnosBuscandoLaSnitch

    override method habilidadSegunPosicion() = nivelDeReflejos * nivelDeVision

    // Punto 4 a
    method puedeBloquear(cazador) {} // sin comportamiento

    // Punto 4 b
    method esBlancoUtil() = self.estaBuscandoLaSnitch() || kmRecorridos < 1000

    method estaBuscandoLaSnitch() = estaBuscandoLaSnitch

    // -------------------------------

    method turnoDeJugar(equipoContrario)
    {
        if(estaBuscandoLaSnitch)
        {
            self.verSiEncontroLaSnitch()
            self.aumentarSkills(10)
            equipo.ganarPuntos(150)

        }else{
            kmRecorridos += 5000
            //  En cada turno recorre una cantidad de kms igual a su velocidad / 1,6.
        }
    }
    
    method verSiEncontroLaSnitch() = self.valorRandom(1, 1000) == self.cantidadDeHabilidaYTurnos()

    method cantidadDeHabilidaYTurnos() = skills + cantidadDeTurnosBuscandoLaSnitch

    // Punto 4 c
    // override method golpeadoPorBludger() = // deben reiniciar la busqueda 
}

class Golpeador inherits Jugador
{
    override method habilidadSegunPosicion() = punteria + fuerza 

    // Punto 4 a
    method puedeBloquear(cazador) = self.esGroso()

    // Punto 4 b
    method esBlancoUtil() {} // sin comportamiento

    // -------------------------------

    method turnoDeJugar(equipoContrario)
    {
        const blancoUtil = equipoContrario.anyOne() { integrante => integrante.esBlancoUtil() }

        if(self.puedeGolpearA(blancoUtil))
        {
            blancoUtil.golpeadoPorBludger()
            self.aumentarSkills(5)
        }
    }

    method puedeGolpearA(blancoUtil) = punteria > blancoUtil.nivelDeReflejos() || self.valorRandom(1, 10) >= 8
}

class Guardian inherits Jugador
{
    override method habilidadSegunPosicion() = nivelDeReflejos + fuerza

    method turnoDeJugar()

    // Punto 4 a
    method puedeBloquear(cazador) = self.valorRandom(1, 3) == 3

    // Punto 4 b
    method esBlancoUtil() = !equipo.tieneLaQuaffle()

    // -------------------------------

    method turnoDeJugar(equipoContrario) {} // sin comportamiento
}

// Para hacer los turnos deberia hacer esta clase 
class BuscandoSnitch {

	var turnos = 0

	method hacerQueJuegue(unJugador) {
		turnos++
		if (self.pudoEncontrarLaSnitch(unJugador)) {
			unJugador.perseguirSnitch()
		}
	}

	method pudoEncontrarLaSnitch(unJugador) = (1 .. 1000).anyOne() < unJugador.habilidad() + turnos

	method esBlancoUtil() = true
    
}

class PersiguiendoSnitch {

	var kilometrosRecorridos = 0

	method hacerQueJuegue(unJugador) {
		self.recorrerKilometros(unJugador)
		if (kilometrosRecorridos >= 5000) {
			unJugador.agarrarSnitch()
		}
	}

	method recorrerKilometros(unJugador) {
		kilometrosRecorridos += unJugador.velocidad() / 1.6
	}

	method esBlancoUtil() = kilometrosRecorridos > 4000

}

class Aturdido {

	const estadoActual
	var pasoUnTurnoAturdido = false

	method hacerQueJuegue(unJugador) {
		if (pasoUnTurnoAturdido) unJugador.volverAlEstado(estadoActual)
		pasoUnTurnoAturdido = true
	}

	method esBlancoUtil() = estadoActual.esBlancoUtil()

}

// -------------------------------

class MercadoDeEscobas
{
    var property valorArbitrario
}

class Nimbus
{
    const property anioDeCreacion
    var property porcentajeDeSalud

    method velocidadEscoba() = self.aniosDesdeCreacion() * (porcentajeDeSalud / 100)

    method aniosDesdeCreacion() = new Date().year() - anioDeCreacion

    method recibirGolpe() = porcentajeDeSalud * 0.9
}

class SaetaDeFuego
{
    const property velocidad = 100

    method velocidadEscoba() = velocidad

    method recibirGolpe() {} // sin comportamiento
}