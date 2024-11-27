class Lugar
{
    const property nombre

    method esDivertido() = self.cantidadDeLetrasPar() && self.condicionSegunLugar()

    method cantidadDeLetrasPar() = nombre.length() % 2 == 0
    
    method condicionSegunLugar()

    method esTranquilo() 

    method esRaro() = nombre.size() > 10 
}

class Ciudad inherits Lugar
{
    const property atracciones = []
    var property habitantes 
    const property decibelesPromedio

    override method condicionSegunLugar() = atracciones.size() > 3 && habitantes > 100000

    override method esTranquilo() = decibelesPromedio < 20
}

class Pueblo inherits Lugar
{
    const property fechaDeFundacion
    const property provincia
    const property extensionEnKm

    override method condicionSegunLugar() = fechaDeFundacion < 1800 && self.esDelLitoral()

    method esDelLitoral() = ["Corrientes", "Misiones", "Entre Rios"].contains(provincia)

    override method esTranquilo() = provincia == "La Pampa"
}

class Balneario inherits Lugar
{
    var property metrosDePlaya
    var property marEsPeligroso
    const property tienePeatonal

    override method condicionSegunLugar() = metrosDePlaya > 300 && marEsPeligroso 

    override method esTranquilo() = !tienePeatonal
}

// --------------------------------------------

class Persona
{
    const property preferencia
    var property presupuestoMaximo

    method leGustariaIrA(lugar) = preferencia.any { criterio => criterio.cumplePreferencia(lugar) }

    method puedePagarlo(montoPorPersona) = presupuestoMaximo >= montoPorPersona
}

object lugarTranquilo
{
    method cumplePreferencia(lugar) = lugar.esTranquilo()
}

object lugarDivertido
{
    method cumplePreferencia(lugar) = lugar.esDivertido()
}

object lugarRaro
{
    method cumplePreferencia(lugar) = lugar.esRaro()
}

class CombinarCriterios
{
    const property criterios = [] 

    method cumplePreferencia(lugar) = criterios.any { criterio => criterio.cumplePreferencia(lugar) }
}

// --------------------------------------------

class Tour
{
    const property fechaDeSalida 
    const property personasRequeridas
    const property lugaresAVisitar = []
    const property montoPorPersona 
    const property personasAnotadas = []
    const property listaDeEspera = []

    method agregarPersona(persona)
    {
        self.validarSiLoPuedePagar(persona)
        self.validarLugaresAdecuados(persona)
        self.verificarPersonasRequeridas(persona)
        personasAnotadas.add(persona)
    }

    method validarSiLoPuedePagar(persona)
    {
        if(!persona.puedePagarlo(montoPorPersona))
        {
            throw new Exception(message = "La persona no puede pagar el tour")
        }
    }

    method validarLugaresAdecuados(persona)
    {
        if(!self.visitarTodosLosLugares(persona))
        {
            throw new Exception(message = "Alguno de los lugares no es adecuado para la persona")
        }
    }

    method visitarTodosLosLugares(persona) = lugaresAVisitar.all { lugar => persona.leGustariaIrA(lugar) }

    method verificarPersonasRequeridas(persona)
    {
        if(!self.hayLugar())
        {   
            listaDeEspera.add(persona)
            throw new Exception(message = "No hay lugar para el tour. Queda en lista de espera")
        }
    }

    method hayLugar() = personasAnotadas.size() < personasRequeridas

    method bajarseDeTour(persona)
    {
        personasAnotadas.remove(persona)
        self.sacarPersonaDeEspera()       
    }

    method sacarPersonaDeEspera() 
    {      
        if(listaDeEspera.size() > 0)
        {
            const personaEnEspera = listaDeEspera.first()
            personasAnotadas.add(personaEnEspera)
            listaDeEspera.remove(personaEnEspera)
        }
    }

    method gananciaDelTour() = personasAnotadas.size() * montoPorPersona

    method esDeEsteAnio() = fechaDeSalida == new Date().year()
}

// --------------------------------------------

class Reporte
{
    const property tours = []

    method toursPendientesDeConfirmar() = tours.filter { tour => tour.hayLugar() }

    method toursQueSalenEsteAnio() = self.laSalidaEsEsteAnio().sum { tour => tour.gananciaDelTour() }

    method laSalidaEsEsteAnio() = tours.filter { tour => tour.esDeEsteAnio() }
}