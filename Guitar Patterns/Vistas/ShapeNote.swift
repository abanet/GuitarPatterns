//
//  ShapeNote.swift
//  Guitar Patterns
//
//  Created by Alberto Banet Masa on 13/11/2018.
//  Copyright © 2018 Alberto Banet Masa. All rights reserved.
//

import Foundation
import SpriteKit

enum TipoShapeNote {
    case unselected
    case selected
    case tonica
}


class ShapeNote: SKShapeNode
{
    var posicionEnMastil: PosicionTraste = PosicionTraste(cuerda: 0, traste: 0)
    
    private(set) var selected: Bool = false {
        didSet {
            fillColor = selected ? Colores.noteFillResaltada : Colores.noteFill
        }
    }
    
    var esTonica: Bool = false
    
    private(set) var tipoShapeNote: TipoShapeNote = .unselected {
        didSet {
            switch tipoShapeNote {
            case .unselected:
                fillColor = Colores.noteFill
                setTextShapeNote("")
                esTonica = false
            case .selected:
                fillColor = Colores.noteFillResaltada
                setTextShapeNote("")
                esTonica = false
            case .tonica:
                fillColor = Colores.noteFillResaltada
                setTextShapeNote("T")
                esTonica = true
            }
        }
    }
    
    func setSelected(_ valor: Bool) {
        selected = valor
    }
    
    func setTipoShapeNote(_ valor: TipoShapeNote) {
        tipoShapeNote = valor
    }
    
    func setTextShapeNote(_ text: String) {
        for child in self.children {
            if let nodoTexto = child as? SKLabelNode {
                nodoTexto.text = text
            }
        }
    }
    
    
}
