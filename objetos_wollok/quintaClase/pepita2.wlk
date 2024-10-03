class Ciudad{
    const property consumo = 0 
}
object pepita {
	var property energia = 100
	const ciudadesFavoritas = [] // Nuevo
	
	method esFuerte() { return energia > 50 }

	method volar(ciudad) { // Modificado para recibir una ciudad
		energia = energia - ( ciudad.consumo() + 10 )
	}

	method comer(gramos) {
		energia = energia + 4 * gramos
	}

	method cumplirDeseo() { // Nuevo
		const destino = ciudadesFavoritas.last()
		self.volar(destino)
		ciudadesFavoritas.remove(destino)
	}

	method agregarCiudad(ciudad) { // Nuevo
		ciudadesFavoritas.add(ciudad)
	}

	method esFavorita(ciudad) { // Nuevo
		return ciudadesFavoritas.contains(ciudad)
	}
}