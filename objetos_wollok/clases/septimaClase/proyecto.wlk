class Tarea 
{
    var property tiempo 
    var property complejidad

    // method costo(tarea) = self.costoComplejidad(tarea) + self.costoPorOverhead() + self.costoImpositivo()
    method costo(tarea) = self.costoBase() + self.costoPorOverhead() + self.costoImpositivo()

    // method costoComplejidad() = complejidad.costo(self) 
    // method costoComplejidad(tarea) = complejidad.costo(tarea) + self.extra(tarea)

    method costoBase() = complejidad.costoBase(self)
    method costoPorOverhead()
    method costoImpositivo()

}

class TareaSimple inherits Tarea
{
    var property procentajeCumplimiento = 0 

    override method costoPorOverhead() = 0

    method cumplir() { procentajeCumplimiento = 100 }
}

class TareaCompuesta inherits Tarea
{
    var property subtareas = []

    override method costoPorOverhead() = if(self.tieneMucasSubtareas()) self.costoBase() * 0.04 else 0

    method tieneMucasSubtareas() = subtareas.size() > 3

    method cumplir() {throw new Exception(message = "No se puede cumplir una tarea compuesta")}

    // las tareas que posean subtareas se calculará en base al promedio ponderado de las mismas.
    method porcentajeDeCumplimiento() = subtareas.sum {tareas => tareas.porcentajeDeCumplimiento()} / subtareas.size()
}

class Complejidad
{
    var property subtareas = []

    method costo(tarea) = self.costoBase(tarea) + self.extra(tarea)
    method costoBase(tarea) = tarea.tiempo() * 25 
    method extra(tarea)
}

// Me doy cuenta que es un inheriths porq tarea.tiempo() * 25 es igual en todas las complejidades, entonces hago una class Complejidad
// para trabajar con ese valor y luego delegar en las distintas complejidades
object complejidadMinima inherits Complejidad
{
    // override method costo(tarea) = 0 -> no hace falta ponerlo, con que este en Class Complejida basta
    override method extra(tarea) = 0
}

object complejidadMedia inherits Complejidad
{
    // override method costo(tarea) = super(tarea) * 1.05
    override method extra(tarea) = self.costoBase(tarea) * 0.05
}

object complejidadMaxima inherits Complejidad
{   
    // override method costo(tarea) = if(tarea.tiempo() <= 10) 0.7 else 1.07 + 10 * (tarea.tiempo() - 10)
    override method extra(tarea) = self.costoBase(tarea) * 0.07 + 10 * 0.max(tarea.tiempo() - 10)
}

// class Impuesto()
// {
//     var property porcentaje

//     method calculaValor(valorBase) = valorBase * self.porcentaje()

// }