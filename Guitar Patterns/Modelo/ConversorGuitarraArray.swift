//
//  ConversorGuitarraArray.swift
//  Guitar Patterns
//
//  Created by Alberto Banet Masa on 12/11/2018.
//  Copyright © 2018 Alberto Banet Masa. All rights reserved.
//

import Foundation
import CoreGraphics

// Dadas las coordenadas entendidas como guitarra las traduce a las usadas en el array
func coordinatesFromGuitarToArray(string: Int, fret: Int) -> (Int, Int) {
    guard string > 0, string <= Medidas.numStrings, fret > 0, fret <= Medidas.numTrastes else {
        return (0,0)
    }
    return (abs(string - Medidas.numStrings), fret - 1)
}

func coordinatesFromArrayToGuitar(x: Int, y: Int) -> PosicionTraste? {
    guard x >= 0, y >= 0, x < Medidas.numStrings, y < Medidas.numTrastes else {
        return nil
    }
    return PosicionTraste(cuerda: 6 - x , traste: y + 1)
}


// Suma de CGPoint
func + (left: CGPoint, right: CGPoint) -> CGPoint {
    return CGPoint(x: left.x + right.x, y: left.y + right.y)
}

func += (left: inout CGPoint, right: CGPoint) {
    left = left + right
}

