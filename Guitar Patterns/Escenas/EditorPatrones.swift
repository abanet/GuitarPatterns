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
    var patron  : Patron = Patron()
    var existeTonica: Bool = false  // Se ha elegido ya una tónica o no
    
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
            if let mynode = node as? ShapeNote, node.name == "nota" {
                switch mynode.tipoShapeNote {
                case .unselected:
                    mynode.setTipoShapeNote(.selected)
                    patron.addPosicion(mynode.posicionEnMastil)
                    if existeTonica { // podemos poner el intervalo
                        let origen = patron.getPosTonica()
                        if let intervalo = origen.intervaloHasta(posicion: mynode.posicionEnMastil, intervalica: patron.intervalica) {
                            mynode.setTextShapeNote(intervalo.rawValue)
                        }
                    }
                case .selected:
                    // si no existe tónica se convierte en tónica
                    if !existeTonica {
                        patron.setPosTonica(mynode.posicionEnMastil)
                        mynode.setTipoShapeNote(.tonica)
                        existeTonica = true
                    } else {
                        mynode.setTipoShapeNote(.unselected)
                        patron.removePosicion(mynode.posicionEnMastil)
                    }
                case .tonica:
                    mynode.setTipoShapeNote(.unselected)
                    patron.removePosicion(mynode.posicionEnMastil)
                    existeTonica = false
                }
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
