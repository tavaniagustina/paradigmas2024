// En Depositos hay Formaciones ya armadas o locomotoras sueltas (q pueden ser agregadas a una formacion).

// Una Formacion es un tren, que tiene una o varias locomotoras y uno o varios vagones.

// Hay vagones de pasajeros y de carga

// De cada vagon de pasajeros se conoce: largo, ancho -> class

// Cantidad de pasajeros por vagon: 
    // ancho < 2.5 -> largo * 8
    // ancho > 2.5 -> largo * 10

// De cada vagon de carga se conoce la carga maxima que puede llevar -> class

// Peso maximo de un vagon de:
    // pasajeros: cantidad de pasajeros * 80
    // carga: carga maxima + 160 

// De cada locomotora se conoce: peso, peso maximo de arrastre, velocidad maxima

class Formacion 
{
    var property vagones = [] 
    var property locomotoras = [] 

    // 1)
    method agregarVagon(nuevaVagon)
    {
        vagones.add(nuevaVagon)
    }

    // 2)
    method agregarLocomotora(nuevaLocomotora)
    {
        locomotoras.add(nuevaLocomotora)
    }

    // 3)
    method cantidadDeVagones() = vagones.size()

    // 4)
    method totalPasajeros() = vagones.sum {vagon => vagon.cantidadDePasajeros() }

    // 5)
    method cantidadDeVagonesLivianos() = vagones.count {vagon => vagon.esLiviano()}

    // 6)
    method velocidadMaxima() = locomotoras.map {locomotora => locomotora.velocidadMaxima() }.min()

    // 7)
    method esEficiente() = locomotoras.all { locomotora => locomotora.esEficinete() }

    // 8)
    method puedeMoverse() = self.arrastreUtilTotal() >= self.pesoMaximoVagones()
    
    method arrastreUtilTotal() = locomotoras.sum { locomotora => locomotora.pesoMaximoArrastre()}

    method pesoMaximoVagones() = vagones.sum { vagon => vagon.pesoMaximo() }

    // 9)
    method kilosDeEmpujeFaltantes() = 0.max(self.pesoMaximoVagones() - self.arrastreUtilTotal())

    // 10)
    method vagonMasPesado() = vagones.max { vagon => vagon.pesoMaximo() }

    // 11)
    method esCompleja() = self.tieneMuchasUnidades() || self.pesoTotal() > 10000

    method tieneMuchasUnidades() = self.cantidadDeUnidades() > 20
    
    method cantidadDeUnidades() = self.cantidadDeVagones() + self.cantidadDeLocomotoras()

    method cantidadDeLocomotoras() = locomotoras.size()

    method pesoTotal() = self.pesoMaximoVagones() + self.pesoMaximoLocomotoras()

    method pesoMaximoLocomotoras() = locomotoras.sum { locomotora => locomotora.peso() }
}

class VagonDePasajeros
{
    var property largo
    var property ancho

    method cantidadDePasajeros() = if(ancho < 2.5) { largo * 8 } else { largo * 10 }

    method esLiviano() = self.pesoMaximo() < 2500

    method pesoMaximo() = self.cantidadDePasajeros() * 80
}

class VagonDeCarga
{
    var property cargaMaxima

    method cantidadDePasajeros() = 0

    method esLiviano() = self.pesoMaximo() < 2500

    method pesoMaximo() = cargaMaxima + 160 
}

class Locomotora
{
    const property peso
    const property pesoMaximoArrastre
    const property velocidadMaxima

    method esEficinete() = pesoMaximoArrastre >= peso * 5

    // 12)
    method arrastreUtil() = pesoMaximoArrastre - peso

    method puedeArrastrar(unaFormacion) = self.arrastreUtil() >= unaFormacion.kilosDeEmpujeFaltantes()
}

class Deposito
{
    const property formaciones = []
    const property locomotoras = []

    // 10)
    method vagonesMasPesados() = formaciones.map { formacion => formacion.vagonMasPesado() }

    // 11)
    method necesitaConductorExperimentado() = formaciones.any { formacion => formacion.esCompleja() }

    // 12)
    method agregarLocomotoraA(unaFormacion)
    {
        const locomotora = locomotoras.find { locomotora => locomotora.puedeArrastrar(unaFormacion) }
        // locomotoras.remove(locomotora) Raro
        unaFormacion.agregarLocomotora(locomotora)
    }
}