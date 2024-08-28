% define quiénes son amigos de nuestro cliente  
amigo(mati).  
amigo(pablo).  
amigo(leo).  
amigo(fer).   
amigo(flor). 
amigo(ezequiel).   
amigo(marina).   

% define quiénes no se pueden ver 
noSeBanca(leo, flor).   
noSeBanca(pablo, fer). 
noSeBanca(fer, leo).   
noSeBanca(flor, fer). 
 
% define cuáles son las comidas y cómo se componen 
% functor achura -> contiene nombre, cantidad de calorías 
% functor ensalada -> contiene nombre, lista de ingredientes 
% functor morfi -> contiene nombre (el morfi es una comida principal) 

comida(achura(chori, 200)). 
comida(achura(chinchu, 150)). 
comida(ensalada(waldorf, [manzana, apio, nuez, mayo])). 
comida(ensalada(mixta, [lechuga, tomate, cebolla])). 
comida(morfi(vacio)). 
comida(morfi(mondiola)). 
comida(morfi(asado)).  

% relacionamos la comida que se sirvió en cada asado 
% cada asado se realizó en una única fecha posible: functor fecha + comida  
asado(fecha(22,9,2011), chori).   
asado(fecha(15,9,2011), mixta). 
asado(fecha(22,9,2011), waldorf).  
asado(fecha(15,9,2011), mondiola). 
asado(fecha(22,9,2011), vacio).    
asado(fecha(15,9,2011), chinchu).  

% relacionamos quiénes asistieron a ese asado 
asistio(fecha(15,9,2011), flor).   
asistio(fecha(22,9,2011), marina). 
asistio(fecha(15,9,2011), pablo).  
asistio(fecha(22,9,2011), pablo). 
asistio(fecha(15,9,2011), leo).    
asistio(fecha(22,9,2011), flor). 
asistio(fecha(15,9,2011), fer).    
asistio(fecha(22,9,2011), mati). 

% definimos qué le gusta a cada persona 
leGusta(mati, chori).      
leGusta(fer, mondiola).   
leGusta(pablo, asado). 
leGusta(mati, vacio).      
leGusta(fer, vacio). 
leGusta(mati, waldorf).      
leGusta(flor, mixta).

% 1)

% Aca entiendo que es un OR logico, pero se deberia preguntar al profesor si a eze le gusta todo lo que le gusta a ambos (Y logico) ò si le gusta lo de mati y le gusta lo de fer (OR logico).
leGusta(ezequiel, Comida) :- leGusta(mati, Comida).
leGusta(ezequiel, Comida) :- leGusta(fer, Comida).

leGusta(marina, Comida) :- leGusta(flor, Comida).

leGusta(marina, mondiola).

% A Leo no le gusta la ensalada waldorf.
% Por principio de universo cerrado todo lo q se considera falso no se escribe.

% 2)

asadoViolento(FechaAsado) :-
    distinct((FechaAsado),
        (asistio(FechaAsado, UnaPersona),   
        noSeBanca(UnaPersona, OtraPersona),
        asistio(FechaAsado, OtraPersona))
    ).  

% 3)

calorias(Comida, Calorias) :-
    caloriasPorComida(Comida, Calorias).

caloriasPorComida(Comida, Calorias) :-
    comida(achura(Comida, Calorias)).

caloriasPorComida(Comida, Calorias) :- 
    comida(ensalada(Comida, Ingredientes)),
    length(Ingredientes, Calorias).

caloriasPorComida(Comida, 200) :-
    comida(morfi(Comida)).

% 4)

asadoFlojito(FechaAsado) :-
    fecha(FechaAsado),
    findall(Caloria, caloriasDelAsado(FechaAsado, Caloria), Calorias),
    sum_list(Calorias, CaloriasTotales),
    CaloriasTotales < 400. 

caloriasDelAsado(FechaAsado, Caloria) :-
    fecha(FechaAsado),
    asado(FechaAsado, Comida), 
    calorias(Comida, Caloria).

% Otra solucion
asadoFlojito2(FechaAsado) :-
    fecha(FechaAsado),
    aggregate_all(sum(Calorias), (asado(FechaAsado, Comida), calorias(Comida, Calorias)), TotalCalorias),
    TotalCalorias < 400.

fecha(FechaAsado) :-
    distinct(FechaAsado, asado(FechaAsado, _)). 

% 5)

hablo(fecha(15,09,2011), flor, pablo).  
hablo(fecha(22,09,2011), flor, marina). 
hablo(fecha(15,09,2011), pablo, leo).   
hablo(fecha(22,09,2011), marina, pablo). 
hablo(fecha(15,09,2011), leo, fer).     
reservado(marina).

chismeDe(FechaAsado, ConocedorChisme, ChismeDeQuien) :-
    fecha(FechaAsado),
    seConocen(FechaAsado, ChismeDeQuien, ConocedorChisme),
    not(reservado(ChismeDeQuien)).

seConocen(FechaAsado, ChismeDeQuien, ConocedorChisme) :-
    hablo(FechaAsado, ChismeDeQuien, ConocedorChisme).  

seConocen(FechaAsado, ChismeDeQuien, ConocedorChisme) :-
    hablo(FechaAsado, ChismeDeQuien, PersonaIntermedia),
    not(reservado(PersonaIntermedia)),
    seConocen(FechaAsado, PersonaIntermedia, ConocedorChisme),
    ConocedorChisme \= ChismeDeQuien.

% 6)

disfruto(Persona, FechaAsado) :-
    asistio(FechaAsado, Persona),
    findall(Comida, comidasQueConsumio(Comida, Persona, FechaAsado), Comidas),
    length(Comidas, Cantidad),
    Cantidad >= 3.

comidasQueConsumio(Comida, Persona, FechaAsado) :-
    asado(FechaAsado, Comida),
    leGusta(Persona, Comida).

% 7)

asadoRico(Comidas) :-
    findall(Comida, comidasRicas(Comida), ComidasPosibles),
    combinar(ComidasPosibles, Comidas).

comidasRicas(Comida) :-
    comida(Comida),
    esComidaRica(Comida).

esComidaRica(morfi(_)).
esComidaRica(ensalada(_, Ingredientes)) :- length(Ingredientes, Cantidad), Cantidad > 3.
esComidaRica(achura(chori, _)).
esComidaRica(achura(chinchu, _)).

% Como no quiero la lista vacia, entonces el caso base es la lista de un elemento.
combinar([UnElemento], [UnElemento]).

combinar([PrimeraComida | RestoDeComidas], [PrimeraComida | MasComidas]) :-
    combinar(RestoDeComidas, MasComidas).

combinar([_ | RestoDeComidas], MasComidas) :-
    combinar(RestoDeComidas, MasComidas).