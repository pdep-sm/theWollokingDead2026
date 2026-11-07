# Código en el aula

## Puntos 1.a y 1.b
```Wollok
class Tirador inherits Superviviente {
  const cantidadArmas
  method bajasPorMin() = cantidadArmas * 10
  method balasPorMin() = self.bajasPorMin()
}

class Recolector inherits Superviviente {
  const armas = []
  method bajasPorMin() = self.armaMasEficaz().bajasPorMin()
  method armaMasEficaz() = armas.max{ a => a.bajasPorMin() }
  method balasPorMin() = 0
}

class Principiante inherits Superviviente {
  var balasPorWolloker = 5

  method bajasPorMin() = self.balasPorMin() / balasPorWolloker
  method balasPorMin() = 20
}

class ArmaBlanca {
  const property bajasPorMin
}
```

## Puntos 2.a.i y 2.a.ii
```Wollok
class Refugio {
  const sobrevivientes = []
  method bajasPorMin() = sobrevivientes.sum{ s => s.bajasPorMin() }
  method balasPorMin() = sobrevivientes.sum{ s => s.balasPorMin() }
}
```

## Punto 2.b
```Wollok
class Horda {
  const cantidadWollokers
  const property duracionAtaque
  method wollokersPorMin() = cantidadWollokers / duracionAtaque
}
```

## Punto 3.a
```Wollok
class Refugio {
  var balas
  method puedeSoportar(horda) = 
    self.puedeManejar(horda) and self.balasSuficientes(horda)
  method puedeManejar(horda) = self.bajasPorMin() >= horda.wollokersPorMin()
  method balasSuficientes(horda) = self.balasPorAtaque(horda) <= balas
  method balasPorAtaque(horda) = self.balasPorMin() * horda.duracionAtaque()
  method actualizarBalas(cantidad) { balas += cantidad }
}
```

## Punto 3.b
```Wollok
class Refugio {
  method recibirAtaque(horda) {
    if (self.puedeSoportar(horda)) {
      self.actualizarBalas(-self.balasPorAtaque(horda))
      self.mejorarSupervivientes()
    } else {
      self.perderSupervivientes(horda.duracionAtaque())
    }
    self.consumirComida(2)
  }
  method mejorarSupervivientes() {
    sobrevivientes.forEach{ s => s.mejorar() }
  }
}

class Superviviente {
  method mejorar() { }
}

class Principiante inherits Superviviente {
  override method mejorar() { 
    balasPorWolloker = 2.max(balasPorWolloker - 1)
  }
}

class Refugio {
  var raciones
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
    raciones -= 
      self.cantidadNecesitaAlimentar() * self.consumoTotalPorPersona(dias)
  }
  method consumoTotalPorPersona(dias) = sobreviviente.consumo() * dias
}

object sobreviviente {
  var property consumo = 3
}
```

# Código agregado para los puntos que nos faltaron

## Punto 4
```Wollok
class Refugio {
  method realizarExpedicion(expedicion) {
    expedicion.serRealizadaPor(self)
  }
}

class Despensa { // es una expedición
  const raciones
  const sobrevivientes = []
  method serRealizadaPor(refugio) {
    refugio.recolectarRaciones(raciones)
    refugio.agregarSobrevivientes(sobrevivientes)
  }
}

object armeria { // es una expedición
  const balas = 20
  method serRealizadaPor(refugio) {
    refugio.recolectarBalas(balas)
  }
}

class Wollokmart { // es una expedición
  const cantidadProvisiones
  method serRealizadaPor(refugio) {
    refugio.recolectarRaciones(cantidadProvisiones)
    refugio.recolectarBalas(cantidadProvisiones)
  }
}

class Refugio {
  method recolectarRaciones(posiblesRaciones) {
    self.sumarRaciones(self.provisionesQueRecolecta(posiblesRaciones))
  }
  method recolectarBalas(posiblesBalas) {
    self.sumarBalas(self.provisionesQueRecolecta(posiblesBalas))
  }
  method provisionesQueRecolecta(cantidadBase) =
    sobrevivientes.sum{s => s.provisionesQueRecolecta(cantidadBase)}
  method sumarBalas(cantidad) {
    self.actualizarBalas(cantidad)
  }
  method sumarRaciones(cantidad) {
    raciones += cantidad
  }
}

class Superviviente { 
  // Debería ser lo normal, más allá de que haya sólo 1 clase que lo haga de esta forma
  method provisionesQueRecolecta(cantidadBase) = cantidadBase 
}

class Recolector inherits Superviviente {
  override method provisionesQueRecolecta(cantidadBase) = 
    super(cantidadBase) * 1.4
}

class Principiante inherits Superviviente {
  override method provisionesQueRecolecta(cantidadBase) = 
    super(cantidadBase) * 0.8
}

class Refugio {
  method agregarSobrevivientes(nuevosSobrevivientes) {
    sobrevivientes.addAll(nuevosSobrevivientes)
  }
}
```

## Punto 5
```Wollok
class Refugio {
  method robarRefugio(otroRefugio) {
    if(self.bajasPorMin() <= otroRefugio.bajasPorMin()) {
      throw new RoboException(
        message = "Las bajas por minuto no fueron suficientes")
    }
    else { otroRefugio.serRobadoPor(self) }
  }

  method serRobadoPor(otroRefugio) {
    otroRefugio.sumarProvisiones(balas, raciones)
    balas = 0
    raciones = 0
  }

  method sumarProvisiones(balasAgregadas, racionesAgregadas){
    self.sumarBalas(balasAgregadas)
    self.sumarRaciones(racionesAgregadas)
  }
}

class RoboException inherits DomainException {}
```