//
//  EditorPatrones.swift
//  Guitar Patterns
//
//  Created by Alberto Banet Masa on 15/11/2018.
//  Copyright © 2018 Alberto Banet Masa. All rights reserved.
//

import SpriteKit


class EditorPatrones: SKScene {
    var guitarra: GuitarraGrafica!  // parte gráfica del mástil
    
    // MARK: Ciclo de vida de la escena
    override func didMove(to view: SKView) {
        iniciarGuitarra()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {
            return
        }
        let touchPosition = touch.location(in: self)
        let touchedNodes = nodes(at: touchPosition)
        for node in touchedNodes {
            if let mynode = node as? ShapeNote, node.name == "circle" {
                mynode.setSelected(!mynode.selected)
                //mynode.fillColor = Colores.noteFillResaltada
            }
        }
    }
    
    func iniciarGuitarra() {
        backgroundColor = Colores.background
        guitarra = GuitarraGrafica(size: size)
        addChild(guitarra)
    }
}
