class Persona
{
    var property posicion = []
    var property elementosCercanos = []
    var property comidaIngerida = []
    var property criterioSegunPosicion = sordo // necesito inicializarlo aca o segun cada persona cuando hereda de la clase
    var property criterioSegunComida = vegetariano // idem ant.

    method pedir(elemento, personaQueDa)
    {
        if(!personaQueDa.tieneElemento(elemento))
        {
            throw new Exception (message = "No tiene ese elemento cercano")
        }
        criterioSegunPosicion.criterioSegunPersona(self, personaQueDa, elemento)
    }

    method tieneElemento(elemento) = elementosCercanos.contains(elemento)

    // En lugar de usar el method abstracto, para usar herencia (template method) uso composicion, 
    // porque sino cuando modelo a las personas tengo que tambien definir este method abstracto.
    // Ademas, ya estoy trabajndo con una clase que luego tiene herencia de los tipos de criterios de las personas

    // method criterioSegunPersona(personaQuePide, personaQueDa, elemento)  

    method pasarPrimerElemento() = elementosCercanos.first()

    method pasarTodosLosElementos() = elementosCercanos.all()

    method pasarElemento(elemento) = elementosCercanos.contains(elemento)

    method agregarElemento(elemento) 
    {
        elementosCercanos.add(elemento)
    }

    method quitarElemento(elemento)
    {
        elementosCercanos.remove(elemento)
    }

    method comerUnaComida(comida)
    {
        if(criterioSegunComida.puedeComer(comida))
        {
            comidaIngerida.add(comida)
        }
    }

    // method puedeComer(comida) idem ant.

    method estaPipon() = comidaIngerida.any {comida => comida.esPesada()}

    method laEstaPadandoBien(persona) = self.comioAlgo() && persona.felicidadSegunPersona()

    method comioAlgo() = comidaIngerida.isNotEmpty()
    
    method felicidadSegunPersona()
}

// ----------------------------------------------

class CriterioAlPasarElemento
{
    method criterioSegunPersona(personaQuePide, personaQueDa, elemento)
    {
        self.criterioSegun(personaQueDa, elemento)
        personaQuePide.agregarElemento(elemento)
        personaQueDa.quitarElemento(elemento)
    }

    method criterioSegun(personaQueDa, elemento)
}

object sordo inherits CriterioAlPasarElemento
{
    override method criterioSegun(personaQueDa, elemento) = personaQueDa.pasarPrimerElemento()
}

object pasarTodosElementos inherits CriterioAlPasarElemento
{
    override method criterioSegun(personaQueDa, elemento) = personaQueDa.pasarTodosLosElementos()
}

object cambiarPosicionEnMesa 
{
    method criterioSegun(personaQuePide, personaQueDa, elemento)
    {
        const posicionDeQuienPide = personaQuePide.posicion()
        personaQueDa.posicion(posicionDeQuienPide)
        personaQuePide.posicion(personaQueDa.posicion())
    }
}

object pasarElemento inherits CriterioAlPasarElemento
{
    override method criterioSegun(personaQueDa, elemento) = personaQueDa.pasarElemento(elemento)
}

// ----------------------------------------------

class Comida
{
    const property calorias
    const property esCarne

    method esPesada() = calorias > 500
}

object vegetariano
{
    method puedeComer(comida) = !comida.esCarne()
}

object dietetico
{
    const property caloriasMaximas = 500
    method puedeComer(comida) = comida.calorias() < caloriasMaximas
}

class Alternado
{
    var property acepta 
    
    method puedeComer(comida)
    {
        acepta = !acepta
        return acepta
    }
}

class CombinarCondiciones
{
    const property condiciones = []

    method puedeComer(comida) = condiciones.all {condicion => condicion.puedeComer(comida)}
    
    method agregarCondicion(condicion)
    {
        condiciones.addAll(condicion)
    }
}

// ----------------------------------------------

object osky inherits Persona
{
    override method felicidadSegunPersona() = true 

    // override method criterioSegunPersona(personaQuePide, personaQueDa, elemento) {} // sin comportamiento 
}

object moni inherits Persona
{
    override method felicidadSegunPersona() = posicion.contains(game.at(1, 1))

    // override method criterioSegunPersona(personaQuePide, personaQueDa, elemento) {} // sin comportamiento 
}

object facu inherits Persona
{
    override method felicidadSegunPersona() = comidaIngerida.any {comida => comida.esCarne()}

    // override method criterioSegunPersona(personaQuePide, personaQueDa, elemento) {} // sin comportamiento 
}

object vero inherits Persona
{
    override method felicidadSegunPersona() = elementosCercanos.size() <= 3

    // override method criterioSegunPersona(personaQuePide, personaQueDa, elemento) {} // sin comportamiento 
}