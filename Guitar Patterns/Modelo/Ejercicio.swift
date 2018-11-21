//
//  Ejercicio.swift
//  Guitar Patterns
//
//  Created by Alberto Banet Masa on 07/11/2018.
//  Copyright © 2018 Alberto Banet Masa. All rights reserved.
//

import Foundation
import SpriteKit



/**
  Indica el tipo de acción a realizar sobre el mástil.
  Las acciones pueden ser:
  - mostrarNota(String, TipoPosicionCuerda, TipoPosicionTraste)
  dibuja la nota indicada en la cuerda y trastes indicados.
  - mostrarIntervalo (Intervalo)
  Dibuja el intervalo pasado como parámetro
  - mostrarFlecha
  Dibuja una flecha
 */
enum TipoAccion {
  case mostrarNota (String, TipoPosicionCuerda, TipoPosicionTraste)
  case mostrarIntervalo (Intervalo, String, String)
  case mostrarFlecha
}

/**
 Define un paso a realizar. Es un par que indica la descripción del paso que se realiza y el tipo de acción asociada.
*/
typealias TipoPaso = (String, TipoAccion)

// Un examen indica cómo generar las notas de comienzo del examen
class Examen {
    var posiblesCuerdas: [TipoPosicionCuerda] // posibles cuerdas para la nota origen
    var posiblesTrastes: [TipoPosicionTraste] // posibles cuerdas para la nota final
    var tiempoLimite: TimeInterval            // tiempo límite para hacer el examen en segundos
    var veces: Int                            // las iteraciones que va a tener el examen
    
    init(cuerdas: [TipoPosicionCuerda], trastes: [TipoPosicionTraste], maxTiempo: TimeInterval, veces: Int) {
        self.posiblesCuerdas = cuerdas
        self.posiblesTrastes = trastes
        self.tiempoLimite = maxTiempo
        self.veces = veces
    }
    
    func elegirNotaComienzo() -> PosicionTraste {
        let numPosiblesCuerdas = self.posiblesCuerdas.count
        let numPosiblesTrastes = self.posiblesTrastes.count
        let posCuerda = Int.random(in: 0..<numPosiblesCuerdas)
        let posTraste = Int.random(in: 0..<numPosiblesTrastes)
        return PosicionTraste(cuerda: posiblesCuerdas[posCuerda], traste: posiblesTrastes[posTraste])
    }
}

class Ejercicio {
  var nombre: String?
  var instrucciones: String?
  var nivel: TipoNivel?
  var enunciado: String?
  var ejercicio: Intervalo? // de momento vamos a probar con ejercicios de intervalo
  var repeticiones: Int?
  var pasos: [TipoPaso]?
  var examen: Examen!
  
  
    init() {
       
    }
    
    init(instrucciones: String, enunciado: String, ejercicio: Intervalo, cuerda: TipoPosicionCuerda, traste: TipoPosicionTraste) {
    self.instrucciones = instrucciones
    self.enunciado = enunciado
    self.ejercicio = ejercicio
    
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
    let intervalos = armonia.intervalos[TipoIntervalo.octavajusta]!
    ejercicio1.ejercicio = intervalos[0]
    ejercicio1.ejercicio?.origen.cuerda = 6
    ejercicio1.ejercicio?.origen.traste = 2
    ejercicio1.pasos = [TipoPaso]()
    ejercicio1.pasos = [
      ("Encontrarás la octava desplazandote dos trastes hacia la derecha y bajando dos cuerdas.", .mostrarIntervalo(ejercicio1.ejercicio!, "T", "T"))
    ]
    let trastesPosibles = Array(1...Medidas.numTrastes-2)
    ejercicio1.examen = Examen(cuerdas: [6], trastes: trastesPosibles, maxTiempo: 5.0, veces: 5)
    ejercicios.append(ejercicio1)
  }
  
}




