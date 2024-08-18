% dondeVive(nombre rata, donde vive).
dondeVive(remy, gusteaus).
dondeVive(emile, barMalabar).
dondeVive(django, pizzeriaJeSuis).

% cocina(nombre chef, nombre plato, experiencia).
cocina(linguini, ratatouille, 3).
cocina(linguini, sopa, 5).
cocina(colette, salmonAsado, 9).
cocina(horst, ensaladaRusa, 8).

% trabajaEn(restaurante, nombre chef).
trabajaEn(gusteaus, linguini).
trabajaEn(gusteaus, colette).
trabajaEn(gusteaus, skinner).
trabajaEn(gusteaus, horst).
trabajaEn(cafeDes2Moulins, amelie).

% 1)
inspeccionSatisfactoria(Restaurante) :-
    trabajaEn(Restaurante, _),
    not(dondeVive(_, Restaurante)).

% 2)
chef(Chef, Restaurante) :-
    restaurante(Restaurante),
    trabajaEn(Restaurante, Chef),
    cocina(Chef, _, _). % Con que haya un plato cualquiera es suficiente.

restaurante(Restaurante) :-
    distinct(Restaurante, trabajaEn(Restaurante, _)).
    
% 3)
chefcito(Rata) :-
    dondeVive(Rata, Restaurante),
    trabajaEn(Restaurante, linguini).

% 4)
cocinaBien(Chef, Plato) :-
    cocina(Chef, Plato, Experiencia),
    Experiencia >= 7.

cocinaBien(remy, _). % Esta mal esto??

% cocinaBien(remy, Plato) :-
%     plato(Plato, _).

% 5)
encargadoDe(Chef, Plato, Restaurante) :-
    cocinaEn(Chef, Restaurante, Plato, ExperienciaMaxima),
    forall(cocinaEn(Chef, Restaurante, Plato, ExperienciaChef), ExperienciaChef =< ExperienciaMaxima).

cocinaEn(Chef, Restaurante, Plato, Experiencia) :-
    chef(Chef, Restaurante),
    cocina(Chef, Plato, Experiencia).

% 6)

% entradas([ingredientes]).
% principal(guarnición, minutos de cocción). 
% postres(calorías).

% plato(nombre plato, entrada | plato principal | postre).
plato(ensaladaRusa, entrada([papa, zanahoria, arvejas, huevo, mayonesa])).
plato(bifeDeChorizo, principal(pure, 25)).
plato(frutillasConCrema, postre(265)).

saludable(Plato) :-
    plato(Plato, Tipo),
    caloriasPorPlato(Tipo, CaloriasTotales),
    CaloriasTotales < 75.

caloriasPorPlato(entrada(Ingredientes), Calorias) :-
    length(Ingredientes, Cantidad),
    Calorias is Cantidad * 15.

caloriasPorPlato(principal(Guarnicion, TiempoCoccion), Calorias) :-
    CaloriasCoccion is TiempoCoccion * 5,
    caloriasPorPlato(Guarnicion, CaloriasGuarnicion),
    Calorias is CaloriasCoccion + CaloriasGuarnicion.

caloriasPorPlato(papasFritas, 50).
caloriasPorPlato(pure, 20).
caloriasPorPlato(ensalada, 0).

caloriasPorPlato(postre(Calorias), Calorias).

% 7) 
criticaPositiva(Restaurante, Critico) :-
    inspeccionSatisfactoria(Restaurante),
    reseniaPositiva(Critico, Restaurante).

reseniaPositiva(antonEgo, Restaurante) :-
    especialistaEn(ratatouille, Restaurante).
    
reseniaPositiva(christophe, Restaurante) :-
    findall(Chef, chef(Chef, Restaurante), Chefs),
    length(Chefs, Cuantos),
    Cuantos > 3.

reseniaPositiva(cormillot, Restaurante) :-
    restaurante(Restaurante),
    todosPlatosSaludables(Restaurante),
    todasLasEntradasTienenZanahoria(Restaurante).

especialistaEn(Plato, Restaurante) :-
    forall(chef(Chef, Restaurante), cocinaBien(Chef, Plato)).

todosPlatosSaludables(Restaurante) :-
    forall(cocinaEn(_, Restaurante, Plato, _), saludable(Plato)).

todasLasEntradasTienenZanahoria(Restaurante) :-
    forall(entradasDe(Restaurante, Ingredientes), tieneZanahoria(Ingredientes)).

entradasDe(Restaurante, Ingredientes) :-
    plato(Plato, entrada(Ingredientes)),
    cocinaEn(_, Restaurante, Plato, _).

tieneZanahoria(Ingredientes) :-
    member(zanohoria, Ingredientes).
    
% A gordon ramsay no hace falta agregarlo como una regla por el principio del universo cerrado, ya que todo lo que 
% no se encuentre en la base de conocimiento o en este caso, como una regla, es falso. 