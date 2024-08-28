% jugadores conocidos 
jugador(maradona).       
jugador(chamot). 
jugador(balbo).
jugador(caniggia). 
jugador(passarella). 
jugador(pedemonti). 
jugador(basualdo). 

% relaciona lo que toma cada jugador 
tomo(maradona, sustancia(efedrina)). 
tomo(maradona, compuesto(cafeVeloz)). 
tomo(caniggia, producto(cocacola, 2)). 
tomo(chamot, compuesto(cafeVeloz)). 
tomo(balbo, producto(gatoreit, 2)). 

% 1)

% passarella toma todo lo que no tome Maradona 
tomo(passarella, Sustancia) :-
    jugador(Jugador),
    Jugador \= passarella,
    tomo(Jugador, Sustancia),
    not(tomo(maradona, Sustancia)).

% tomo(passarella, Sustancia) :-  No anda!
%     not(tomo(maradona, Sustancia)).

% pedemonti toma todo lo que toma chamot y lo que toma Maradona 
% el video de la resolucion dice que es un or logico, no entiendo por que.

% p ent maradona tomo una cosa x
% q ent chamot tomo una cosa y
% r ent pedemonti tomo es misma cosa
% si p ò q ent r
% r ent p
% r ent q

% Pedemonti tomará cualquier cosa que tome Chamot o cualquier cosa que tome Maradona, lo que es un OR lógico.
tomo(pedemonti, Sustancia) :- tomo(maradona, Sustancia).
tomo(pedemonti, Sustancia) :- tomo(chamot, Sustancia).

% basualdo no toma coca cola -> por pricipio de universo cerrado todo lo q se considera falso no se escribe. 

% relaciona la máxima cantidad de un producto que 1 jugador puede ingerir  
maximo(cocacola, 3). 
maximo(gatoreit, 1). 
maximo(naranju, 5).

% relaciona las sustancias que tiene un compuesto 
composicion(cafeVeloz, [efedrina, ajipupa, extasis, whisky, cafe]). 

% sustancias prohibidas por la asociación 
sustanciaProhibida(efedrina). 
sustanciaProhibida(cocaina).

% 2)

puedeSerSuspendido(Jugador) :-
    jugador(Jugador),
    tomo(Jugador, Sustancia),
    esSuspendido(Sustancia).

esSuspendido(Sustancia) :-
    sustanciaProhibida(Sustancia).

esSuspendido(compuesto(Sustancia)) :-
    composicion(Sustancia, Ingredientes),
    member(Ingrediente, Ingredientes),
    sustanciaProhibida(Ingrediente).

esSuspendido(producto(Sustancia, CantidadTomada)) :-
    maximo(Sustancia, CantidadMaxima),
    CantidadTomada > CantidadMaxima.

% 3)

amigo(maradona, caniggia). 
amigo(caniggia, balbo). 
amigo(balbo, chamot). 
amigo(balbo, pedemonti). 

malaInfluencia(UnJugador, OtroJugador) :-
    puedeSerSuspendido(UnJugador),
    conocido(UnJugador, OtroJugador), 
    puedeSerSuspendido(OtroJugador).

conocido(UnJugador, OtroJugador) :-
    amigo(UnJugador, OtroJugador). 

conocido(UnJugador, OtroJugador) :-
    amigo(UnJugador, Jugador),
    conocido(Jugador, OtroJugador). % ATENCION: acá se resuelve con recursión

% 4)

atiende(cahe, maradona). 
atiende(cahe, chamot). 
atiende(cahe, balbo). 
atiende(zin, caniggia). 
atiende(cureta, pedemonti). 
atiende(cureta, basualdo).

chanta(Medico) :-
    medico(Medico),
    puedeSerSuspendido(Jugador),
    atiende(Medico, Jugador).

medico(Medico) :-
    distinct(Medico, atiende(Medico, _)).

% 5)

nivelFalopez(efedrina, 10). 
nivelFalopez(cocaina, 100). 
nivelFalopez(extasis, 120). 
nivelFalopez(omeprazol, 5). 

cuantaFalopaTiene(Jugador, NivelDeAlteracion) :-
    jugador(Jugador),
    % findall(Nivel, falopaTomada(Jugador, Nivel), Niveles),
    % sum_list(Niveles, NivelDeAlteracion).
    aggregate_all(sum(Nivel), falopaTomada(Jugador, Nivel), NivelDeAlteracion).

falopaTomada(Jugador, Nivel) :-
    tomo(Jugador, Sustancia),
    cantidadFalopa(Sustancia, Nivel).

cantidadFalopa(producto(_, _), 0).

cantidadFalopa(sustancia(Sustancia), Nivel) :-
    nivelFalopez(Sustancia, Nivel). 

cantidadFalopa(compuesto(Sustancia), NivelTotal) :-
    composicion(Sustancia, ListaDeSustancias),
    findall(Nivel, (member(UnaSustancia, ListaDeSustancias), nivelFalopez(UnaSustancia, Nivel)), Niveles),
    sum_list(Niveles, NivelTotal). % aca puedo hacer otro aggregate_all

% 6)

medicoConProblemas(Medico) :-
    medico(Medico),
    pacientesConflictivos(Medico, Cantidad),
    Cantidad >= 3.

pacientesConflictivos(Medico, Cantidad) :-
    findall(Jugador, atiendeConflictivos(Jugador, Medico), Jugadores),      
    length(Jugadores, Cantidad). % aca puedo hacerlo con aggregate_all

atiendeConflictivos(Jugador, Medico) :-
    atiende(Medico, Jugador),
    esConflictivo(Jugador).

esConflictivo(Jugador) :- puedeSerSuspendido(Jugador).
esConflictivo(Jugador) :- conocido(Jugador, maradona).

% 7)

programaTVFantinesco(Lista) :-
    findall(Jugador, puedeSerSuspendido(Jugador), JugadoresPosibles),
    list_to_set(JugadoresPosibles, JugadoresUnicos), % Elimina duplicados
    combinar(JugadoresUnicos, Lista).

combinar([], []).

combinar([Jugador | JugadoresPosibles], [Jugador | Jugadores]) :-
    combinar(JugadoresPosibles, Jugadores).

combinar([_ | JugadoresPosibles], Jugadores) :-
    combinar(JugadoresPosibles, Jugadores).
