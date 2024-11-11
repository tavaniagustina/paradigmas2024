// Ave es una superclase
class Ave 
{
    var energia = 50

    method volar(kilometros) {
        energia = energia - (kilometros + 10)
    }

    method comer(gramos) {
        energia = energia + gramos * 4
    }

    method dormir() // Clase abstracta, no tiene comportamiento asi cada una de las clases puede llevar a cabo su comportamiento, 
    // que es distinto una de la otra.
}

class Golondrina inherits Ave {}

class Petrel inherits Ave {
	var kilometrosVolados = 0
	
    // ¿Por qué aparece la palabra override antes de method?
    // Porque la subclase está redefiniendo comportamiento de la superclase: 
    // ya teníamos una definición de volar(kilometros) pero nosotros queremos escribir otra, 
    // que va a pisar a la definición original de Ave.

	override method volar(kilometros) {
        // Queremos aprovechar el comportamiento de volar() que está definido en Ave, 
        // pero sin repetir el código. Por eso utilizamos la pseudo-variable super:

        // Esto permite alterar el method lookup en el contexto en donde estamos, salteando la clase del 
        // ojeto receptor y comenzando por su superclase. Esto es útil particularmente cuando estamos en 
        // un método redefinido y queremos evitar un loop infinito de llamadas al mismo método en el cual estamos.

        // No quiero perder el comportamiento original del method Ave, no quiero perder todo su comportamiento, solo una parte
        // Agregarle algo al metodo, antes o despues
        
		super(kilometros) // Se usa siempre dentro del override
		kilometrosVolados = kilometrosVolados + kilometros
	}

    override method dormir() { energia += 1 } // tiene efecto
}

// class Torcaza inherits Ave {
	
// 	override method comer(gramos) {
// 		energia = energia - (1 + 10) // copio el método volar, je
// 		super(gramos)
// 	}
// }

// class Torcaza inherits Ave {
	
// 	override method comer(gramos) {
// 		self.volar(1)
// 		super(gramos)
// 	}
// }

// En general
// usamos self para enviar mensajes al objeto receptor
// y cuando no podemos usar self, porque entraríamos en loop infinito, usamos super.

// La diferencia está en que self no cambia el method lookup, que comienza por la clase del objeto receptor, 
// mientras que super saltea el primer paso y comienza la búsqueda del método en la superclase de donde se invoca super. 
// Pero el objeto receptor nunca cambia, no hay otro objeto más que la torcaza.

object pepita inherits Golondrina(energia = 10)
{
    override method comer(gramos){
        energia = energia * gramos
    }

    override method dormir() { energia = energia * 10 } // tiene efecto
}

class Torcaza inherits Ave
{
    override method comer(gramos){
        self.volar(1) // necesito que esa ave, torcaza, vuele -> self
        super(gramos) // aca necesito que coma, entonces el method look up va a ir a la superclase ave para ejecutar el method comer 
    }
}
