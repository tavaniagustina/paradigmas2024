class Famila
{
    var property miembros = #{}
    var property don

    // Punto B)
    method integranteMasArmado() = self.integrantesVivos().max { integrante => integrante.cantidadDeArmas() }

    method integrantesVivos() = miembros.filter { integrante => !integrante.duermeConLosPeces() }

    // Punto C)
    method armarFamilia() = miembros.forEach { integrante => integrante.armar(new Revolver(balas = 6)) }

    // Punto E)
    method ataqueSorpresa(unaFamilia) = self.integrantesVivos().forEach { integrante => integrante.atacarfamilia(unaFamilia) }

    // Punto F)
    method reorganizarse() 
    {
        self.ascenderSoldadosConArmas()
        self.elegirNuevoDon()
        self.aumentarLealtad()
    }

    method ascenderSoldadosConArmas()
    {
        self.soldadosVivos()
			.sortBy { int1, int2 => int1.cantidadArmas() > int2.cantidadArmas() }
			.take(5)
			.forEach { integrante => integrante.ascenderASubjefe() } 
    }

    method soldadosVivos() = self.integrantesVivos().filter { integrante => integrante.esSoldado() }

    method elegirNuevoDon() = don.subordinadoMasLeal().ascenderADonDe(self) 

    method ascenderADonDe(unaPersona) 
    {
        don = unaPersona
    }

    method aumentarLealtad() 
    {
        miembros.forEach() {integrante => integrante.aumentarLealtad()}
    }
}

class Integrante
{
    var property rango
    var property armas = []
    var property lealtad 
    var property estaMuerto = false
    var property estaHerido = false

    // Punto A)
    method duermeConLosPeces() = estaMuerto 

    // Punto B)
    method cantidadDeArmas() = armas.size()
    
    // Punto C)
    method armar(unArma) = armas.add(unArma)

    // Punto D)
    method despachaElegantemente() = rango.despachaElegantemente(self)

    method tieneArmaSutil() = armas.any { arma => arma.esSutil() }

    // Punto E)
    method atacarfamilia(unaFamilia)
    {
        const atacado = unaFamilia.integranteMasArmado()

        if(!atacado.estaMuerto())
        {
            self.atacarIntegrante(atacado)
        }
    }

    method atacarIntegrante(atacado)
    {
        rango.atacar(self, atacado)
    }

    method armaCualquiera() = armas.anyOne()

    method morir() = estaMuerto

    method herir()
    {
        if(estaHerido)
        {
            self.morir()
        } else {
            estaHerido = true
        }
    } 

    method armaMasAMano() = armas.first()

    // Punto F)
    method esSoldado() = rango.esSoldado()

    method aumentarLealtad()
    {
        lealtad *= 1.1
    }

    method ascenderADonDe(unaFamilia) {
		rango = new Don(subordinados = self.subordinados())
		unaFamilia.ascenderADon(self)
	}

    method subordinados() = rango.subordinados()
}

class Revolver
{
    var property balas

    // Punto D)
    method esSutil() = balas == 1

    // Punto E)
    method usarContra(persona) 
    {
        if(balas > 0)
        {
            balas--
            persona.morir() 
        }
    }
}

class Escopeta
{
    // Punto D)
    method esSutil() = false

    // Punto E)
    method usarContra(persona) 
    {
        persona.herir()
    }
}

class CuerdaDePiano
{
    const property esDeBuenaCalidad 

    // Punto D)
    method esSutil() = true

    method usarContra(persona) 
    {
        if(esDeBuenaCalidad)
        {
            persona.morir()
        }
    }
}

// Rangos 
class Don
{
    const property subordinados = #{}

    method despachaElegantemente(persona) = true 

    // Punto E)
    method atacar(atacante, atacado) = subordinados.anyOne().atacarIntegrante(atacado)

    // Punto F)
    method esSoldado() = false

    method subordinadoMasLeal() = subordinados.max { subordinado => subordinado.lealtad() }
}

class Subjefe
{
    const property subordinados = #{}

    method despachaElegantemente(persona) = subordinados.any { subordinado => subordinado.tieneArmaSutil() }

    // Punto E)
    method atacar(atacante, atacado) = atacante.armaCualquiera().usarContra(atacado)

    // Punto F)
    method esSoldado() = false
}

class Soldado
{
    method despachaElegantemente(persona) = persona.tieneArmaSutil()

    // Punto E)
    method atacar(atacante, atacado) = atacante.armaMasAMano().usarContra(atacado)

    // Punto F)
    method esSoldado() = true

    method subordinados() = #{}
}

class Traicion
{   
    // Sin terminar

    const property traidor
    const property victimas = #{}
    const property fechaTentativa

    method ajusticiar()

    method concretar() 
    {
        if(self.esDiaDelAtaque())
        {
            self.ajusticiar()
        }
    }

    method esDiaDelAtaque() = fechaTentativa == new Date ()
}