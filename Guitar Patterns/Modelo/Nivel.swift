//
//  Nivel.swift
//  Guitar Patterns
//
//  Created by Alberto Banet Masa on 21/11/2018.
//  Copyright © 2018 Alberto Banet Masa. All rights reserved.
//

import Foundation

/**
 * Define un nivel de dificultad
 *
 * La dificultad del juego se basa diferentes parámetros:
 * - fácil: las notas o intervalos aparecen escritas en el patrón
 * - medio: las notas o intervalos aparecen coloreados pero sin texto
 * - alto : sólo aparecen las tónicas
 * - muy alto: sólo aparece una tónica
 *
 * Además en cada uno de estos tipos la dificultad se ve también afectada por:
 * - la velocidad de desplazamiento de las notas
 * - número de vidas (o bolas que dejamos explotar)
 * - tiempo que tenemos que aguantar en el nivel
 */

enum TipoNivel: Int {
    case bajo = 0, medio, alto
}


class Nivel {
    var tipo: TipoNivel
    var tiempoRecorrerPantalla: TimeInterval
    var tiempoJuego: TimeInterval // 0 para tiempo infinito
    
    init(tipo: TipoNivel, tiempoPantalla: TimeInterval, tiempoJuego: TimeInterval) {
        self.tipo = tipo
        self.tiempoRecorrerPantalla = tiempoPantalla
        self.tiempoJuego = tiempoJuego
    }
    
    convenience init(tipo: TipoNivel, tiempoPantalla: TimeInterval) {
        self.init(tipo: tipo, tiempoPantalla: tiempoPantalla, tiempoJuego: 0)
    }
    
    
    
    // Algunos niveles para probar
    class func getNivel(_ dificultad: Int) -> Nivel {
        var nivel: Nivel
        switch dificultad {
        case 1:
            nivel = Nivel(tipo: .bajo, tiempoPantalla: 40, tiempoJuego: 20)
        case 2:
            nivel = Nivel(tipo: .medio, tiempoPantalla: 30, tiempoJuego: 20)
        case 3:
            nivel = Nivel(tipo: .alto, tiempoPantalla: 30, tiempoJuego: 20)
        default:
            nivel = Nivel(tipo: .bajo, tiempoPantalla: 40, tiempoJuego: 0)
        }
        return nivel
    }
    
}
