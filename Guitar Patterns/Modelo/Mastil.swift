//
//  Mastil.swift
//  Guitar Patterns
//
//  Created by Alberto Banet Masa on 06/11/2018.
//  Copyright © 2018 Alberto Banet Masa. All rights reserved.
//

import Foundation

enum traste {
    case vacio
    case blanco
    case nota(String)
    case relacion(Int) // igual no hace falta y los tratamos como notas
}

class Mastil {
    var trastes: [[traste]] = [[traste]]()
    
    init() {
        createEmptyMastil()
        let nota = traste.nota("C#")
        writeNote(note: nota, inString: 6, atFret: 2)
    }
    
    // Crea el array definitorio del mástil con todos los trastes vacios
    func createEmptyMastil() {
        for _ in 0..<Medidas.numStrings {
            var oneString = [traste]()
            for _ in 0..<Medidas.numTrastes {
                let unTraste = traste.vacio
                oneString.append(unTraste)
            }
            trastes.append(oneString)
        }
        trastes[5][3] = traste.vacio
    }
    
    // escribe una nota en la posición indicada
    // Aquí la posición pasada por parámetro se dará desde la perspectiva de la guitarra
    func writeNote(note: traste, inString string:Int, atFret fret: Int) {
        let (x,y) = coordinatesFromGuitarToArray(string: string, fret: fret)
        trastes[x][y] = note
    }
    
    // Dadas las coordenadas entendidas como guitarra las traduce a las usadas en el array
    func coordinatesFromGuitarToArray(string: Int, fret: Int) -> (Int, Int) {
        return (abs(string - Medidas.numStrings), fret - 1)
    }
    
}
