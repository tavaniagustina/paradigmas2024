// Punto 1
class Persona
{
    var property edad
    var property plataQueQuiereGanar
    var property hijos = #{}
    var property suenios = #{}
    var property carrerasTerminadas = #{}
    const property lugaresVisitados = #{}
    var property felicidadTotal
    var property tipoDePersona
    
    method cumplirSuenio(suenio)
    {
        if(!self.sueniosPorCumplir().contains(suenio))
        {
            throw new Exception(message = "La persona no tiene ese sueño")
        }

        suenio.cumplirSuenioDe(self)
    }

    method sueniosPorCumplir() = suenios.filter { suenio => suenio.pendiente() }

    method quiereEstudiarCarrera(carrera) = suenios.contains(carrera)
    
    method completoCarrera(carrera) = carrerasTerminadas.contains(carrera)

    method completarCarrera(carrera)
    {
        carrerasTerminadas.add(carrera)
    }

    method tenerHijo(hijo) 
    { 
        hijos.add(hijo) 
    }

    method viajar(destino) 
    {
        lugaresVisitados.add(destino)
    }

    method dineroAGanar(sueldo) = plataQueQuiereGanar >= sueldo

    method eliminarSuenioDeLista(suenio)
    {
        suenios.remove(suenio)
    }

    method tieneHijos() = hijos.size() > 0

    method adoptar(cantidadADoptar) 
    {
        hijos += cantidadADoptar
    }

    method sumarFelicidad(felicidad) 
    {
        felicidadTotal += felicidad
    }   

    // Punto 3
    method cumplirSuenioElegido()
    {
        const suenio = tipoDePersona.elegirSuenio(self.sueniosPorCumplir())
        self.cumplirSuenio(suenio)
    }  

    // Punto 4
    method esFeliz() = felicidadTotal > self.sueniosPorCumplir().sum { suenio => suenio.felicidad() }
    
    // Punto 5
    method esAmbiciosa() = self.suenioAmbicioso().size() > 3

    method suenioAmbicioso() = suenios.any { suenio => suenio.esAmbicioso()}
}

class Suenio 
{
    var property cumplido = false

    method pendiente() = !cumplido

    method cumplirSuenioDe(persona)
    {
        self.validarSuenio(persona)
        self.realizarSuenio(persona)
        self.cumplirSuenio(persona)
        persona.sumarFelicidad(self.felicidad())
        persona.eliminarSuenioDeLista(self)
    }

    method validarSuenio(persona)
    method realizarSuenio(persona)
    method cumplirSuenio(persona) { cumplido = true }
    method felicidad()

    // Punto 5
    method esAmbicioso() = self.felicidad() > 100
}

class Recibirse inherits Suenio
{
    var property carrera 

    override method validarSuenio(persona)
    {
        if(!persona.quiereEstudiarCarrera(carrera))
        {
            throw new Exception(message = "La persona no quiere estudiar esa carrera")
        }

        if(persona.completoCarrera(carrera))
        {
            throw new Exception(message = "La persona ya se recibio de esa carrera")
        }
    }

    override method realizarSuenio(persona) = persona.completarCarrera(carrera)
}

class TenerUnHijo inherits Suenio
{
    const property hijo

    override method validarSuenio(persona) {} // sin comportamiento, ya fue validado q se desea cumplir este suenio 

    override method realizarSuenio(persona) = persona.tenerHijo(hijo)
}

class AdoptarHijo inherits Suenio
{
    var property cantidadADoptar
    
    override method validarSuenio(persona) =
        if(persona.tieneHijos())
        {
            throw new Exception(message = "La persona ya tiene hijos")
        }

    override method realizarSuenio(persona) = persona.adoptar(cantidadADoptar)
}

class Viajar inherits Suenio
{
    var property destino 

    override method validarSuenio(persona) {} // sin comportamiento

    override method realizarSuenio(persona) = persona.viajar(destino)
}

class EncontrarTrabajo inherits Suenio
{
    var property sueldo

    override method validarSuenio(persona)
    {
        if(!persona.dineroAGanar(sueldo))
        {
            throw new Exception(message = "La persona no quiere ganar esa cantidad de dinero")
        }
    }

    override method realizarSuenio(persona) {} // sin comportamiento
}

// Punto 2
class SuenioSimple
{
    var property felicidad 

    method felicidad() = felicidad
}

class SuenioMultiple inherits Suenio
{
    var property suenios = []

    override method felicidad() = suenios.sum { suenio => suenio.felicidad() }

    override method validarSuenio(persona) = suenios.forEach { suenio => suenio.validarSuenio(persona) }

    override method realizarSuenio(persona) = suenios.forEach { suenio => suenio.realizarSuenio(persona) }
}

// Punto 3
object realista
{
    method elegirSuenio(sueniosPendientes)
    {
        sueniosPendientes.max { suenio => suenio.felicidad() }
    }
}

object alocados
{
    method elegirSuenio(sueniosPendientes)
    {
        sueniosPendientes.anyOne()
    }
}

object obsesivos
{
    method elegirSuenio(sueniosPendientes)
    {
        sueniosPendientes.first()
    }   
}