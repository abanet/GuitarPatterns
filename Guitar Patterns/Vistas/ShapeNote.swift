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
    var cuerda: TipoPosicionCuerda?
    var traste: TipoPosicionTraste?
    
    init(cuerda: TipoPosicionCuerda, traste: TipoPosicionTraste) {
        self.cuerda = cuerda
        self.traste = traste
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
