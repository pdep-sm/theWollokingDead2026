import sobrevivientes.sobreviviente

class Refugio {
  const property sobrevivientes = []
  var property balas = 0
  var property raciones = 0

  method bajasPorMin() = sobrevivientes.sum { s => s.bajasPorMin() }
  method balasPorMin() = sobrevivientes.sum { s => s.balasPorMin() }

  method puedeSoportar(horda) =
    self.puedeManejar(horda) and self.balasSuficientes(horda)
  method puedeManejar(horda) = self.bajasPorMin() >= horda.wollokersPorMin()
  method balasSuficientes(horda) = self.balasPorAtaque(horda) <= balas
  method balasPorAtaque(horda) = self.balasPorMin() * horda.duracionAtaque()

  method recibirAtaque(horda) {
    if (self.puedeSoportar(horda)) {
      self.actualizarBalas(-self.balasPorAtaque(horda))
      self.mejorarSupervivientes()
    } else {
      self.perderSupervivientes(horda.duracionAtaque())
    }
    self.consumirComida(2)
  }

  method actualizarBalas(cantidad) {
    balas += cantidad
  }

  method mejorarSupervivientes() {
    sobrevivientes.forEach { s => s.mejorar() }
  }

  method perderSupervivientes(cantidad) {
    cantidad.max(0).min(sobrevivientes.size()).floor().times { _ =>
      sobrevivientes.remove(sobrevivientes.anyOne())
    }
  }

  method consumirComida(dias) {
    self.perderSupervivientes(self.muertosDeHambre(dias))
    self.consumirRaciones(dias)
  }

  method muertosDeHambre(dias) =
    0.max(self.cantidadNecesitaAlimentar() - self.cantidadPuedeAlimentar(dias))
  method cantidadPuedeAlimentar(dias) = raciones.div(self.consumoTotalPorPersona(dias))
  method cantidadNecesitaAlimentar() = sobrevivientes.size()
  method consumirRaciones(dias) {
    raciones -= self.cantidadNecesitaAlimentar() * self.consumoTotalPorPersona(dias)
  }
  method consumoTotalPorPersona(dias) = sobreviviente.consumo() * dias

  method realizarExpedicion(expedicion) {
    expedicion.serRealizadaPor(self)
  }

  method recolectarRaciones(posiblesRaciones) {
    self.sumarRaciones(self.provisionesQueRecolecta(posiblesRaciones))
  }

  method recolectarBalas(posiblesBalas) {
    self.sumarBalas(self.provisionesQueRecolecta(posiblesBalas))
  }

  method provisionesQueRecolecta(cantidadBase) =
    sobrevivientes.sum { s => s.provisionesQueRecolecta(cantidadBase) }

  method agregarSobrevivientes(nuevosSobrevivientes) {
    sobrevivientes.addAll(nuevosSobrevivientes)
  }

  method sumarBalas(cantidad) {
    self.actualizarBalas(cantidad)
  }

  method sumarRaciones(cantidad) {
    raciones += cantidad
  }

  method robarRefugio(otroRefugio) {
    if (self.bajasPorMin() <= otroRefugio.bajasPorMin()) {
      throw new RoboException(message = "Las bajas por minuto no fueron suficientes")
    }
    otroRefugio.serRobadoPor(self)
  }

  method serRobadoPor(otroRefugio) {
    otroRefugio.sumarProvisiones(balas, raciones)
    balas = 0
    raciones = 0
  }

  method sumarProvisiones(balasAgregadas, racionesAgregadas) {
    self.sumarBalas(balasAgregadas)
    self.sumarRaciones(racionesAgregadas)
  }
}

class RoboException inherits DomainException {}
