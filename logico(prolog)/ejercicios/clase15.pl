% Quiero saber si todos los elementos de una lista estan incluidas en otra

incluido(A, B) :-
    forall(member(Elemento, A), member(Elemento, B)).

% Quiero saber si todos los elementos de una lista no estan incluidas en otra

noIncluido(A, B) :-
    forall(member(Elemento, A), not(member(Elemento, B))).

% --------------------------------------------------------------------------------------------------------------------------------------------------------

equipoGrande(deportivoPlanificador).
equipoGrande(defensoresDelFyleSystem).
equipoGrande(procesosUnidos).

jugo(molina, deportivoPlanificador).
jugo(molina, defensoresDelFyleSystem).
jugo(molina, procesosUnidos).
jugo(bertolini, deportivoPlanificador).
jugo(frasoldatti, chacarita).
jugo(frasoldatti, flandria).
jugo(frasoldatti, procesosUnidos).
jugo(frasoldatti, defensoresDelFyleSystem).
jugo(frasoldatti, deportivoPlanificador).

% Un jugador es consagrado cuando jugo solamente en equipos grandes
consagrado(Jugador) :-
    futbolista(Jugador),
    forall(jugo(Jugador, Equipo), equipoGrande(Equipo)).

futbolista(Jugador) :-
    distinct(Jugador, jugo(Jugador, _)).

% Quiero saber que futbolista jugo en mas de 2 equipos
jugoVarios(Jugador) :-
    futbolista(Jugador),
    findall(Equipo, jugo(Jugador, Equipo), Equipos), % Equipos es una lista
    length(Equipos, Cantidad),
    Cantidad > 2.

% Quiero saber que futbolista jugo en mas de 2 equipos y esos equipos son grandes
jugoVariosYGrandes(Jugador) :-
    futbolista(Jugador),
    findall(Equipo, (jugo(Jugador, Equipo), equipoGrande(Equipo)), Equipos), 
        length(Equipos, Cantidad),
        Cantidad > 2.

% --------------------------------------------------------------------------------------------------------------------------------------------------------

nota(pdp, vera, 9).
nota(pdp, dauria, 8).
nota(pdp, krasuk, 6).
nota(pdp, goffredo, 6).
nota(pdp, bardelli, 9).
nota(pdp, gimenez, 2).
nota(pdp, benitez, 2).
nota(pdp, margiotta, 8).
nota(sysop, dauria, 10).
nota(sysop, krasuk, 2).
nota(sysop, goffredo, 9).
nota(discreta, krasuk, 3).
nota(discreta, goffredo, 6).

materia(pdp).
materia(sysop).
materia(discreta).

% Quiero saber cuantas personas rindieron una materia
% Persona es la variable

cuantosRindieron(Materia, Cantidad) :-
    materia(Materia),
    findall(Persona, nota(Materia, Persona, _), Personas),
    length(Personas, Cantidad).

% Quiero saber cuantas personas aprobaron una materia
cuantosAprobaron(Materia, Cantidad) :-
    materia(Materia),
    findall(Persona, (nota(Materia, Persona, Nota), Nota >= 6), Personas),
    length(Personas, Cantidad).

% Quiero saber el promedio de notas de una persona
promedioNotas(Persona, Promedio) :-
    persona(Persona),
    findall(Nota, nota(_, Persona, Nota), Notas),
    sumlist(Notas, Total),
    length(Notas, Cantidad),
    Promedio is Total / Cantidad.
    
persona(Persona) :-
    distinct(Persona, nota(_, Persona, _)).

% Otra forma
cuantosRindieronPiola(Materia, Cuantos):-
    materia(Materia),    
    aggregate_all(count, nota(Materia, _, _), Cuantos).

cuantosAprobaronPiola(Materia, Cuantos):-
    materia(Materia),    
    aggregate_all(count, (nota(Materia, _, Nota), Nota >= 6), Cuantos).
    
% Puede ir a medalla de honor (promedio > 7)
medallaDeHonor(Persona) :-
    persona(Persona), 
    aggregate_all(resumen(count, sum(Nota)), nota(_, Persona, Nota), resumen(Cantidad, Total)),
    Promedio is Total / Cantidad,
    Promedio > 7.

% Una materia amena se da si promocionan más de 3 personas
materiaAmena(Materia):-
    materia(Materia),
    aggregate_all(count, (nota(Materia, _, Nota), Nota > 7), CantidadPromocionan),
    CantidadPromocionan > 3.

% Una materia es heavy si la nota mas alta es menor a 8
materiaHeavy(Materia) :-
    materia(Materia),
    aggregate_all(max(Nota), nota(Materia, _, Nota), MayorNota),
    MayorNota < 8.

% ?- materiaHeavy(Materia).
% Materia = discreta.

% Quiénes promocionan: sacaron más de 7 en cualquier materia
quienesPromocionanAlguna(Personas):-
    aggregate_all(set(Persona), (nota(_, Persona, Nota), Nota > 7), Personas).

% quienesPromocionanAlguna(Personas)
% Personas = [dauria, goffredo, margiotta, vera].

% En lugar de set usamos un bag
quienesPromocionanAlguna2(Personas):-
    aggregate_all(bag(Persona), (nota(_, Persona, Nota), Nota > 7), Personas).

% se repiten
% quienesPromocionanAlguna2(Personas)
% Personas = [vera, dauria, bardelli, margiotta, dauria, goffredo].