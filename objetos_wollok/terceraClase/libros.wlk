class Libro{
  var nombre // no necesita tener el nombre de la variable (asignacion), pero si o si es necesario ponerlo en el object, no es necesario ponerle property 
  var property precio = 100

  method esCaro() = precio > 150

  method aumentar(aumento) { precio += aumento }

}

const elPrincipito = new Libro(nombre = "El Principito") // este libro no es mas un objeto, es una referencia
const martinFierro = new Libro(nombre = "Martin Fierro", precio = 170) 

class DVD{
  var cantidadMinutos
  var precioPorMinuto

  method esCaro() = cantidadMinutos > 100

  method precio() = cantidadMinutos * precioPorMinuto
}

const toyStory = new DVD(cantidadMinutos = 95, precioPorMinuto = 5)

class Lamina{
  var ancho
  var alto
  var material

  method esCaro() = self.precioBase() > 50

  method precio() = ancho * alto * self.precioBase()

  method precioBase() = material.precio() // quien es el responsable de saber el precio del material? el material.
}

const lamina1 = new Lamina(ancho = 2, alto = 3, material = new Material (precio = 25))

// si hubiera un comportamiento diferencial entre los distintos materiales, seria mejor usar un object
// object material -> instancia global, no se puede tener materiales con dist dedos
// object aluminio/hierro/madera, etc, pero todos con un comportamientos distinto entre ellos  
class Material{
  var property precio 
}

const aluminio = new Material(precio = 12)
const hierro = new Material(precio = 15)