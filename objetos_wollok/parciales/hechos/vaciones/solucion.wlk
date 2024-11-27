// Hay distintos tipos de lugares
    // ciudades: tienen una cantidad de habitantes, atracciones turisticas y cantidad de decibeles promedio 
    // pueblos: extension en km, cuando se fundo, provincia en q se ubica
    // balnearios: metros de playa promedio, si el mar es peligroso y si tiene peatonal

// lugar divertido: si tiene una cantidad par de letras 
    // ciudades: si tienen mas de tres atracciones turisticas Y mas de 1000 habitantes
    // pueblos: si se fundaton antes de 1800 O si son del litoral
    // balnearios: si tiene mas de 300m de playa Y el mar es peligroso

// Las personas tienen preferencias para las vacaciones, algunos quieren:
    // tranquilidad: el lugar debe ser tranquilo. 
        // ciudad: debe tener menos de 20 decibeles
        // pueblo: tiene q estar en la Pampa
        // balneario: no debe tener peatonal
    
    // diversion: el lugar debe ser divertido

    // lugares raros: lugares con nomnre de mas de 10 letras 

    // combinar varios criterios:

// hay tours que tienen
    // una fecha de salida, cantidad de personas requeridas, lista de ciudades a recorrer y el monto por persona


class Lugar
{
    var property nombre

    method esDivertido(lugar) 
    {
        lugar.tieneCantidadParDeLetras()
        lugar.esDivertido()
    }

    method tieneCantidadParDeLetras() = self.cantidadDeLetras() % 2 == 0

    method preferencia(lugar) = lugar.esTranquilo() || lugar.esDivertido() || self.esRaro()

    method esRaro() = self.cantidadDeLetras() > 10

    method cantidadDeLetras() = nombre.size()
    
}

class Ciudad
{
    var property habitantes
    const property atraccionesTuristicas = []
    const property decibelesPromedio

    method esDivertido() = atraccionesTuristicas.size() > 3 && habitantes > 1000
    
    method esTranquilo() = decibelesPromedio < 20

}

class Pueblo
{
    const property extension
    const property fundacion
    const property provincia

    method esDivertido() = fundacion < 1800 || provincia == self.esDelLitoral()

    method esDelLitoral() = ["Entre Rios", "Corrientes", "Santa Fe"].contains(provincia)
    
    method esTranquilo() = provincia == "La Pampa"

}

class Balneario
{
    var property metrosDePlaya
    var property marPeligroso
    const property peatonal

    method esDivertido() = metrosDePlaya > 300 && marPeligroso

    method esTranquilo() = !peatonal
}

class Persona
{
    var property preferencias = []
    var property presupuesto 

    // Esto tambien es para combinar varios criterios
    method irseDeVacacionesA(lugar) = preferencias.any { preferencia => lugar.preferencia(lugar) }

    method puedePagar(montoAPagar) = presupuesto >= montoAPagar
}

class Tour
{
    var property fechaDeSalida
    var property maximaCantidadDePersonasPorTour
    var property destinos = [] 
    var property montoAPagar
    const property integrantes = []
    var property toursDisponibles = []
    const property listaDeEspera

    method agregarPersona(persona)
    {   
        // Un método cohesivo se concentra en resolver una cosa a la vez, por lo q no es correcta esta solucion, ser mas especifica con el mensaje
        // if(self.cumpleConLasCondiciones(persona) && integrantes.size() <= maximaCantidadDePersonasPorTour)
        // {
        //     integrantes.add(persona)
        // }else{
        //     throw new Exception (message = "No hay lugar para el tour") 
        // }

        // if((!persona.puedePagar(montoAPagar)))
        // {
        //     throw new Exception (message = "No puede pagar el tour")
        // }

        // if((!self.eligeLugares(persona)))
        // {
        //     throw new Exception (message = "Alguno de los destinos no cumple con sus gustos")
        // }

        // if(!self.tourConDisponibilidad())
        // {
        //     throw new Exception (message = "No hay lugar para el tour")
        // }

        self.validarSiPuedePagar(persona)
        self.validarSiLeGustaLosDestinos(persona)
        self.validarSiHayDisponibilidad(persona)

        integrantes.add(persona)
    }

    method validarSiPuedePagar(persona) =
        if((!persona.puedePagar(montoAPagar)))
        {
            throw new Exception (message = "No puede pagar el tour")
        }

    method validarSiLeGustaLosDestinos(persona) =
        if((!self.eligeLugares(persona)))
        {
            throw new Exception (message = "Alguno de los destinos no cumple con sus gustos")
        }

    method validarSiHayDisponibilidad(persona) 
    {
        if(!self.tourConDisponibilidad())
        {
            listaDeEspera.add(persona)
            throw new Exception (message = "El tour esta confirmado. Quedas en lista de espera")
        }   
    }

    method eligeLugares(persona) = destinos.all { lugar => persona.irseDeVacacionesA(lugar) }

    method bajarPersona(persona) 
    {
        integrantes.remove(persona)
        self.agregarPersonaEnEspera()
    }

    method agregarPersonaEnEspera()
    {   
        const nuevoIntegrante = listaDeEspera.firts()
        listaDeEspera.remove(nuevoIntegrante)
        integrantes.add(nuevoIntegrante)
    }

    method tourConDisponibilidad() = integrantes.size() < maximaCantidadDePersonasPorTour

    method cumpleCondiciones() = integrantes.size() * montoAPagar 

    method esDeEsteAnio() = fechaDeSalida == new Date().year()

    method montoTotal() = integrantes.size() * montoAPagar
}

// si es class va a poder existir multiples instancias de la misma -> se general problemas
// con un object solo voy a tener una unica instancia. si tenfo q agregar un nuevo tour se lo mando a tour y listo.
object reporte
{
    const property toursDisponibles = []

    method toursPendientesAConfirmar() = toursDisponibles.filter { tour => tour.tourConDisponibilidad() }

    method montoTotal() = self.toursQueSalenEsteAnio().sum { tour => tour.montoTotal() }

    method toursQueSalenEsteAnio() = toursDisponibles.filter { tour => tour.esDeEsteAnio() }
}