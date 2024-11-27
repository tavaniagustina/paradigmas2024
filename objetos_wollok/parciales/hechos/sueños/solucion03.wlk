class Persona
{
    // var property edad 
    const property carrerasAEstudiar = []
    const property carrerasQueEstudio = []
    const property plataQueDeseaGanar
    const property lugaresVisitados = []
    var property cantidadDeHijos
    const property suenios = []
    var property nivelDeFelicidad
    var property tipoDePersona

    method cumplirSuenio(suenio)
    {
        if(!self.puedeCumplirSuenio(suenio))
        {
            throw new Exception(message = "No se puede cumplir el sueño")
        }
    }

    method puedeCumplirSuenio(suenio) = 
        if(suenios.pendientes(suenio))
        {
            // self.verSiLoPuedeCumplir(suenio, self)
            suenio.verSiLoPuedeCumplir(self)

        }
    
    method verSiLoPuedeCumplir(persona)

    method quiereEstudiarEsaCarrera(carrera) = carrerasAEstudiar.contains(carrera)

    method yaEstudioLaCarrera(carrera) = carrerasQueEstudio.contains(carrera)

    method recibirseDe(carrera)
    {
        carrerasQueEstudio.add(carrera)
    }

    method tieneHijos() = cantidadDeHijos > 0

    method agregarHijos(cantidad)
    {
        cantidadDeHijos += cantidad
    }

    method viajarA(lugar)
    {
        lugaresVisitados.add(lugar)
    }

    method ganaPlataSuficiente(plataAGanar) = plataAGanar >= plataQueDeseaGanar

    method cumplirSuenioMasPreciado()
    {
        const suenioAElegir = tipoDePersona.suenioACumplir(suenios)
        self.cumplirSuenio(suenioAElegir)
    }

    method esFeliz() = nivelDeFelicidad > self.nivelDeFelicidonios() 

    method nivelDeFelicidonios() = suenios.sum { suenio => suenio.felicidonios() }

    method esAmbiciosa() = self.sueniosAmbiciosos().size() > 3

    method sueniosAmbiciosos() = suenios.filter { suenio => suenio.esAmbicioso() }
}   

class Suenio
{
    var property cumplido 

    method pendientes(suenio) = !cumplido

    method verSiLoPuedeCumplir(persona)
    {
        self.cumpleCondiciones(persona)
        self.realizarSuenio(persona)
        self.cumplirSuenio(persona)
        persona.sumarFelicidad(self.felicidonios())
    }

    method cumpleCondiciones(persona)

    method realizarSuenio(persona)

    method cumplirSuenio(persona) { cumplido = true }

    method felicidonios()

    method esAmbicioso() = self.felicidonios() > 100
}

class Recibirse inherits Suenio
{
    var property carrera

    override method cumpleCondiciones(persona) 
    {
        self.quiereEstudiarEsaCarrera(persona)
        self.verificarQueNoLaEstudio(persona)
    }

    method quiereEstudiarEsaCarrera(persona)
    {
        if(!persona.quiereEstudiarEsaCarrera(carrera))
        {
            throw new Exception(message = "No quiere estudiar esa carrera")
        }
    }

    method verificarQueNoLaEstudio(persona)
    {
        if(persona.yaEstudioLaCarrera(carrera))
        {
            throw new Exception(message = "Ya estudio esa carrera")
        }
    }

    override method realizarSuenio(persona)
    {
        persona.recibirseDe(carrera)
    }
}

class TenerUnHijo inherits Suenio
{
    override method realizarSuenio(persona)
    {
        persona.agregarHijos(1)
    }
}

class Adoptar inherits Suenio
{
    var property cantidadDeHijos

    override method cumpleCondiciones(persona)
    {
        if(!persona.tieneHijos())
        {
            throw new Exception(message = "Ya tiene hijos")
        }
    }

    override method realizarSuenio(persona)
    {
        persona.agregarHijos(cantidadDeHijos)
    }
}

class Viajar inherits Suenio
{
    var property lugar

    override method realizarSuenio(persona)
    {
        persona.viajarA(lugar)
    }
}

class Trabajar inherits Suenio
{
    var property plataAGanar

    override method cumpleCondiciones(persona)
    {
        if(!persona.ganaPlataSuficiente(plataAGanar))
        {
            throw new Exception(message = "No gana plata suficiente")
        }
    }
}

class SuenioSimple
{
    var property felicidonios
    method felicidinios() = felicidonios
}

class SuenioMultiple
{
    var property suenios = []

    method felicidonios() = suenios.sum { suenio => suenio.felicidonios() }

    method cumpleCondiciones(persona) = suenios.forEach { suenio => suenio.cumpleCondiciones(persona) }

    method realizarSuenio(persona) = suenios.forEach { suenio => suenio.realizarSuenio(persona) }

    method cumplirSuenio(persona) = suenios.forEach { suenio => suenio.cumplirSuenio(persona) }
}

object realista
{
    method suenioACumplir(suenios) = suenios.max { suenio => suenio.felicidonios() }
}

object alocado
{
    method suenioACumplir(suenios) = suenios.anyOne()
}

object obsesivos
{
    method suenioACumplir(suenios) = suenios.first()
}