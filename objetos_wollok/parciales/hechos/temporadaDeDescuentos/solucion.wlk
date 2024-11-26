class Juego
{
    const property precioEnDolares
    const property caracteristicas = [] // si contiene leng inapropiado, violencia, o tematica de adultos
    const property criticas = [] // si presenta caracteristicas prohibidas para cada pais

    // Punto 1
    method precioDelJuego() = 0.max(self.aplicarDescuento())

    method aplicarDescuento()

    // Punto 2
    method superaPrecio(otroPrecio) = self.precioDelJuego() > otroPrecio

    // Punto 3
    method esViolento() = self.contieneAlgunaCaracteristica("violento")

    // Punto 4
    method esAptoParaMenoresSegun(pais) = !self.contieneAlgunaCaracteristica(pais.caracteristicasProhibidas())

    method contieneAlgunaCaracteristica(listaDeCaracteristicas) = caracteristicas.any { caracteristica => listaDeCaracteristicas.contains(caracteristica) }



}

class DescuentoDirecto inherits Juego
{
    const property porcentaje

    // Punto 1
    override method aplicarDescuento() = precioEnDolares - (precioEnDolares * porcentaje / 100)
}

class DescuentoFijo inherits Juego
{
    const property montoFijo

    // Punto 1
    override method aplicarDescuento() = self.mitadDelPrecioOriginal().max(precioEnDolares - montoFijo)

    method mitadDelPrecioOriginal() = precioEnDolares / 2
}

class Gratis inherits Juego
{
    // Punto 1
    override method aplicarDescuento() = 0
}

// Punto 3 - Descuento inventado
class DescuentoDirectoSoloParaJuegosNoViolentos inherits DescuentoDirecto
{
    override method aplicarDescuento() = 
        if(self.esViolento())
        {
            precioEnDolares
        }else{
            super().aplicarDescuento()
        } 
}

// Punto 4
class Pais
{
    const property conversionDolares
    const property caracteristicasProhibidas = []

    method dolaresAPesos(precioEnDolares)
    {
        precioEnDolares * conversionDolares
    }
}

object plataforma
{   
    var property juegos = []

    // Punto 2

    method aplicarDescuentoPorcentual(nuevoPorcentaje)
    {
        if(nuevoPorcentaje > 1)
        {
            throw new Exception(message = "El porcentaje debe ser un número entre 0 y 1")
        }

        const juegoMasCaro = juegos.max { juego => juego.precioDelJuego() }

        const juegosADescontar = juegos.filter { juego => juego.superaPrecio(0.75 * juegoMasCaro) }

        const nuevoDescuento = new DescuentoDirecto(porcentaje = nuevoPorcentaje, precioEnDolares = 100)
    
        juegosADescontar.forEach { juego => juego.aplicarDescuento(nuevoDescuento) }
    }

    // Punto 5
    method promedioDeTodosLosJuegosAptosEn(pais)
    {
        const juegosAptos = juegos.filter { juego => juego.esAptoParaMenoresSegun(pais) }
    }
}

class Critica
{
    var property texto
    var property esPositiva

    method tieneTextoLargo() = texto.length() > 100
}

class Critico
{
    method criticar(juego) 
    {
        const unaCritica = new Critica(texto = self.critica(), esPositiva = self.daCriticaPositiva(juego))
    }

    method critica()

    method daCriticaPositiva(juego)
}

class Usuario inherits Critico
{   
    var property predisposicion

    override method critica() = predisposicion.criticaDeUsuario()

    override method daCriticaPositiva(juego) = predisposicion.esPositiva()    
}

object positiva
{
    method textoDeUsuario() = "SI"
    method esPositiva() = true
}

object negativa
{
    method textoDeUsuario() = "NO"
    method esPositiva() = false
}

class CriticoPago inherits Critico
{
    const property juegosQueLePagaron = []
    const property palabrasRandomDeCriticos = ["divertido", "aburrido", "feo", "juego", "robo"]

    override method critica() = palabrasRandomDeCriticos.anyOne()

    override method daCriticaPositiva(juego) = juegosQueLePagaron.contains(juego) 
}

class Revista inherits Critico
{
    const property criticos = []

    override method daCriticaPositiva(juego) = self.mayoriaCriticosDaCriticaPositiva(juego)

    method mayoriaCriticosDaCriticaPositiva(juego) {
        const criticosConCriticaPositiva = self.criticasPositivas(juego)
        return criticosConCriticaPositiva.size() > criticos.size() / 2
    }

    method criticasPositivas(juego) = criticos.filter { critico => critico.daCriticaPositiva(juego) }

	method incorporarCritico(critico)
	{
		criticos.add(critico)
	}
	
	method removerCritico(critico)
	{
		criticos.remove(critico)
	}
}