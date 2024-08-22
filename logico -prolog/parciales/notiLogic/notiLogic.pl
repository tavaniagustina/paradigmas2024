% 1)
% noticia(autor, articulo(titulo, deportista(nombre, titulo)), visitas).
% noticia(autor, articulo(titulo, farandula(nombre, personajePeleado)), visitas).
% noticia(autor, articulo(titulo, deportista(nombre, partidoPolitico)), visitas).

noticia(artVandelay, articulo("Nuevo título para Lloyd Braun", deportista(lloydBraun, 5)), 25).
noticia(elaineBenes, articulo("Primicia", farandula(jerrySeinfeld, kennyBania)), 16).
noticia(elaineBenes, articulo("El dólar bajó! ... de un arbolito", farandula(jerrySeinfeld, newman)), 150).
noticia(bobSacamano, articulo("No consigue ganar ni una carrera", deportista(davidPuddy, 0)), 10).
noticia(bobSacamano, articulo("Cosmo Kramer encabeza las elecciones", politico(cosmoKramer, "los amigos del poder")), 155).

% roba las noticias de Bob Sacamano obteniendo la misma cantidad de visitas y todas las noticias de farándula las
% transforma en noticias de política involucrando al famoso como político perteneciente al partido amigos del poder, pero 
% como la noticia es puro chamuyo obtiene la mitad de las visitas que la original.

% esto es un y logico, pasan las dos cosas juntas, no en dos predicados distintos.

noticia(georgeCostanza, articulo(Titulo, Personaje), Visitas) :-
    robaArticulo(georgeCostanza, Autor),
    noticia(Autor, articulo(Titulo, PersonajeOriginal), VisitasOriginales),
    personajeRobado(PersonajeOriginal, Personaje),
    visitasArticuloRobado(VisitasOriginales, PersonajeOriginal, Visitas).

robaArticulo(georgeCostanza, bobSacamano).
robaArticulo(georgeCostanza, elaineBenes).

personajeRobado(farandula(Personaje, _), politico(Personaje, "los amigos del poder")).
personajeRobado(PersonajeOriginal, PersonajeOriginal) :-  PersonajeOriginal \= farandula(_, _). % Ningun PersonajeOriginal debe pertenecer a farandula

visitasArticuloRobado(VisitasOriginales, farandula(_, _), Visitas) :-  
    Visitas is VisitasOriginales / 2.

visitasArticuloRobado(VisitasOriginales, PersonajeOriginal, VisitasOriginales) :-  PersonajeOriginal \= farandula(_, _).

% Si bien George hace de las suyas, sabemos que Elaine Benes no roba las noticias de Art Vandelay.
% Por principio de universo cerrado -> todo lo que se presume falso no se escribe

% 2)

articuloAmarillista(Articulo) :-
    articulo(Articulo),
    esAmarillista(Articulo).

articulo(Articulo) :-
    distinct(Articulo, noticia(_, Articulo, _)).

esAmarillista(articulo("Primicia", _)).

esAmarillista(articulo(_, PersonajeInvolucrado)) :- 
    estaComplicado(PersonajeInvolucrado).

estaComplicado(deportista(_, Titulos)) :- Titulos < 3.
estaComplicado(farandula(_, jerrySeinfeld)).
estaComplicado(politico(_, _)).

% 3)

% 1.
noLeImportaNada(Autor) :-
    autor(Autor),
    forall(noticiasMuyVisitadas(Autor, Articulo), esAmarillista(Articulo)).

autor(Autor) :-
    distinct(Autor, noticia(Autor, _, _)).

noticiasMuyVisitadas(Autor, Articulo) :-
    noticia(Autor, Articulo, Visitas),
    Visitas > 15.

% 2.

autorMuyOriginal(Autor) :-
    autor(Autor),
    not((noticia(Autor, articulo(Titulo, _), _), noticia(OtroAutor, articulo(Titulo, _), _), Autor \= OtroAutor)).

% 3. 
autorConUnTraspie(Autor) :-
    noticia(Autor, Articulo, _),
    not(noticiasMuyVisitadas(Autor, Articulo)).

% 4)

edicionLoca(Articulos) :-
    findall(Articulo, esAmarillista(Articulo), ArticulosPosibles),
    combinacion(ArticulosPosibles, Articulos, Visitas),
    Visitas < 50.

combinacion([], [], 0).

combinacion([Articulo | ArticulosPosibles], [Articulo | Articulos], VisitasTotales) :-
    combinacion(ArticulosPosibles, Articulos, VisitasRestantes),
    noticia(_, Articulo, CantidadVisitas),
    VisitasTotales is CantidadVisitas + VisitasRestantes.

combinacion([_ | ArticulosPosibles], Articulos, VisitasTotales) :-
    combinacion(ArticulosPosibles, Articulos, VisitasTotales).