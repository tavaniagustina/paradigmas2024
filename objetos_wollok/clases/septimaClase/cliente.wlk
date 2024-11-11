class Persona
{
    var property humor 
    method cuantoPagar(importe) = importe + humor.propina(importe)

    // method propina(importe)
}

// class PersonaAlegre inherits Persona
// {
//     override method propina(importe) = importe * 0.2
// }

// class PersonaIndiferente inherits Persona
// {
//     var property plataBolsillo 

//     override method propina(importe) = plataBolsillo 
// }

// class PersonaMalHumorada inherits Persona
// {
//     override method propina(importe) = 0
// }

object personaAlegre 
{
    method propina(importe) = importe * 0.2
}

object personaIndiferente 
{
    var property plataBolsillo = 15

    method propina(importe) = plataBolsillo 
}

object personaMalHumorada 
{
    method propina(importe) = 0
}

// si el humor no cambia -> herencia
// si me cambia el humor -> composicion