class Persona
{
    const property nombre
    var property posicion
    var property elementosCercanos = []
    var property criterioParaDarElemento

    method pedirElemento(elemento, personaQuePide)
    {
        if(!self.tieneElemento(elemento))
        {
            throw new Exception(message = "No tengo cerca el elemento")
        }
        criterioParaDarElemento.darElemento(elemento, self, personaQuePide)
    }

    method tieneElemento(elemento) = elementosCercanos.contains(elemento)

    method agregarElemento(elementoAPasar) 
    {
        elementosCercanos.add(elementoAPasar)
    }

    method quitarElemento(elementoAPasar)
    {
        elementosCercanos.remove(elementoAPasar)
    }

    method primerElementoCercano() = elementosCercanos.first()

}

class CriterioParaDarElemento
{
    method darElemento(elemento, personaQueDa, personaQueRecibe)
    {
        const elementoAPasar = self.elementosAPasar(elemento, personaQueDa)
        personaQueRecibe.agregarElemento(elementoAPasar)
        personaQueDa.quitarElemento(elementoAPasar)
    }

    method elementosAPasar(elemento, personaQueDa)
}

object sordo inherits CriterioParaDarElemento
{
    override method elementosAPasar(elemento, personaQueDa) = [personaQueDa.primerElementoCercano()]
}

object irritable 
{
    method darElemento(elemento, personaQueDa, personaQueRecibe)
    {

    }
}

object cambiarPosicion inherits CriterioParaDarElemento
{
    override method elementosAPasar(elemento, personaQueDa) = personaQueDa.elementosCercanos()
}

object obediente inherits CriterioParaDarElemento
{
    override method elementosAPasar(elemento, personaQueDa) = [elemento]
}