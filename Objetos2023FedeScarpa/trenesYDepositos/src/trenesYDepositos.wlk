class Formacion {
	const property vagones = []
	const property locomotoras = []
	
	// punto01
	method agregarVagon(unVagon) {
		vagones.add(unVagon)
	}
	
	// punto02
	method agregarLocomotora(unaLocomotora) {
		locomotoras.add(unaLocomotora)
	}
	
	// punto03
	method cantidadVagones() {
		return vagones.size()
	}
	
	// punto04
	method totalPasajeros() {
		return vagones.sum {vagon => vagon.cantidadPasajeros()}
	}
	
	// punto05
	method cantidadVagonesLivianos() {
		return vagones.count {vagon => vagon.esLiviano()}
	}
	
	// punto06
	method velocidadMaxima() {
		return locomotoras.map {formacion => formacion.velocidadMaxima()}.min()
	}
	
	// punto07
	method esEficiente() {
		return locomotoras.all {locomotora => locomotora.esEficiente()}
	}
	
	// punto08
	method puedeMoverse() {
		return self.arrastreUtilTotal() >= self.pesoMaximoVagones()
	}
	
	method arrastreUtilTotal() {
		return locomotoras.sum {locomotora => locomotora.arrestreUtil()}
	}
	
	method pesoMaximoVagones() {
		return vagones.sum {vagon => vagon.pesoMaximo()}
	}
	
	// punto09
	method kilosDeEmpujeFaltante() {
		return 0.max(self.arrastreUtilTotal() - self.pesoMaximoVagones())
	}
	
	// punto10
	method vagonMasPesado() {
		return vagones.max {vagon => vagon.pesoMaximo()}
	}
	
	// punto11
	method esCompleja() {
		return self.tieneMuchasUnidades() || self.pesoTotal() > 10000
	}
	
	method tieneMuchasUnidades() {
		return self.cantidadDeUnidades() > 20
	}
	
	method cantidadDeUnidades() {
		return self.cantidadVagones() + self.cantidadLocomotoras()
	}
	
	method cantidadLocomotoras() {
		return locomotoras.size()
	}
	
	method pesoTotal() {
		return self.pesoMaximoVagones() + self.pesoMaximoLocomotoras()
	}
	
	method pesoMaximoLocomotoras() {
		return locomotoras.sum {locomotora => locomotora.peso()}
	}
}

class Locomotora {
	const property velocidadMaxima 
	const property arrastreMaximo 
	const property peso
	
	method esEficiente() {
		return arrastreMaximo >= 5 * peso
	}
	
	method arrestreUtil() {
		return arrastreMaximo - peso
	}
	
	method puedeArrastrar(unaFormacion) {
		return self.arrestreUtil() >= unaFormacion.kilosDeEmpujeFaltante()
	}
}

class VagonCarga {
	const cargaMaxima
	
	method cantidadPasajeros() {
		return 0
	}
	
	method esLiviano() {
		return self.pesoMaximo() < 2500
	}
	
	method pesoMaximo() {
		return cargaMaxima + 160
	}
}

class VagonPasajeros {
	const anchoUtil
	const largo
	
	method cantidadPasajeros() {
		return if(anchoUtil <= 2.5){
			largo * 8
		}else{
			largo * 10
		}
	}
	
	method esLiviano() {
		return self.pesoMaximo() < 2500
	}
	
	method pesoMaximo() {
		return self.cantidadPasajeros() * 80
	}
}

class Deposito {
	const property formaciones = []
	const property locomotoras = []
	
	// punto10
	method vagonesMasPesados() {
		return formaciones.map {formacion => formacion.vagonMasPesado()}
	}
	
	// punto11
	method necesitaConductorExperimentado() {
		return formaciones.any {formacion => formacion.esCompleja()}
	}
	
	// punto12
	method agregarLocomotoraA(unaFormacion) {
		const locomotora = locomotoras.find {locomotora => locomotora.puedeArrastrar(unaFormacion)}
		locomotoras.remove(locomotora)
		unaFormacion.agregarLocomotora(locomotora)
	}
}
