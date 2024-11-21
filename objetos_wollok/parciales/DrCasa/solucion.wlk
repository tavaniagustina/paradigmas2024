
// enfermedad -> cantidad de celulas amenazadas (segun el tipo de enfermedad)
    
    // infecciosa 
    // malario o otitis -> aumentan la temperatura en la milesima parte de la cantidad de celulas amenazadas
    // maxima temepratura es 45, si pasa ese valor entra en coma
    // pueden reproducirse, duplicando la cantidad de celulas amezadas 

    // autoinmunes 
    // lupus -> destruye la cantidad de celulas amenazadas

        // agresiva
        // infecciosa es agresiva -> cantidad de celulas afectadas supera el 10% de las celulas totales del cuerpo

        // autoinmune es agresiva -> cuando afecta a la persona por mas de un mes -> produjo su efecto mas de 30 veces

        // no agresiva 

// los medicos suministran medicamnetos
    // se atenuan en la cantidad recibida * 15
    // se curan en el caso de que no afecten a mas celulas

    // un medico trata de curarse a si mismo

class Enfermedad 
{
    var property cantidadCelulasAmenazadas

    method atenuarse(cantidad)
    {
        cantidadCelulasAmenazadas = 0.max(cantidadCelulasAmenazadas - cantidad) 
    }

    method atenuarsePara(persona, dosis)
    {
        self.atenuarse(dosis * 15)
        self.validarCuracion(persona)
    }

    method validarCuracion(persona)
    {
        if (self.cantidadCelulasAmenazadas() == 0)
        {
            persona.curarseDe(self)
        }
    }
}

class EnfermedadInfecciosa inherits Enfermedad
{
    var property cantidadDeDias = 0

    method reproducirse()
    {
        cantidadCelulasAmenazadas = cantidadCelulasAmenazadas * 2
    }

    // aumenta la temperatura en la milesima parte de la cantidad de celulas amenazadas
    method afectarA(persona)
    {
        persona.aumentarTemperatura(self.cantidadCelulasAmenazadas() / 1000) 
    }

    // cuando afecta a la persona por mas de un mes -> produjo su efecto mas de 30 veces
    method esAgresivaPara(persona)
    {
        persona.cantidadDeDias() > 30
    }
}

class EnfermedadAutoinmune inherits Enfermedad
{
    // destruye la cantidad de celulas amenazadas
    method afectarA(persona)
    {
        persona.destruirCelulas(self.cantidadCelulasAmenazadas())
    }

    // cantidad de celulas afectadas supera el 10% de las celulas totales del cuerpo
    method esAgresivaPara(persona)
    {
        persona.cantidadCelulasAmenazadas() > persona.cantidadDeCelulas() / 10
    }    
}

class Persona 
{
    var property temperatura
    var property cantidadDeCelulas
    const property enfermedades = #{}

    method contraerEnfermedad(enfermedad)
    {
        enfermedades.add(enfermedad)
    }

    method vivirUnDia()
    {
        enfermedades.forEach { enfermedad => enfermedad.afectarA(self) }
    }

    method aumentarTemperatura(aumentoDeTemperatura)
    {
        temperatura = 45.min(temperatura + aumentoDeTemperatura)
    }

    method destruirCelulas(unasCelulas)
    {
        cantidadDeCelulas = 0.max(self.cantidadDeCelulas() - unasCelulas)
    }

    method estaEnComa() = self.temperatura() == 45 || self.cantidadDeCelulas() < 1000000

    method enfermedadMasAmenazante()
    {
        enfermedades.max {enfermedad => enfermedad.cantidadCelulasAmenazadas()}
    }

    // la cantidad de células afectadas de Logan que estén afectadas por enfermedades agresivas
    method cantidadCelulasAmenazadasPorEnfermedadesAgresivas() = 
        self.enfermedadesAgresivas().sum { enfermedad => enfermedad.cantidadCelulasAmenazadas() }

    method enfermedadesAgresivas() = enfermedades.filter { enfermedad => enfermedad.esAgresivaPara(self) }
    
    method vivirUnos(dias)
    {
        dias.times { dia => self.vivirUnDia() }
    }

    method medicateCon(dosis)
    {
        enfermedades.forEach { enfermedad => enfermedad.atenuarsePara(self, dosis) }
    }

    method curarseDe(enfermedad)
    {
        enfermedades.remove(enfermedad)
    }

    method tiene(enfermedad) = enfermedades.contains(enfermedad)

    method morir()
    {
        temperatura = 0
    }
}

class Medico inherits Persona
{
    var property dosis

    override method contraerEnfermedad(enfermedad)
    {
        super(enfermedad)
        self.atenderA(self)
    }

    method atenderA(persona)
    {
        persona.medicateCon(dosis)
    }
}

class JefeDeDepartamento inherits Medico(dosis = 0)
{
    const subordinados = #{}

    override method atenderA(unaPersona)
    {
        subordinados.anyOne().atenderA(unaPersona) // no anda anyOne
    }

    method subordinarA(unMedico)
    {
        subordinados.add(unMedico)
    }
}

object muerte
{
    method cantidadCelulasAmenazadas() = 0

    method atenuatePara(_unaPersona, _unaDosis) 
    {
        // No hace nada porque no se atenua
    }

    method afectarA(unaPersona) 
    {
        unaPersona.morir()
    }

    method esAgresivaPara(_unaPersona) 
    {
        return true
    }
}

class HIV 
{
    const autoinmune
    const infecciosa
    
    method cantidadCelulasAmenazadas() 
    {
        return autoinmune.cantidadCelulasAmenazadas() + infecciosa.cantidadCelulasAmenazadas()
    }

    method atenuatePara(unaPersona, unaDosis) 
    {
        infecciosa.atenuatePara(unaPersona, unaDosis)
        autoinmune.atenuatePara(unaPersona, unaDosis)
    }

    method afectarA(unaPersona) 
    {
        infecciosa.afectarA(unaPersona)
        autoinmune.afectarA(unaPersona)
    }

    method esAgresivaPara(unaPersona) = infecciosa.esAgresivaPara(unaPersona) && autoinmune.esAgresivaPara(unaPersona)
}