// Las personas tienen una lista de sueños cumplidos vs pendientes, cada sueño le otorga un nivel de felicidad

// Sueños a cumplir:
//     1. Recibirse de una carrera
//     2. Tener un hijo.
//     3. Adoptar una cantidad x de hijos.
//     4. Viajar a un lugar
//     5. Conseguir un laburo donde se gane una cantidad x de plata

// Tambien se puede tener sueños múltiples, que permite unir varios sueños
// Si no se pueden cumplir alguno de ellos debería tirar error y no cumplir ninguno.

// Hay distintos tipos de personas
    // 1. Los realistas cumplen la meta más importante para ellos -> se calcula en base al nivel de felicidad que le brinda al que cumple dicho sueño
    // 2. Los alocados quieren cumplir un sueño cualquiera al azar 
    // 3. Los obsesivos cumplen el primer sueño de la lista. 

class Persona
{
    var property suenios = []
    var property tipoDePersona
    var property felicidadTotal
    var property carrerasCompletadas = []
    var property cantidadDeHijos 
    var property lugaresVisitados = [] 

    // Punto 1)
    method cumplir(suenio)
    {
        if( !self.sueniosPendientes().contains(suenio) )
        {
            throw new Exception(message = "No se puede cumplir el sueño")
        }

        suenio.cumplirSuenioDe(self)
    }

    method sueniosPendientes() = suenios.filter { suenio => suenio.pendiente()}

    method completoLaCarrera(carrera) = carrerasCompletadas.contains(carrera)

    method completarCarrera(carrera)
    {
        carrerasCompletadas.add(carrera)
    }

    method quiereEstudiar(carrera) = self.suenios().contains(carrera)

    method tieneHijos() = cantidadDeHijos > 0

    method agregarHijos(cantidadADoptar) 
    {
        cantidadDeHijos += cantidadADoptar
    }

    method viajarA(lugar)
    {
        lugaresVisitados.add(lugar)
    }

    method sumarFelicidad(felicidad) 

    // Punto 2)

    // Punto 3)
    method cumplirSuenioElegido()
    {
        const suenio = tipoDePersona.elegirSuenio(self.sueniosPendientes())
        self.cumplir(suenio)
    }

    // Punto 4)
    method esFeliz() = felicidadTotal > self.sueniosPendientes().sum { suenio => suenio.felicidad() } 

    // Punto 5)
    method esAmbiciosa() = self.sueniosAmbiciosos().size() > 3

    method sueniosAmbiciosos() = suenios.filter { suenio => suenio.esAmbicioso() }
}

class Suenio
{
    var property cumplio = false

    method pendiente() = !cumplio

    // Uso de: Template method

    // Los métodos validar y realizar son abstractos, aunque validar podría también ser un método vacío, 
    // para cuando algún sueño no tenga validaciones (es más difícil justificar que el método relizar no 
    // tenga comportamiento, entonces qué sentido tendría modelar una subclase de Sueño).

    method cumplirSuenioDe(persona)
    {
        self.validar(persona)
        self.realizar(persona)
        self.cumplir(persona)
        persona.sumarFelicidad(self.felicidad())
    }

    method validar(persona) 

    method realizar(persona)

    method cumplir(persona)
    {
        cumplio = true
    }

    method felicidad() 

    // Punto 5)
    method esAmbicioso() = self.felicidad() > 100
}

class Recibirse inherits Suenio
{
    var property carrera

    override method validar(persona)
    {
        if( persona.completoLaCarrera(carrera))
        {
            throw new Exception(message = "ya se completo la carrera")
        }

        if( !persona.quiereEstudiar(carrera))
        {
            throw new Exception(message = "No se desea estudiar esa carrera")
        }
    }

    override method realizar(persona)
    {
        persona.completarCarrera(carrera)
    }
}

class EncontrarTrabajo inherits Suenio
{
    var property sueldoACobrar
    var property sueldoDeseado

    override method validar(persona)
    {
        if(sueldoACobrar >= sueldoDeseado)
        {
            throw new Exception(message = "No se puede cumplir el sueño")
        }
    }

    override method realizar(persona)
    {
        // sin comportamiento
    }
}

class AdoptarHijo inherits Suenio
{
    var property cantidadADoptar

    override method validar(persona)
    {
        if(!persona.tieneHijos())
        {
            throw new Exception(message = "No se puede cumplir el sueño")
        }
    }

    override method realizar(persona)
    {
        persona.agregarHijos(cantidadADoptar)
    }
}

class Viajar inherits Suenio
{
    var property lugar

    override method validar(persona)
    {
        // sin comportamiento
    }

    override method realizar(persona)
    {
        persona.viajarA(lugar)
    }
}

// Punto 2)

class SuenioSimple 
{
    var property felicidadQueOtorga

    // los sueños múltiples deben sumar los felicidonios de sus sueños
    method felicidad() = felicidadQueOtorga
}

class SuenioCompuesto inherits Suenio
{
    const suenios = []

    override method felicidad() = suenios.sum { suenio => suenio.felicidad() } 

    override method validar(persona)
    {
        suenios.forEach() { suenio => suenio.validar(persona) }
    }

    override method realizar(persona)
    {
        suenios.forEach() { suenio => suenio.realizar(persona) }
    }   
}

// Punto 3)
object realista
{
    method elegirSuenio(sueniosPendientes)
    {
        sueniosPendientes.max {suenio => suenio.felicidad()}
    }
}

object alocado
{
    method elegirSuenio(sueniosPendientes)
    {
        sueniosPendientes.anyOne()
    }
}

object obsesivo
{
    method elegirSuenio(sueniosPendientes)
    {
        sueniosPendientes.first()
    }
}