object calopelusa{
    const fecha = new Date(year=2025, month=1, day=1)

    var property calendario = calendarioPosta

    method cuantoSale() = if(self.mesesFaltantes() > 4) 5000 else 21000

    method mesesFaltantes() = (fecha - calendarioPosta.hoy()) . div(30)
}

// cada vez q haga calendarioPosta en la funcion anterior va a generar la fecha actual, sino delego esto, 
// lo voy a tener q hacer a mano, siendo una solucion de mierda.
object calendarioPosta{
    method hoy() = new Date()
}