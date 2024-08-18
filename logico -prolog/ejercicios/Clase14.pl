% Personas que programan
programaEn(richard, javaScript).
programaEn(dinesh, haskell).
programaEn(dinesh, ruby).
programaEn(erlich, haskell).
programaEn(erlich, scala).
programaEn(erlich, javaScript).
programaEn(gilfoyle, prolog).

programador(Programador) :-
    distinct(Programador, programaEn(Programador, _)). % el distinct no repite los individuos q satisfacen la consulta

% Es indispensable aquel programador que programe en determinado lenguaje en el que ninguno otro programa
indispensable(Programador) :-
    % programador(Programador),
    programaEn(Programador, Lenguaje),
    not((programaEn(OtroProgramador, Lenguaje), Programador \= OtroProgramador)).
    
% El lenguaje mas dificil de aprender es el que mas horas tarda en aprenderse

aprendizaje(javaScript, 60).
aprendizaje(haskell, 70).
aprendizaje(scala, 100).
aprendizaje(ruby, 50).

lenguajeMasDificil(Lenguaje) :-
    aprendizaje(Lenguaje, Horas),
    not((aprendizaje(OtroLenguaje, OtrasHoras), Lenguaje \= OtroLenguaje, Horas > OtrasHoras)).

% Un lenguaje es copado cuando quienes lo programan, ganan bastante (mas de $100) o si programan bien

programaBien(dinesh).
programaBien(gilfoyle).

gana(richard, 150).
gana(dinesh, 40).
gana(erlich, 90).
gana(gilfoyle, 80).

lenguajeCopado(Lenguaje) :-
    lenguaje(Lenguaje), % debe ser inversible, el 'lenguaje' aparece de la nada -> debo ligar las variables
    forall(programaEn(Programador, Lenguaje), personaIdeal(Programador)).

lenguaje(Lenguaje) :-
    distinct(programaEn(_, Lenguaje)).

personaIdeal(Programador) :- % a partir de esto hago la bifurcacion de caso: o ganan bastante o programan bien (deben cumplorlo TODOS, por eso el forall).
    gana(Programador, Dinero),
    Dinero > 100.

personaIdeal(Programador) :-
    programaBien(Programador).

% Un lenguaje es shipeado cuando a todos los que lo programan, les gusta dicho lenguaje

leGusta(richard, javaScript).
leGusta(erlich, javaScript).
leGusta(dinesh, ruby).
leGusta(erlich, haskell).

lenguajeShipeado(Lenguaje) :-
    lenguaje(Lenguaje),
    forall(programaEn(Programador, Lenguaje), leGusta(Programador, Lenguaje)).

% Un lenguaje es tolerado si a todos aquellos que lo programan, no les gusta dicho lenguaje

lenguajeTolerado(Lenguaje) :-
    lenguaje(Lenguaje),
    forall(programaEn(Programador, Lenguaje), not(leGusta(Programador, Lenguaje))).

% Un lenguaje es eclectico cuando no todos los que lo programan les gusta dicho lenguaje

lenguajeEclectico(Lenguaje) :-
    lenguaje(Lenguaje),
    not(forall(programaEn(Programador, Lenguaje), leGusta(Programador, Lenguaje))).

% --------------------------------------------------------------------------------------------------------------------------------------------------------

% materia(materia, año).
materia(algoritmos, 1).
materia(analisis, 1).
materia(pdp, 2).
materia(proba, 2).
materia(sintaxis, 2).

% nota(persona, materia, nota).
nota(jess, pdp, 10).
nota(jess, proba, 7).
nota(jess, sintaxis, 8).
nota(logan, pdp, 6).
nota(logan, proba, 2).
nota(dean, pdp, 9).

% Una persona termina un año cuando tiene aprobadas todas las materias de ese año
% Defino un predicado generador por extension:

% persona(nico).
% persona(malena).
% persona(raul).

% El problema con esta forma, es que si se agrega una nota de una persona diferente a la base de conocimiento, hay que acodarse de agregarlo aca.
% Defino una regla:

persona(Persona) :-
    distinct(Persona, nota(Persona, _, _)).

anio(Anio) :-
    distinct(Anio, materia(_, Anio)).

terminoAnio(Persona, Anio) :-
    anio(Anio),
    persona(Persona),
    forall(materia(Materia, Anio), aprobo(Persona, Materia)).

aprobo(Alumno, Materia) :-
    nota(Alumno, Materia, Nota),
    Nota >= 6.

% Ligar de menos -> no es inversible
% Ligar de mas -> no quedan variables / incognitas, entonces el forall queda obsoleto

% Quiero saber que materias aprobo un alumno, y a que año pertenecen

% findall(metio(Alumno, Materia, Anio), (aprobo(Alumno, Materia), materia(Materia, Anio)), MateriasMetidas).

% MateriasMetidas = [metio(nico, pdp, 2), metio(nico, proba, 2)].

% --------------------------------------------------------------------------------------------------------------------------------------------------------
