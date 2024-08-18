% jugador(Nombre, Rating, Civilizacion).
jugador(juli, 2200, jemeres).
jugador(aleP, 1600, mongoles).
jugador(feli, 500000, persas).
jugador(aleC, 1723, otomanos).
jugador(ger, 1729, ramanujanos).
jugador(juan, 1515, britones).
jugador(marti, 1342, argentinos).

% unidades (y cuántas), recursos (Madera, Alimento, Oro) y edificios (y cuántos)

% tiene(Nombre, QueTiene).
tiene(aleP, unidad(samurai, 199)).
tiene(aleP, unidad(espadachin, 10)).
tiene(aleP, unidad(granjero, 10)).
tiene(aleP, recurso(800, 300, 100)).
tiene(aleP, edificio(casa, 40)).
tiene(aleP, edificio(castillo, 1)).
tiene(juan, unidad(carreta, 10)).
tiene(carolina, unidad(granjero, 1)).

% De las unidades sabemos que pueden ser militares o aldeanos.

% militar(Tipo, costo(Madera, Alimento, Oro), Categoria).
militar(espadachin, costo(0, 60, 20), infanteria).
militar(arquero, costo(25, 0, 45), arqueria).
militar(mangudai, costo(55, 0, 65), caballeria).
militar(samurai, costo(0, 60, 30), unica).
militar(keshik, costo(0, 80, 50), unica).
militar(tarcanos, costo(0, 60, 60), unica).
militar(alabardero, costo(25, 35, 0), piquero).

% aldeano(Tipo, produce(Madera, Alimento, Oro)).
aldeano(lenador, produce(23, 0, 0)).
aldeano(granjero, produce(0, 32, 0)).
aldeano(minero, produce(0, 0, 23)).
aldeano(cazador, produce(0, 25, 0)).
aldeano(pescador, produce(0, 23, 0)).
aldeano(alquimista, produce(0, 0, 25)).

% edificio(Edificio, costo(Madera, Alimento, Oro)).
edificio(casa, costo(30, 0, 0)).
edificio(granja, costo(0, 60, 0)).
edificio(herreria, costo(175, 0, 0)).
edificio(castillo, costo(650, 0, 300)).
edificio(maravillaMartinez, costo(10000, 10000, 10000)).

% 1)

esUnAfano(Nombre1, Nombre2):-
    jugador(Nombre1, Rating1, _),
    jugador(Nombre2, Rating2, _),
    abs(Rating1 - Rating2) > 500.

% 2)

esEfectivo(Tipo1, Tipo2):-
    esMilitar(Tipo1, _, Categoria1),
    esMilitar(Tipo2, _, Categoria2),
    leGana(Categoria1, Categoria2).

esEfectivo(samurai, Tipo) :-
    esMilitar(Tipo, _, unica).

leGana(caballeria, arqueria).
leGana(arqueria, infanteria).
leGana(infanteria, piquero).
leGana(piquero, caballeria).

esMilitar(Tipo, Costo, Categoria) :-
    militar(Tipo, Costo, Categoria).

% 3)

alarico(Jugador) :-
    jugador(Jugador),
    soloTieneUnidadMilitarDe(infanteria, Jugador).

% 4)

leonidas(Jugador) :-
    jugador(Jugador),
    soloTieneUnidadMilitarDe(piqueros, Jugador).

soloTieneUnidadMilitarDe(Categoria, Jugador) :-
    forall(tiene(Jugador, unidad(Tipo, _)), militar(Tipo, _, Categoria)).

jugador(Jugador) :-
    jugador(Jugador, _, _).

% 5)

nomada(Jugador) :-
    not(tieneAlgunEdificio(Jugador, casa)).

% 6)

cuantoCuesta(Tipo, Costo) :-
    esMilitar(Tipo, Costo, _). 

cuantoCuesta(Tipo, Costo) :-
    edificio(Tipo, Costo).

cuantoCuesta(Tipo, costo(0, 50, 0)) :-
    esAldeano(Tipo, _).

cuantoCuesta(Tipo, costo(100, 0, 50)) :-
    esCarretaOUrna(Tipo).

esCarretaOUrna(carreta).
esCarretaOUrna(urna).

% 7)

produccion(Tipo, ProduccionPorMinuto) :-
    esAldeano(Tipo, ProduccionPorMinuto).

