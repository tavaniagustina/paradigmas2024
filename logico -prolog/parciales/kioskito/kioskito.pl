% atiende(persona, dia, horaInicio, horaFin).
atiende(dodain, lunes, 9, 15).
atiende(dodain, miercoles, 9, 15).
atiende(dodain, viernes, 9, 15).
atiende(lucas, martes, 10, 20).
atiende(juanC, sabados, 18, 22).
atiende(juanC, domingos, 18, 22).
atiende(juanFdS, jueves, 10, 20).
atiende(juanFdS, viernes, 12, 20).
atiende(leoC, lunes, 14, 18).
atiende(leoC, miercoles, 14, 18).
atiende(martu, miercoles, 23, 24).

% 1)

% vale atiende los mismos días y horarios que dodain y juanC.
atiende(vale, Dia, HoraInicio, HoraFin) :-
    atiende(dodain, Dia, HoraInicio, HoraFin).

atiende(vale, Dia, HoraInicio, HoraFin) :-
    atiende(juanC, Dia, HoraInicio, HoraFin).

% - nadie hace el mismo horario que leoC
% por principio de universo cerrado, no agregamos a la base de conocimiento aquello que no tiene sentido agregar

% - maiu está pensando si hace el horario de 0 a 8 los martes y miércoles
% por principio de universo cerrado, lo desconocido se presume falso

% 2)

quienAtiende(Persona, Dia, Horario) :-
    % atiende(Persona, _, _, _) es redundante ya que la verificacion de Persona la hace cuando ejecuta la segunda clausula
    atiende(Persona, Dia, HoraInicio, HoraFin),
    between(HoraInicio, HoraFin, Horario).
    
% 3)

foreverAlone(Persona, Dia, Horario) :-
    quienAtiende(Persona, Dia, Horario),
    not((quienAtiende(OtraPersona, Dia, Horario), Persona \= OtraPersona)).
    % Persona \= OtraPersona. not(quienAtiende(OtraPersona, Dia, Horario)) debería ser cierto solo cuando ninguna otra persona atiende en ese horario, 
    % lo que contradice la segunda condición Persona \= OtraPersona, porque si no existe tal OtraPersona, no puedes aplicar la desigualdad.

% 4)

posibilidadesAtencion(Dia, Personas) :-
    findall(Persona, distinct(Persona, quienAtiende(Persona, Dia, _)), PersonasPosibles), % El uso de distinct/2 en el predicado findall/3 dentro de posibilidadesAtencion/2 tiene el propósito de asegurar que la lista de PersonasPosibles no contenga duplicados.
    combinar(PersonasPosibles, Personas).

combinar([], []).

%             Lista de entrada            Lista de salida
combinar([Persona | PersonasPosibles], [Persona | Personas]) :-
    combinar(PersonasPosibles, Personas). % Continúa generando combinaciones con el resto de la lista (PersonasPosibles), es decir, la parte que no incluye la persona que ya hemos añadido.
    
combinar([ _ | PersonasPosibles], Personas) :- % Omite la Persona actual y recursivamente busca combinaciones de las personas restantes PersonasPosibles, generando combinaciones donde Persona no está incluida.
    combinar(PersonasPosibles, Personas).

% Qué conceptos en conjunto resuelven este requerimiento

% - findall como herramienta para poder generar un conjunto de soluciones que satisfacen un predicado
% - mecanismo de backtracking de Prolog permite encontrar todas las soluciones posibles

% 5)

venta(dodain, fecha(10, 8), [golosinas(1200), cigarrilos(jockey), golosinas(50)]).
venta(dodain, fecha(12, 8), [bebida(alcoholica, 8), bebida(noAlcoholica, 1), golosinas(10)]).
venta(martu, fecha(12, 8), [golosinas(1000), cigarrilos([chesterfield, colorado, parisiennes])]).
venta(lucas, fecha(11, 8), [golosinas(600)]).
venta(lucas, fecha(18, 8), [bebidas(noAlcoholica, 2), cigarrillos([derby])]).

esSuertuda(Persona) :- % ocurre si para TODOS los días en los que vendió -> FORALL
    vendedora(Persona),
    forall(venta(Persona, _, [Venta | _ ]), ventaImportante(Venta)). % Me dice que solo la primera venta es importante.

ventaImportante(golosinas(Precio)) :- Precio > 100.

ventaImportante(cigarrillos(Marcas)) :-
    length(Marcas, Cantidad),
    Cantidad > 2.

ventaImportante(bebida(alcoholica, _)).

ventaImportante(bebida(_, Cantidad)) :- Cantidad > 5.

vendedora(Persona) :-
    venta(Persona, _, _).

% Tests

:-begin_tests(kioskito).

test(persona_que_atiende_dia_y_horario_puntual, set(Persona = [dodain, leoC, vale])) :-
    quienAtiende(Persona, lunes, 14).

test(persona_que_atiende_dia_y_horario_puntual, set(Persona = [juanC, vale])) :-
    quienAtiende(Persona, sabados, 18).

test(persona_que_atiende_dia_y_horario_puntual, nondet) :-
    quienAtiende(juanFdS, jueves, 11).

test(persona_que_atiende_dia_y_horario_puntual, set(Dia = [lunes, miercoles, viernes])) :-
    quienAtiende(vale, Dia, 10).

test(forever_alone_dia_y_hora_puntual, nondet) :-
    foreverAlone(lucas, martes, 19).

test(una_persona_esta_forever_alone_porque_atiende_sola, set(Persona = [lucas])):-
    foreverAlone(Persona, martes, 19).

test(no_forever_alone_dia_y_hora_puntual, fail) :-
    foreverAlone(dodain, lunes, 10).

test(posibilidades_de_atencion_en_un_dia, set(Personas = [[], [dodain], [dodain, leoC], [dodain,leoC,martu],[dodain,leoC,martu,vale],[dodain,leoC,vale],[dodain,martu],[dodain,martu,vale],[dodain,vale],[leoC],[leoC,martu],[leoC,martu,vale],[leoC,vale],[martu],[martu,vale],[vale]])) :-
    posibilidadesAtencion(miercoles, Personas).

test(persona_suertuda, nondet) :-
    esSuertuda(martu).

test(persona_suertuda, nondet) :-
    esSuertuda(dodain).

:-end_tests(kioskito).