class Lugar
{
    var property nombre

    method esDivertido() = self.cantidadDeLetras().even() && self.condicionParticular()

    method cantidadDeLetras() = nombre.length() 

    method condicionParticular()

    method esTranquilo()

    method esRaro() = self.cantidadDeLetras() > 10
}

class Ciudad inherits Lugar
{
    var property cantidadDeHabitantes
    const property atracciones = #{} 
    const property decibelesPromedio 
    
    override method condicionParticular() = atracciones.size() > 3 && cantidadDeHabitantes > 1000

    override method esTranquilo() = decibelesPromedio < 20
}

class Pueblo inherits Lugar
{
    const property extensionEnKm
    const property fechaDeFundacion
    const property provincia

    override method condicionParticular() = fechaDeFundacion < 1800 || self.esDelLitoral()

    method esDelLitoral() = ["Entre Rios", "Corrientes", "Misiones"].includes(provincia)

    override method esTranquilo() = provincia == "La Pampa"
}

class Balneario inherits Lugar
{
    const property metrosDePlayaPromedio
    const property marPeligroso
    const property tienePeatonal

    override method condicionParticular() = metrosDePlayaPromedio > 300 && marPeligroso

    override method esTranquilo() = !tienePeatonal
}

// una persona tiene UNA preferencia 
// tambien puede tener una combinacion de las preferencias
class Persona
{
    const property preferencia  
    var property presupuestoMaximo

    method elige(lugar) = preferencia.elige(lugar)

    method puedePagar(montoPorPersona) = presupuestoMaximo >= montoPorPersona
}

object tranquilidad
{
    method elige(lugar) = lugar.esTranquilo()
}

object diversion
{
    method elige(lugar) = lugar.esDivertido()
}

object lugarRaros
{
    method elige(lugar) = lugar.esRaro()
}

class CombinacionDePreferencias
{
    var property preferencias = #{}

    method elige(lugar) = preferencias.any { preferencia => preferencia.elige(lugar) }
}

class Tour
{
    const property fechaDeSalida
    const property cantidadDePersonasRequeridas
    const property ciudadesARecorrer = #{}
    const property montoPorPersona
    const property integrantes = #{}
    const property listaDeEspera = #{}

    method agregarPersona(persona) 
    {
        self.puedePagarElTour(persona)
        self.todosSonLugaresAdecuados(persona)
        self.validarCupo(persona)
        integrantes.add(persona)
    }

    method puedePagarElTour(persona) 
    {
        if(!persona.puedePagar(montoPorPersona))
        {
            throw new Exception(message = "No puede pagar el tour")
        }
    }

    method todosSonLugaresAdecuados(persona)
    {
        if(!self.eligeLugares(persona))
        {
            throw new Exception(message = "No todos los lugares son adecuados")
        }
    }

    method eligeLugares(persona) = ciudadesARecorrer.all { lugar => persona.elige(lugar) }

    method validarCupo(persona)
    {
        if(!self.hayLugar())
        {
            listaDeEspera.add(persona)
            throw new Exception(message = "No hay cupo. Quedas en lista de espera")
        }
    }

    method hayLugar() = cantidadDePersonasRequeridas > integrantes.size()

    // entiendo que va en los tests este method
    method bajarPersona(persona)
    {
        integrantes.remove(persona)
        self.agregarPersonaEnEspera()
    }

    method agregarPersonaEnEspera()
    {
        const nuevoIntegrante = listaDeEspera.first()
        listaDeEspera.remove(nuevoIntegrante)
        integrantes.add(nuevoIntegrante)
    }
    
    method montoTotal() = montoPorPersona * integrantes.size()

    method laSalidaEsEsteAnio() = fechaDeSalida == new Date().year()
}

class Reporte
{
    const property tours = #{}

    method toursPendientesDeConfirmar() = tours.filter { tour => tour.hayLugar() }

    method toursQueSalenEsteAnio() = self.toursDeEsteAnios().sum { tour => tour.montoTotal() }

    method toursDeEsteAnios() = tours.filter { tour => tour.laSalidaEsEsteAnio() }
}