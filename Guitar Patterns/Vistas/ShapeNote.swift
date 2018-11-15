//
//  ShapeNote.swift
//  Guitar Patterns
//
//  Created by Alberto Banet Masa on 13/11/2018.
//  Copyright © 2018 Alberto Banet Masa. All rights reserved.
//

import Foundation
import SpriteKit

class ShapeNote: SKShapeNode
{
    var posicionEnMastil: PosicionTraste = PosicionTraste(cuerda: 0, traste: 0)
  
    private(set) var selected: Bool = false {
        didSet {
            fillColor = selected ? Colores.noteFillResaltada : Colores.noteFill
        }
    }
    
    func setSelected(_ valor: Bool) {
        selected = valor
    }
}
