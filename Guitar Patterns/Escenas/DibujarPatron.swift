//
//  DibujarPatron.swift
//  Guitar Patterns
//
//  Created by Alberto Banet Masa on 19/11/2018.
//  Copyright © 2018 Alberto Banet Masa. All rights reserved.
//

import SpriteKit

class DibujarPatron: SKScene {
    var guitarra: GuitarraGrafica!  // parte gráfica del mástil
    var patron  : Patron = PatronesDdbb().escalas[0] // el único q tenemos por ahora

    // MARK: Ciclo de vida de la escena
    override func didMove(to view: SKView) {
        iniciarGuitarra()
        dibujarPatron()
    }
    
    func iniciarGuitarra() {
        backgroundColor = Colores.background
        guitarra = GuitarraGrafica(size: size)
        addChild(guitarra)
    }
    
    
    func dibujarPatron(){
        for posicion in patron.posiciones {
            //marcarNotaEnTraste(pos: posicion)
            marcarNotasConIntervalo(pos: posicion)
        }
    }
    
    func marcarNotaEnTraste(pos: PosicionTraste) {
        guitarra.enumerateChildNodes(withName: "nota") { nodoNota , _ in
            if let shapeNota = nodoNota as? ShapeNote {
                if shapeNota.posicionEnMastil == pos {
                    shapeNota.setSelected(true)
                }
            }
        }
    }
    
    func marcarNotasConIntervalo(pos: PosicionTraste) {
        guitarra.enumerateChildNodes(withName: "nota") { nodoNota , _ in
            if let shapeNota = nodoNota as? ShapeNote {
                if shapeNota.posicionEnMastil == pos {
                    shapeNota.setSelected(true)
                    let tonica = self.patron.getPosTonica()
                    if let intervalo = tonica.intervaloHasta(posicion: pos) {
                        shapeNota.setTextShapeNote(intervalo.rawValue)
                    }
                }
            }
        }
    }
    
}
