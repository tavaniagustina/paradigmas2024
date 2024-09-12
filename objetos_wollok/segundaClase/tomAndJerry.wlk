object tom 
{
  var energia = 100
  const velocidadBase = 5
  const valorBaseEnergiaAlComerRaton = 12

  method comerRaton(raton)
  {
    energia = energia + self.incrementoPorComerUnRaton(raton)
  }

  method incrementoPorComerUnRaton(raton) = valorBaseEnergiaAlComerRaton + raton.peso()
  method velocidad() = velocidadBase + energia / 10

  method correr(segundos)
  {
    // const metros = self.velocidad() * segundos

    energia = energia - self.decrementoPorCorrer(segundos)
  }

  method decrementoPorCorrer(segundos) = 0.5 * self.metrosRecorridos(segundos)
  method metrosRecorridos(segundos) = segundos * self.velocidad()
  method meConvieneComerRatonA(unRaton, unosSegundos) = self.incrementoPorComerUnRaton(unRaton) > self.decrementoPorCorrer(unosSegundos)
}

object jerry 
{
  const peso = 14
  method peso() = peso 
}