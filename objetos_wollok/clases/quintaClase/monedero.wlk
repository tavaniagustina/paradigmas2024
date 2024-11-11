object monedero {
    var plata = 100

    method plata() = plata

    method poner(monto){
        self.validarMontoPositivo(monto)
        plata = plata + monto
    }   

    method sacar(monto){
        self.validarMontoPositivo(monto)
        plata = plata - monto
    }

    method validarMontoPositivo(monto){
        if(monto <= 0) {
            throw new Exception(message = "No se puede poner un monto negativo") 
        }
    }
}

object contratista {

    // var property  presupuesto = 10000 

    // // Esto esta bien!
    // method contratarA(contratista) {
    //     if (contratista.costoArreglo(casa) > self.presupuesto()){
    //         throw new Exception(message = "El presupuesto es insuficiente")
    //     }
    // }

    // Esto esta mal!
    // method contratistasContratados() {
    //     if (serviciosContratados.isEmpty()){
    //         throw new Exception(message = "No contrató servicios aún")
    //     }
    //     return serviciosContratados.map({ ... })
    // }
}

object dani {
    var property viajes = [] 

    var property EDAD_MINIMA_PASAJERO = 50 

    // Esto esta mal!
	// method puedeTomar(viaje) {
	// 	if (viaje.destino() == "Korn") return true
	// 	throw new Exception(message = "No puede tomar el viaje")
	// }
	 	 	
    // method puedeTomar(viaje) = viaje.destino() == "Korn" && viaje.pasajero().edad() > 50

    method tomarViaje(viaje) {
        self.validarViaje(viaje)
        viajes.add(viaje)
    }

    method validarViaje(viaje){
        if (!self.puedeTomar(viaje)) {
            throw new Exception(message = "No puede tomar el viaje porque no va a ese destino")
        }
        if (!self.edadPasajeroCorrecta(viaje)) {
            throw new Exception(message = "No tiene la edad suficiente")
        }
    }

    method destinoComodo(viaje) = viaje.destino() == "Korn"

    method edadPasajeroCorrecta(viaje) = viaje.pasajero().edad() > EDAD_MINIMA_PASAJERO

    method puedeTomar(viaje) = self.destinoComodo(viaje) && self.edadPasajeroCorrecta(viaje)
        
    method agregarViaje(viaje) {
        if (!self.destinoComodo(viaje)) {
            throw new Exception(message = "No puede tomar el viaje porque el destino " + viaje.destino() + " no es cómodo")
        }
        if (!self.edadPasajeroCorrecta(viaje)) {
            throw new Exception(message = "El pasajero debe tener " +  EDAD_MINIMA_PASAJERO  + " años o más")
        }
        viajes.add(viaje)
    }
}