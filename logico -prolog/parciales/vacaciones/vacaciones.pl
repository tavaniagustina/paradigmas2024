% 1)

% destino(persona, destino).
destino(dodain, pehuenia).
destino(dodain, sanMartinDeLosAndes).
destino(dodain, esquel).
destino(dodain, sarmiento).
destino(dodain, camarones).
destino(dodain, playasDoradas).
destino(alf, bariloche).
destino(alf, sanMartinDeLosAndes).
destino(alf, elBolson).
destino(nico, marDelPlata).
destino(vale, calafate).
destino(vale, elBolson).

% esto estaria mal!

% destino(martu, Destino) :-
%     personasPosibles(Persona),
%     destino(Persona, Destino). 

% personasPosibles(nico). 
% personasPosibles(alf). 

% Martu va donde vaya nico y alf
destino(martu, Destino) :-
    destino(nico, Destino).

destino(martu, Destino) :-
    destino(alf, Destino).

% Juan y Carlos como por ahora no se van de vacaiones, no se ponen en la base de conocimiento p
% por el principio de universo cerrado -> todo lo que se presume falso no se escribe

% 2)

% atraccion(destino, atraccion).
atraccion(marDelPlata, playa(1, 1)).
atraccion(esquel, parqueNacional(losAlerques)).
atraccion(esquel, excursion(trochita)).
atraccion(esquel, excursion(trevelin)).
atraccion(villaPehuenia, cerro(bateaMahuida, 2000)).
atraccion(villaPehuenia, cuerpoDeAgua(moquehue, sePesca, 14)).
atraccion(villaPehuenia, cuerpoDeAgua(alumine, sePesca, 19)).

vacacionesCopadas(Persona) :-
    persona(Persona),
    forall(destino(Persona, Destino), esAtraccionCopada(Destino)).

esAtraccionCopada(Destino) :-
    atraccion(Destino, Atraccion),
    atraccionCopada(Atraccion).

atraccionCopada(cerro(_, Metros)) :-
    Metros >= 2000.

atraccionCopada(cuerpoDeAgua(_, sePesca, _)).

atraccionCopada(cuerpoDeAgua(_, _, Temperatura)) :-
    Temperatura > 20.

atraccionCopada(playa(MareaAlta, MareaBaja)) :-
    DiferenciaPromedio is (MareaAlta + MareaBaja) / 2,
    DiferenciaPromedio < 5.

% Existe un predicado string_length/2 que relaciona el string con la cantidad de caracteres que tiene. 
% También les puede interesar otro predicado llamado atom_length/2 que en este caso relaciona a un átomo con la cantidad de letras que tiene el mismo.

atraccionCopada(excursion(Nombre)) :-
    atom_length(Nombre, Largo), 
    Largo > 7.

atraccionCopada(parqueNacional(_)).

persona(Persona) :-
    distinct(Persona, destino(Persona, _)).

% 3)

noSeCruzaron(UnaPersona, OtraPersona) :-
    persona(UnaPersona),
    persona(OtraPersona),
    UnaPersona \= OtraPersona,
    not(seCruzaron(UnaPersona, OtraPersona)).

seCruzaron(UnaPersona, OtraPersona) :-
    destino(UnaPersona, Destino), 
    destino(OtraPersona, Destino), 
    UnaPersona \= OtraPersona.

% Otra solucion
noSeCruzaron2(UnaPersona, OtraPersona) :-
    persona(UnaPersona),
    persona(OtraPersona),
    UnaPersona \= OtraPersona,
    forall(destino(UnaPersona, Lugar), not((destino(OtraPersona, Lugar), UnaPersona \= OtraPersona))).
    
% 4)

costoDeVida(sarmiento, 100).
costoDeVida(esquel, 150).
costoDeVida(pehuenia, 180).
costoDeVida(sanMartinDeLosAndes, 150).
costoDeVida(camarones, 135).
costoDeVida(playasDoradas, 170).
costoDeVida(bariloche, 140).
costoDeVida(calafate, 240).
costoDeVida(elBolson, 145).
costoDeVida(marDelPlata, 140).

vacacionesGasoleras(Persona) :-
    persona(Persona),
    forall(destino(Persona, Destino), esGasolero(Destino)).

esGasolero(Destino) :-
    costoDeVida(Destino, Costo), 
    Costo < 160.

% 5)

itinerario(Persona, Destinos) :-
    persona(Persona),
    findall(Destino, destino(Persona, Destino), DestinosPosibles),
    permutar(DestinosPosibles, Destinos).

permutar([], []).
permutar(Destinos, [Destino | RestoPermutacion]) :-
    select(Destino, Destinos, DestinosRestantes), % Selecciona un Destino de la lista Destinos, lo coloca al inicio de la permutación y luego permuta el resto de la lista DestinosRestantes recursivamente.
    permutar(DestinosRestantes, RestoPermutacion).

% Otra solucion
itinerario2(Persona, DestinosPermutados) :-
    persona(Persona),
    findall(Destino, destino(Persona, Destino), DestinosPosibles),
    permutation(DestinosPosibles, DestinosPermutados).

% Otra solucion 
itinerario3(Persona, Lugares) :-
    persona(Persona),
    findall(Lugar, destino(Persona, Lugar), LugaresPosibles),
    combinar(LugaresPosibles, Lugares).

combinar([], []).

combinar(Lugares, [Lugar | Itinerario]) :-
    member(Lugar, Lugares),
    sacar(Lugar, Lugares, Resto),
    combinar(Resto, Itinerario).

sacar(_, [], []).

sacar(Lugar, [Lugar | Lugares], Lugares).

sacar(Lugar, [OtroLugar | Lugares], [OtroLugar | Resto]) :-
    Lugar \= OtroLugar,
    sacar(Lugar, Lugares, Resto).