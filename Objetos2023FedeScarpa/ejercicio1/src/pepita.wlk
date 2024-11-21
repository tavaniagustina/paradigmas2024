object pepita {
	
	var energia = 100
	
	method volar(unosKilometros) {
		energia = energia - unosKilometros - 10
	}
	
	method energia() { // Getter
		return energia
	}
	
	method energia(unaEnergia) { // Setter
		energia = unaEnergia
	}
	
	method comer(unaCantidad) {
		energia += (4 * unaCantidad)
	}
	
}
