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
    static let porcentajeTopSpace: CGFloat = {
        switch UIDevice.current.userInterfaceIdiom {
        case .phone:
            return 0.20
        case .pad:
            return 0.30
        default:
            return 0.25
        }
    }()
    // Strings
    static let numStrings = 6 // guitarra
    static let numTrastes = 7
    static let widthString: CGFloat = 3.0
    
    // Flechas
    static let colaFlecha = 1
    static let cabezaFlecha = 10
    static let longitudCabezaFecha = 20
    
    // caminos
    static let anchoCamino: CGFloat = 6.0
    
}

struct Colores {
    static let strings = SKColor.black
    static let noteStroke = SKColor.black
    static let noteFill = SKColor.lightGray
    static let noteFillResaltada = SKColor.orange
    static let background = SKColor.lightGray
    static let indicaciones = SKColor.white
    static let camino = SKColor.yellow
    static let fallo = SKColor.darkGray
    static let tonica = SKColor.red
}

struct Pausas {
    static let aparicionNota: TimeInterval = 0.5
}

struct EstilosDefault {
    static let notas = EstiloNota(relleno: Colores.noteFill, trazo: Colores.noteStroke, anchoLinea: 1.0)
}
