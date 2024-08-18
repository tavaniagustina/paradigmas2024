% canta(nombre, cancion(nombre, duracion)).
canta(megurineLuka, canta(nightFever, 4)).
canta(megurineLuka, canta(foreverYoung, 5)).
canta(hatsuneMiku, cancion(tellYourWorld, 4)).
canta(gumi, cancion(foreverYoung, 4)).
canta(gumi, cancion(tellYourWorld, 5)).
canta(seeU, cancion(novemberRain, 6)).
canta(seeU, cancion(nightFever, 5)).

% Por principio de universo cerrado no se agrega a kaito a la base de conocimiento inicial 
% ya que no sabe cantar ninguna canción por lo tanto no podemos relacionarlo con una canción.

% 1)

esNovedoso(Cantante) :-
    sabeAlMenosDosCanciones(Cantante),
    tiempoTotalCanciones(Cantante, DuracionTotal),
    between(0, 15, DuracionTotal).

sabeAlMenosDosCanciones(Cantante) :-
    canta(Cantante, canta(Cancion1, _)),
    canta(Cantante, canta(Cancion2, _)),
    Cancion1 \= Cancion2.

tiempoTotalCanciones(Cantante, DuracionTotal) :-
    cantante(Cantante), % Esto no lo pone en el resuelto, pero si probas por consola, si no lo pones, cantante no es inversible
    findall(Duracion, tiempoDeCancion(Cantante, Duracion), Duraciones),
    sum_list(Duraciones, DuracionTotal).

cantante(Cantante) :-
    distinct(Cantante, canta(Cantante, _)).

% tiempoTotalCanciones(Cantante, TiempoTotal) :-
%   findall(TiempoCancion, 
%   tiempoDeCancion(Cantante, TiempoCancion), Tiempos), 
%   sumlist(Tiempos,TiempoTotal).

% tiempoDeCancion(Cantante,TiempoCancion):-  
%   canta(Cantante,Cancion),
%   tiempo(Cancion,TiempoCancion).

% tiempo(cancion(_, Tiempo), Tiempo).

% 2)

esAcelerado(Cantante) :-
    cantante(Cantante), 
    not((tiempoDeCancion(Cantante, Duracion), Duracion > 4)).

% Si nos permitieran usar el forall/2 acá nos quedaría en vez del not/1:
% forall(tiempoDeCancion(Cantante,Tiempo), Tiempo <= 4).

% ”No canta una canción que dure más de 4 minutos” (not/1) es lo mismo que “Todas sus canciones duran 4 o menos minutos” (forall/2).

% Es decir que el FORALL es equivalente al NOT

tiempoDeCancion(Cantante, Duracion) :-
    canta(Cantante, cancion(_, Duracion)).

% 3)

% 1.
% tipoConcierto -> gigante(cancionesMinimas, duracionMinima).
%               -> mediano(duracionMaxima).
%               -> pequenio(duracionMayorA).

% concierto(nombre, pais, cantidadFama, tipoConcierto).
concierto(mikuExpo, estadosUnidos, 2000, gigante(2, 6)).
concierto(magicalMirai, japon, 3000, gigante(3, 10)).
concierto(vocalektVisions, estadosUnidos, 1000, mediano(9)).
concierto(mikuFest, argentina, 100, pequenio(4)).

% 2.

puedeParticipar(Cantante, Concierto) :-
   cantante(Cantante),
   Cantante \= hatsuneMiku,
   concierto(Concierto, _, _, Requisitos),
   cumpleRequisitos(Cantante, Requisitos).

puedeParticipar(hatsuneMiku, Concierto) :-
    concierto(Concierto, _, _, _).

cumpleRequisitos(Cantante, gigante(CancionesMinimas, DuracionMinima)) :-
    cantidadDeCanciones(Cantante, Cantidad),
    Cantidad >= CancionesMinimas,
    tiempoTotalCanciones(Cantante, DuracionTotal),
    DuracionTotal > DuracionMinima.

cumpleRequisitos(Cantante, mediano(DuracionMaxima)) :-
    tiempoTotalCanciones(Cantante, DuracionTotal),
    DuracionTotal < DuracionMaxima.

cumpleRequisitos(Cantante, pequenio(DuracionMayorA)) :-
    cantante(Cantante), % es esto redundante?? Si no lo pongo me da la consulta al final sin false, si lo pongo me da false
    tiempoDeCancion(Cantante, Duracion), 
    Duracion > DuracionMayorA.

cantidadDeCanciones(Cantante, Cantidad) :-
    cantante(Cantante), % Idem ant??
    findall(Cancion, canta(Cantante, Cancion), Canciones),
    length(Canciones, Cantidad).

% 3.

masFamoso(Cantante) :-
    cantante(Cantante), % Idem ant??
    cantidadFama(Cantante, NivelMaximo),
    forall(cantidadFama(_, Nivel), NivelMaximo >= Nivel).

cantidadFama(Cantante, Nivel) :-
    famaConciertos(Cantante, ConciertosFama),
    cantidadDeCanciones(Cantante, Cantidad),
    Nivel is ConciertosFama * Cantidad.

famaConciertos(Cantante, ConciertosFama) :-
    cantante(Cantante),
    findall(Fama, famaParticular(Cantante, Fama), Famas),
    sum_list(Famas, ConciertosFama).

famaParticular(Cantante, Fama) :-
    puedeParticipar(Cantante, Concierto),
    concierto(Concierto, _, Fama, _).

% 4.

conoce(megurineLuka, hatsuneMiku).
conoce(megurineLuka, gumi).
conoce(gumi, seeU).
conoce(seeU, kaito).

unicoEnParticipar(Cantante, Concierto) :-
    puedeParticipar(Cantante, Concierto),
    not((conocido(Cantante, OtroCantante), puedeParticipar(OtroCantante, Concierto))).

% Conocido directo
conocido(Cantante, OtroCantante) :-
    conoce(Cantante, OtroCantante).

% Conocido indirecto
conocido(Cantante, OtroCantante) :-
    conoce(Cantante, UnCantante),
    conocido(UnCantante, OtroCantante).

% 5.

% En la solución planteada habría que agregar una claúsula en el predicado cumpleRequisitos/2  que tenga en 
% cuenta el nuevo functor con sus respectivos requisitos.

% El concepto que facilita los cambios para el nuevo requerimiento es el polimorfismo, que nos permite dar un tratamiento en particular a cada uno de los 
% conciertos en la cabeza de la cláusula.