//
//  Medidas.swift
//  Guitar Patterns
//
//  Created by Alberto Banet Masa on 05/11/2018.
//  Copyright © 2018 Alberto Banet Masa. All rights reserved.
//

import Foundation
import CoreGraphics
import SpriteKit

struct Medidas {
    static let topSpace: CGFloat = 50.0 // espacio reservado para la comunicación
    static let bottomSpace: CGFloat = 50.0 // aire en la parte inferior
    static let marginSpace: CGFloat = 50.0 // aire a los lados
    
    // Strings
    static let numStrings = 6 // guitarra
    static let numTrastes = 7
    static let widthString: CGFloat = 3
    
}

struct Colores {
    static let strings = SKColor.black
    static let noteStroke = SKColor.black
    static let noteFill = SKColor.white
    static let background = SKColor.lightGray
}
