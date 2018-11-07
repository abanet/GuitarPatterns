//
//  GameScene.swift
//  Guitar Patterns
//
//  Created by Alberto Banet Masa on 05/11/2018.
//  Copyright © 2018 Alberto Banet Masa. All rights reserved.
//

import SpriteKit
import GameplayKit


class GameScene: SKScene {
    var guitarra: GuitarraGrafica!  // parte gráfica del mástil
    var mastil: Mastil!             // parte lógica del mástil
    
   
    override func didMove(to view: SKView) {
        backgroundColor = Colores.background
        iniciarGuitarra()
        dibujarMastil()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let touchPosition = touch.location(in: self)
        let touchedNodes = nodes(at: touchPosition)
        for node in touchedNodes {
            if let mynode = node as? SKShapeNode, node.name == "circle" {
                mynode.fillColor = .orange
            }
        }
        
    }
    
    
    func iniciarGuitarra() {
        guitarra = GuitarraGrafica(size: size)
        mastil   = Mastil()
        addChild(guitarra)
    }
    
    func dibujarMastil() {
        for x in 0..<Medidas.numStrings {
            for y in 0..<Medidas.numTrastes {
                switch mastil.trastes[x][y] {
                case .vacio:
                    guitarra.drawNoteAt(point: guitarra.matrizPositionNotes[x][y])
                case let .nota(n):
                    guitarra.drawNoteAt(point: guitarra.matrizPositionNotes[x][y], withText: n)
                default:
                    break
                }
                
            }
        }
    }
  
}