produccion(Tipo, produccion(0, 0, 32)) :-
    esCarretaOUrna(Tipo).

produccion(Tipo, produccion(0, 0, Oro)) :-
    esMilitar(Tipo, _, _),
    tipoUnidad(Tipo, Oro).

esAldeano(Tipo, Produccion) :-
    aldeano(Tipo, Produccion).

tipoUnidad(keshik, 10).
tipoUnidad(_, 0).

% 8)

produccionTotal(Jugador, Recurso, ProduccionTotalPorMinuto) :-
    jugador(Jugador),
    recurso(Recurso),
    findall(Produccion, loTieneYLoProduce(Jugador, Recurso, Produccion), Producciones),
    sum_list(Producciones, ProduccionTotalPorMinuto). % Para sumar todas las cantidades de producción que se encuentran en Producciones
    
loTieneYLoProduce(Jugador, Recurso, Produccion) :-
    tiene(Jugador, unidad(Tipo, Cuantas)),
    produccion(Tipo, ProduccionTotal),
    produccionPorRecurso(Recurso, ProduccionTotal, ProduccionRecurso),
    Produccion is Cuantas * ProduccionRecurso. 

produccionPorRecurso(madera, recurso(Madera, _, _), Madera).
produccionPorRecurso(alimento, recurso(_, Alimento, _), Alimento).
produccionPorRecurso(oro, recurso(_, _, Oro), Oro).

recurso(madera).
recurso(alimento).
recurso(oro).

% 9)

estaPeleado(Jugador1, Jugador2) :-
    not(esUnAfano(Jugador1, Jugador2)),
    cantidadDeUnidades(Jugador1, Cantidad),
    cantidadDeUnidades(Jugador2, Cantidad),
    diferenciaDeValorDeProduccion(Jugador1, Jugador2, Diferencia),
    Direncia < 100.

cantidadDeUnidades(Jugador, Cantidad) :-
    findall(Unidad, tiene(Juagador, unidad(_, CantidadUnidad)), Unidades),
    sum_list(Unidades, Cantidad).

diferenciaDeValorDeProduccion(Jugador1, Jugador2, Diferencia) :-
    valorProduccionTotal(Jugador1, Valor1),
    valorProduccionTotal(Jugador2, Valor2),
    Diferencia is abs(Valor1 - Valor2).

valorProduccionTotal(Jugador, ValorTotal) :-
    produccionTotal(Jugador, madera, ProduccioMadera),
    produccionTotal(Jugador, alimento, ProduccionAlimento),
    produccionTotal(Jugador, oro, ProduccionOro),
    ValorTotal is (ProduccionMadera * 3) + (ProduccionAlimento * 2) + (ProduccionOro * 5).

% 10)

avanzaA(Jugador, Edad) :-
    jugador(Jugador),
    avanzaSegun(Jugador, Edad).

avanzaSegun(_, edadMedia).

avanzaSegun(Jugador, edadFeudal) :-
    cumpleAlimento(Jugador, 500),
    not(nomada(Jugador)).

avanzaSegun(Jugador, edadDeLosCastillos) :-
    cumpleAlimento(Jugador, 800),
    cumpleOro(Jugador, 200),
    tieneAlgunEdificio(Jugador, Edificio),
    edificioParaEdadDeLosCastillos(Edificio).

avanzaSegun(Jugador, edadImperial) :-
    cumpleAlimento(Jugador, 1000),
    cumpleOro(Jugador, 800),
    tieneAlgunEdificio(Jugador, Edificio),
    edificioParaEdadImperial(Edificio).

cumpleAlimento(Jugador, Cantidad) :-
    recursosPersona(Jugador, _, Alimento, _),
    Alimento > Cantidad.

cumpleOro(Jugador, Cantidad) :-
    recursosPersona(Jugador, _, _, Oro),
    Oro > Cantidad.

recursosPersona(Jugador, Madera, Alimento, Oro) :-
    tiene(Jugador, recurso(Madera, Alimento, Oro)).

tieneAlgunEdificio(Jugador, Edificio) :-
    jugador(Jugador),
    tiene(Jugador, edificio(Edificio, _)).

edificioParaEdadDeLosCastillos(herreria).
edificioParaEdadDeLosCastillos(establo).
edificioParaEdadDeLosCastillos(galeriaDeTiro).

edificioParaEdadImperial(castillo).
edificioParaEdadImperial(universidad).