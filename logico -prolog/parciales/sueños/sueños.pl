% 1)

cree(gabriel, campanita).
cree(gabriel, magoDeOz).
cree(gabriel, cavenaghi).
cree(juan, conejoDePascua).
cree(macarena, reyesMagos).
cree(macarena, magoCapria).
cree(macarena, campanita).

% diego no cree en nadie -> por principio de universo cerrado lo q se considera falso no se escribe.

quiere(gabriel, ganarLoteria([5, 9])).
quiere(gabriel, futbolista(arsenal)).
quiere(juan, cantante(100000)).
quiere(macarena, cantante(10000)).

% macarena no quiere ganar la lotería -> por principio de universo cerrado lo q se considera falso no se escribe.

% 2)

esAmbiciosa(Persona) :-
    persona(Persona),
    findall(Dificultad, dificultadSegunSuenio(Dificultad, Persona), Dificultades),
    sum_list(Dificultades, DificultadTotal), % Tambien se puede usar un aggregate_all(sum(lo que quiero))
    DificultadTotal > 20.

dificultadSegunSuenio(Dificultad, Persona) :-
    quiere(Persona, Suenio), 
    dificultadSuenio(Suenio, Dificultad).   

dificultadSuenio(cantante(Cantidad), 6) :- Cantidad > 500000.
dificultadSuenio(cantante(Cantidad), 4) :- Cantidad =< 500000.

dificultadSuenio(ganarLoteria(Numeros), Dificultad) :- 
    length(Numeros, Cantidad),
    Dificultad is 10 * Cantidad.

dificultadSuenio(futbolista(Equipo), 3) :- 
    esEquipoChico(Equipo).

dificultadSuenio(futbolista(Equipo), 16) :- 
    not(esEquipoChico(Equipo)).

esEquipoChico(arsenal).
esEquipoChico(aldosivi).

persona(Persona) :-
    distinct(Persona, quiere(Persona, _)).

% 3)

tieneQuimica(Personaje, Persona) :-
    cree(Persona, Personaje),
    cumpleCondiciones(Persona, Personaje).

cumpleCondiciones(Persona, campanita) :-
    dificultadSegunSuenio(Dificultad, Persona),
    Dificultad < 5.

cumpleCondiciones(Persona, Personaje) :-
    Personaje \= campanita,
    todosLosSueniosPuros(Persona),
    not(esAmbiciosa(Persona)).

% todos los sueños deben ser puros -> forall
todosLosSueniosPuros(Persona) :-
    forall(quiere(Persona, Suenio), esSuenioPuro(Suenio)).

esSuenioPuro(futbolista(_)).
esSuenioPuro(cantante(Discos)) :- Discos < 200000.

% 4)

esAmigo(campanita, reyesMagos).
esAmigo(campanita, conejoDePascua).
esAmigo(conejoDePascua, cavenaghi).

enfermo(campanita).
enfermo(reyesMagos).
enfermo(conejoDePascua).

puedeAlegrar(Personaje, Persona) :-
    quiere(Persona, _),
    tieneQuimica(Personaje, Persona),
    cumpleCondiconesParaAlegrar(Personaje).

cumpleCondiconesParaAlegrar(Personaje) :-
    not(enfermo(Personaje)).

cumpleCondiconesParaAlegrar(Personaje) :-
    esDeBackup(Personaje, OtroPersonaje),
    cumpleCondiconesParaAlegrar(OtroPersonaje).

esDeBackup(UnPersonaje, OtroPersonaje) :-
    esAmigo(UnPersonaje, OtroPersonaje).

esDeBackup(UnPersonaje, OtroPersonaje) :-
    esAmigo(UnPersonaje, Personaje),
    esDeBackup(Personaje, OtroPersonaje).
