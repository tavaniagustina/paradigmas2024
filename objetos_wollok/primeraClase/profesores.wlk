object nico {
    method cuantoCobras(materia) = materia.length() * 50

    method leCaeBien(alumno) = alumno.estudiaMateria("fisica")
    // method leCaeBien(alumno) = alumno.materiasQueEstudia().contains("fisica") -> mejor la primera solucion, menos acoplamiento (delego)
}

// En consola:
// > nico.cuantoCobras("PDP")
// ✓ 150

object carlono {
    var valorClase = 300

    method cuantoCobras(materia) = valorClase 
    method leCaeBien(alumno) = true // Le pongo (alumno) para q sea polimorfico

    // Setter
    method valorClase(nuevoValor) { valorClase = nuevoValor }  
}

// carlono.valorClase = 500
// ✗ Syntax error: ->  Tengo q hacer un metodo para cambiar el valor de la clase

object camila {
    var estaDeBuenHumor = true

    method cuantoCobras(materia) = if(estaDeBuenHumor) 250 else 700
    method leCaeBien(alumno) = alumno.estudiaMasDe(3)

    // setter -> {}
    method estaDeBuenHumor(nuevoHumor) { estaDeBuenHumor = nuevoHumor }
}

object lucas {
    var property plata = 400
    var property profePreferido = carlono
    const property materiasQueEstudia = [ "historia", "matematicas", "fisica" ] // va const porq no quiero q cambien los elementos de la lista

    method estaFeliz() = profePreferido.cuantoCobras("geografia") <= plata

    method estudiaMateria(materia) = materiasQueEstudia.contains(materia)
    method estudiaMasDe(cantidadDeMaterias) = materiasQueEstudia.size() > cantidadDeMaterias

    // setter -> con el property no hace falta agregarlo
    // method agregarPlata(cantidad) { plata = plata + cantidad }
    // method cambiarProfePrefe(nombreProfesor) { profePreferido = nombreProfesor } 
}

// object melanie {
//     // Melanie
//     // estaFeliz
//     // estudia
//     // estudiaMasMateriasQue
// }