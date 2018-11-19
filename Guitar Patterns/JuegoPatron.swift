//
//  JuegoPatron.swift
//  Guitar Patterns
//
//  Created by Alberto Banet Masa on 19/11/2018.
//  Copyright © 2018 Alberto Banet Masa. All rights reserved.
//

import SpriteKit

class JuegoPatron: SKScene {
    var guitarra: GuitarraGrafica!  // parte gráfica del mástil
    var patron  : Patron = PatronesDdbb().escalas[0] // el único q tenemos por ahora
    
    var tiempoLimite: Int = 20 // tiempo límite para terminar el nivel
    var velocidadInicial: CGFloat  = 2.0 // velocidad inicial de desplazamiento
    
    var radius: CGFloat { // radio de la nota en el corredor
        get {
            //return anchoTraste / 4.0
            return (Medidas.topSpace) / 2
        }
    }
    
    // MARK: Ciclo de vida de la escena
    override func didMove(to view: SKView) {
        iniciarGuitarra()
        dibujarPatron()
        let punto =  CGPoint(x: size.width - Medidas.marginSpace, y: (size.height - Medidas.topSpace / 1.5) )
        let node = self.drawCircleAt(point: punto, withRadius: radius)
        node.zPosition = 200
        self.addChild(node)
    }
    
    override func update(_ currentTime: TimeInterval) {
        // desplazar nota hacia la izquierda a una velocidad constante q irá en aumento.
        enumerateChildNodes(withName: "circle") { (node, _ ) in
            if let nodo = node as? SKShapeNode {
                nodo.position.x -= self.velocidadInicial
            }
        }
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
    
    
    // MARK: corredor de notas
    
    
    func drawCircleAt(point: CGPoint, withRadius radius: CGFloat, withEstilo estilo: EstiloNota = EstilosDefault.notas) -> SKShapeNode {
        let path = CGMutablePath()
        path.addArc(center: point, radius: radius, startAngle: 0, endAngle: CGFloat.pi * 2, clockwise: true)
        let circle = SKShapeNode(path: path)
        circle.isUserInteractionEnabled = false
        circle.name = "circle"
        circle.lineWidth = estilo.anchoLinea
        circle.fillColor = estilo.colorRelleno
        circle.strokeColor = estilo.colorTrazo
        circle.glowWidth = 0.5
        return circle
    }
    
}
