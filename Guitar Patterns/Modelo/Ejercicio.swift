//
//  Ejercicio.swift
//  Guitar Patterns
//
//  Created by Alberto Banet Masa on 07/11/2018.
//  Copyright © 2018 Alberto Banet Masa. All rights reserved.
//

import Foundation
import SpriteKit

enum TipoNivel: Int {
  case bajo = 0, medio, alto
}

enum TipoAccion {
  case mostraNota (String, TipoPosicionCuerda, TipoPosicionTraste)
  case mostrarIntervalo (Intervalo)
  case mostrarFlecha
}

typealias TipoPaso = (String, TipoAccion)
class Ejercicio {
  var nombre: String?
  var instrucciones: String?
  var nivel: TipoNivel?
  var enunciado: String?
  var ejercicio: Intervalo? // de momento vamos a probar con ejercicios de intervalo
  var tiempoLimite: TimeInterval?
  var pasos: [TipoPaso]?
  
  init() {
    
  }
  
  init(instrucciones: String, enunciado: String, ejercicio: Intervalo) {
    self.instrucciones = instrucciones
    self.enunciado = enunciado
    self.ejercicio = ejercicio
    self.tiempoLimite = 20
  }
  
}

class DatabaseEjercicios {
  let armonia = Armonia()
  var ejercicios = [Ejercicio]()
  
  
  init() {
    let ejercicio1 = Ejercicio()
    ejercicio1.nombre = "Intervalos de Octava en 6 cuerda"
    ejercicio1.instrucciones = "Vas a aprender a situar la octava de una nota posicionada en la sexta cuerda"
    ejercicio1.nivel = .bajo
    ejercicio1.tiempoLimite = 5
    ejercicio1.ejercicio = armonia.intervalos[0] 
    ejercicio1.pasos = [
      ("Localiza la nota de la que quieres conocer la octava", .mostrarIntervalo(armonia.intervalos[0])),
      ("", .mostrarFlecha)
    ]
    ejercicios.append(ejercicio1)
  }
  
}




