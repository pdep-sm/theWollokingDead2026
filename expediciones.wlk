class Despensa {
  const raciones
  const sobrevivientes = []

  method serRealizadaPor(refugio) {
    refugio.recolectarRaciones(raciones)
    refugio.agregarSobrevivientes(sobrevivientes)
  }
}

object armeria {
  const balas = 20

  method serRealizadaPor(refugio) {
    refugio.recolectarBalas(balas)
  }
}

class Wollokmart {
  const cantidadProvisiones

  method serRealizadaPor(refugio) {
    refugio.recolectarRaciones(cantidadProvisiones)
    refugio.recolectarBalas(cantidadProvisiones)
  }
}
