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
    return (abs(string - Medidas.numStrings), fret - 1)
}


// Suma de CGPoint
func + (left: CGPoint, right: CGPoint) -> CGPoint {
    return CGPoint(x: left.x + right.x, y: left.y + right.y)
}

func += (left: inout CGPoint, right: CGPoint) {
    left = left + right
}

