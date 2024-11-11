class Presentacion {
	var property lugar
	const property musicos = []
	var property valorEntrada
	var property entradasVendidas = 0
}

const lunaPark = "Luna Park"
const seruGiran = "Seru Giran"

const seruEnLuna = new Presentacion( // se puede hacer en cualquier orden 
	lugar = lunaPark, 
	musicos = [seruGiran], 
	valorEntrada = 2000, 
	entradasVendidas = 180)

// se puede instanciar sin necesidad de pasar por parámetros todos los valores.
const vamosAVerQuienEnLuna = new Presentacion(lugar = lunaPark, valorEntrada = 2000)