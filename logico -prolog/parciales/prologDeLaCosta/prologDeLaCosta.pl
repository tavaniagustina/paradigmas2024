% 1)

% puestoDeComida(nombre, precio).
puestoDeComida(hamburguesa, 2000).
puestoDeComida(panchoConPapas, 1500).
puestoDeComida(lomito, 2500).
puestoDeComida(caramelo, 0).

% atraccion(nombre, tranquila | intensa | montaniaRusa | atraccionAcuatica).

% tranquila(chicos y adultos | chicos).
% intensa(coef. lanzamiento).
% montaniaRusa(cant. giros invertidos, duracion en segundos).
% atraccionAcuatica(mesInicio, mesFin).

atraccion(autitosChocadores, tranquila(chicosYAdultos)).
atraccion(casaEmbrujada, tranquila(chicosYAdultos)).
atraccion(laberinto, tranquila(chicosYAdultos)).
atraccion(tobogan, tranquila(chicos)).
atraccion(calesita, tranquila(chicos)).

atraccion(barcoPirata, intensa(14)).
atraccion(tazasChinas, intensa(6)).
atraccion(simulador3D, intensa(2)).

atraccion(abismoMortalRecargada, montaniaRusa(3, 134)).
atraccion(paseoPorElBosque, montaniaRusa(0, 45)).

atraccion(torpedoSalpicon, atraccionAcuatica(septiembre, marzo)).
atraccion(esperoQueHayasTraidoUnaMudaDeRopa, atraccionAcuatica(septiembre, marzo)).

% visitante(nombre, datosSuperficiales(dinero, edad), sentimiento(hambre, aburrimiento)).
% grupoFamiliar(nombrePersona, grupoFamiliar).

visitante(eusebio, datosSuperficiales(3000, 80), sentimiento(50, 0)).
visitante(carmela, datosSuperficiales(0, 80), sentimiento(0, 25)).

% Dos personas que hayan venido solas
visitante(joaco, datosSuperficiales(22,    0), sentimiento(100, 100)).
visitante(fede,  datosSuperficiales(36, 1000), sentimiento( 50,   0)).

grupoFamiliar(eusebio, viejitos).
grupoFamiliar(carmela, viejitos).

% 2)

bienestar(Visitante, felicidadPlena) :-
    sumaSentimientos(Visitante, 0),
    vieneAcompaniado(Visitante).

bienestar(Visitante, podriaEstarMejor) :-
    sumaSentimientos(Visitante, 0),
    not(vieneAcompaniado(Visitante)).

bienestar(Visitante, podriaEstarMejor) :-
    visitante(Visitante),
    sentimientosEntre(1, 50, Visitante).

bienestar(Visitante, necesitaEntretenerse) :-
    visitante(Visitante),
    sumaSentimientos(Visitante, Suma),
    Suma >= 100.

bienestar(Visitante, quiereIrseACasa) :-
    visitante(Visitante),
    sentimientosEntre(51, 99, Visitante).

sentimientosEntre(Base, Tope, Visitante) :-
    sumaSentimientos(Visitante, Suma),
    between(Base, Tope, Suma).
    
sumaSentimientos(Visitante, Suma) :-
    visitante(Visitante, _, sentimiento(Hambre, Aburrimiento)),
    Suma is Hambre + Aburrimiento.

vieneAcompaniado(Visitante) :-
    grupoFamiliar(Visitante, _).

visitante(Visitante) :-
    visitante(Visitante, _, _).

% 3)

satisfaceHambre(Grupo, Comida) :-
    grupoFamiliar(Grupo),
    comida(Comida),
    todosPaganYSeQuedanSinHambre(Grupo, Comida).
    % todosPuedenPagar(Grupo, Comida),
    % aTodosLeQuitaElHambre(Grupo, Comida).

todosPaganYSeQuedanSinHambre(Grupo, Comida) :-
    forall(grupoFamiliar(Visitante, Grupo), (tieneDineroSuficiente(Visitante, Comida), leQuitaElHambre(Visitante, Comida))).

% todosPuedenPagar(Grupo, Comida) :-
%     forall(grupoFamiliar(Visitante, Grupo), tieneDineroSuficiente(Visitante, Comida)).

