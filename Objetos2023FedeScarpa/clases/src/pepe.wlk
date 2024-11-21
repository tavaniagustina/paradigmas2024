import categorias.*
import resultados.*
import presentismos.*

object pepe {
	
	var property categoria = cadete
	var property resultado = resultadoNulo
	var property presentismo = presentismoPorFaltas
	var property cantidadDeFaltas = 0
			
	method sueldo() {
		return self.sueldoNeto() + self.bonoPorPresentismo() + self.bonoPorResultados()
	}
	
	method sueldoNeto() {
		return categoria.sueldo()
	}
	
	method bonoPorPresentismo() {
		return presentismo.bonoPara(cantidadDeFaltas)
	}
	
	method bonoPorResultados() {
		return resultado.bonoPara(self)
	}
}
