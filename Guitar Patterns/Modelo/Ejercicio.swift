//
//  Ejercicio.swift
//  Guitar Patterns
//
//  Created by Alberto Banet Masa on 07/11/2018.
//  Copyright © 2018 Alberto Banet Masa. All rights reserved.
//

import Foundation

class Ejercicio {
  var instrucciones: String
  var enunciado: String
  var ejercicio: Intervalo // de momento vamos a probar con ejercicios de intervalo
  var tiempoLimite: TimeInterval
  
  init(instrucciones: String, enunciado: String, ejercicio: Intervalo) {
    self.instrucciones = instrucciones
    self.enunciado = enunciado
    self.ejercicio = ejercicio
    self.tiempoLimite = 20
  }
  
}
