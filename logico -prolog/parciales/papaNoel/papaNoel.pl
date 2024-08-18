% persona(Nombre, Edad)
persona(laura, 24). 
persona(federico, 31).
persona(maria, 23).
persona(jacobo, 45). 
persona(enrique, 49).
persona(andrea, 38).
persona(gabriela, 4).
persona(gonzalo, 23). 
persona(alejo, 20).
persona(ricardo, 39).
persona(andres, 11).
persona(ana, 7). 
persona(juana, 15).

% quiere(Quién, Quiere)
quiere(andres, juguete(maxSteel, 150)). 
quiere(andres, bloques([piezal, plezat, cubo, plezachata])). 
quiere(maria, bloques([plezat, piezaT])).
quiere(alejo, bloques([plezat])).
quiere(juana, juguete(barble, 175)).
quiere(enrique, abrazo). 
quiere(gabriela, juguete(gabeneltor2000, 5000)).
quiere(federico, abrazo).
quiere(gonzalo, abrazo).
quiere(laura, abrazo).

% presupuesto(Quien, Presupuesto).
presupuesto(jacobo, 20).
presupuesto(enrique, 2311).
presupuesto(ricardo, 154).
presupuesto(andrea, 100).
presupuesto(laura, 2000).

% accion(Quien, Hizo)
accion(andres, travesura(3)).
accion(andres, ayudar(ana)).
accion(ana, golpear(andres)).
accion(ena, travesura(1)).
accion(maria, ayudar(federico)).
accion(maria, favor(juana)).
accion(alejo, travesura(4)).
accion(juana, favor(maria)). 
accion(federico, golpear(enrique)).
accion(gonzalo, golpear(alejo)).

% padre(Padre o Madre, Hijo o Hija).
padre(jacobo, ana).
padre(jacobo, juana).
padre(enrique, federico).
padre(ricardo, maria).
padre(andrea, andres). 
padre(laura, gabriela).