tieneDineroSuficiente(Visitante, Comida) :-
    puestoDeComida(Comida, PrecioComida),
    visitante(Visitante, datosSuperficiales(Dinero, _), _),
    Dinero >= PrecioComida.

% aTodosLeQuitaElHambre(Grupo, Comida) :-
%     forall(grupoFamiliar(Visitante, Grupo), leQuitaElHambre(Visitante, Comida)).

leQuitaElHambre(Visitante, hamburguesa) :-
    visitante(Visitante, _, sentimiento(Hambre, _)),
    Hambre < 50.

leQuitaElHambre(Visitante, panchoConPapas) :-
    esUnNinio(Visitante).

leQuitaElHambre(Visitante, lomito) :-
    visitante(Visitante).

leQuitaElHambre(Visitante, caramelo) :-
    visitante(Visitante), % Esta mal si le agrego esto??
    forall(comida(Comida), noPuedePagarNingunaComida(Visitante, Comida)).

noPuedePagarNingunaComida(Visitante, Comida) :-
    not(tieneDineroSuficiente(Visitante, Comida)),
    Comida \= caramelo.

comida(Comida) :-
    puestoDeComida(Comida, _).

grupoFamiliar(Grupo) :-
    grupoFamiliar(_, Grupo).

% 4)

lluviaDeHamburguesas(Visitante, Atraccion) :-
    tieneDineroSuficiente(Visitante, hamburguesa),
    atraccionQueHaceVomitar(Visitante, Atraccion).

atraccionQueHaceVomitar(_, Atraccion) :-
    atraccion(Atraccion, intensa(CoeficienteDeLanzamiento)),
    CoeficienteDeLanzamiento > 10.

atraccionQueHaceVomitar(Visitante, tobogan) :- % Tambien podria ser atraccionQueHaceVomitar(_, tobogan).
    visitante(Visitante).

atraccionQueHaceVomitar(Visitante, Atraccion) :-
    atraccion(Atraccion, TipoDeAtraccion),
    esPeligrosa(Visitante, TipoDeAtraccion).

esPeligrosa(Visitante, montaniaRusa(Giros, _)) :-
    not(esUnNinio(Visitante)),
    not(bienestar(Visitante, necesitaEntretenerse)),
    maximaCantidadGiros(Giros).

esPeligrosa(Visitante, montaniaRusa(_, Duracion)) :-
    esUnNinio(Visitante),
    Duracion > 60.

maximaCantidadGiros(Giros) :-
    forall(atraccion(_, montaniaRusa(OtrosGiros, _)), Giros >= OtrosGiros).

esUnNinio(Visitante) :-
    visitante(Visitante, datosSuperficiales(_, Edad), _),
    Edad < 13.

% 5)

opcionDeEntretenimiento(Mes, Visitante, Opciones) :-
    visitante(Visitante),
    findall(Opcion, opcionParticular(Mes, Visitante, Opcion), Opciones).

opcionParticular(_, Visitante, PuestoDeComida) :-
    tieneDineroSuficiente(Visitante, PuestoDeComida).

opcionParticular(_, Visitante, Atraccion) :-
    atraccion(Atraccion, tranquila(FranjaEtaria)),
    puedeAcceder(Visitante, FranjaEtaria).

opcionParticular(_, _, Atraccion) :-
    atraccion(Atraccion, intensa(_)).

opcionParticular(_, Visitante, Atraccion) :-
    atraccion(Atraccion, montaniaRusa(Giros, Duracion)),
    not(esPeligrosa(Visitante, montaniaRusa(Giros, Duracion))).

opcionParticular(Mes, _, Atraccion) :-
    atraccion(Atraccion, atraccionAcuatica(_, _)),
    member(Mes, [septiembre, octubre, noviembre, diciembre, enero, febrero, marzo]).

puedeAcceder(Visitante, chico) :-
    esUnNinio(Visitante).

puedeAcceder(Visitante, chico) :-
    grupoFamiliar(Visitante, Grupo),
    not(esUnNinio(Visitante)),
    hayAlgunChicoEnElGrupo(Grupo).

puedeAcceder(_, chicosYAdultos).

hayAlgunChicoEnElGrupo(Grupo) :-
    grupoFamiliar(Visitante, Grupo),
    esUnNinio(Visitante).