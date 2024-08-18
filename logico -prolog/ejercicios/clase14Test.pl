:- include(Clase14).

% En consola:
% run_tests

% --------------------------------------------------------------------------------------------------------------------------------------------------------

:- begin_tests(gana_buen_sueldo) 

    test("persona que gana un buen sueldo") :-
        ganaBuenSueldo(matt).

    test("persona que no gana un buen sueldo", fail) :-
        ganaBuenSueldo(danny).

    test("personas que ganan un buen sueldo", set(Persona = [matt, foggy, frank])) :-
        ganaBuenSueldo(Persona).
    
:- end_tests(gana_buen_sueldo). 

% :- begin_tests(tiene_tiempo_libre) 

%     test("persona que tiene tiempo libre") :-
%         tieneTiempoLibre(stick).

% :- end_tests(tiene_tiempo_libre). 

% :- begin_tests(tiene_buen_trabajo) 

%     test("persona que tiene buen trabajo", nondet) :-
%         tieneBuenTrabajo(foggy).

% :- end_tests(tiene_buen_trabajo). 