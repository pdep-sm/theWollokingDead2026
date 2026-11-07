class Superviviente {
  method mejorar() { }
  method provisionesQueRecolecta(cantidadBase) = cantidadBase
}

class Tirador inherits Superviviente {
  const cantidadArmas

  method bajasPorMin() = cantidadArmas * 10
  method balasPorMin() = self.bajasPorMin()
}

class Recolector inherits Superviviente {
  const armas = []

  method bajasPorMin() = self.armaMasEficaz().bajasPorMin()
  method armaMasEficaz() = armas.max { arma => arma.bajasPorMin() }
  method balasPorMin() = 0
  override method provisionesQueRecolecta(cantidadBase) = super(cantidadBase) * 1.4
}

class Principiante inherits Superviviente {
  var balasPorWolloker = 5

  method bajasPorMin() = self.balasPorMin() / balasPorWolloker
  method balasPorMin() = 20
  override method provisionesQueRecolecta(cantidadBase) = super(cantidadBase) * 0.8

  override method mejorar() {
    balasPorWolloker = 2.max(balasPorWolloker - 1)
  }
}

object sobreviviente {
  var property consumo = 3
}
