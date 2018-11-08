//
//  Guitarra.swift
//  Guitar Patterns
//
//  Created by Alberto Banet Masa on 06/11/2018.
//  Copyright © 2018 Alberto Banet Masa. All rights reserved.
//

import Foundation
import CoreGraphics
import SpriteKit

class GuitarraGrafica: SKNode {
    
    var size: CGSize
    var anchoTraste: CGFloat  { // ancho de los trastes
        get {
            return (size.width - Medidas.marginSpace * 2) / CGFloat(Medidas.numTrastes)
        }
    }
    
    var radius: CGFloat { // radio de la nota
        get {
            //return anchoTraste / 4.0
            return spaceBetweenStrings / 2.4
        }
    }
    
    var spaceBetweenStrings: CGFloat {
        get {
            return (size.height - Medidas.topSpace - Medidas.bottomSpace) / CGFloat(Medidas.numStrings)
        }
    }
    
    lazy var arrayPositionFrets:[CGFloat] = {    // posiciones de los trastes
        var positions = [CGFloat]()
        var positionTraste = Medidas.marginSpace
        for _ in 1...Medidas.numTrastes {
            positions.append(positionTraste)
            positionTraste += anchoTraste
        }
        positions.append(positionTraste)
        return positions
    }()
    
    var arrayPositionStrings:[CGFloat] = [CGFloat]() // posiciones de las cuerdas
    var matrizPositionNotes:[[CGPoint]] = [[CGPoint]]()
    
    init(size:CGSize) {
        self.size = size
        super.init()
        drawGuitar()
        calculateMatrizPositionNotes()
        //drawAllNotes()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func drawGuitar() {
        drawNeck()
        drawFrets()
    }
    
    func drawAllNotes() {
        for n in 0..<Medidas.numStrings {
            for m in 0..<Medidas.numTrastes {
                drawNoteAt(point: matrizPositionNotes[n][m])
            }
        }
    }
    
    func drawNoteAt(point: CGPoint) {
        addChild(drawCircleAt(point: point, withRadius: radius))
    }
    
    func drawNoteAt(point: CGPoint, withText text: String) {
        let nodeNote = drawCircleAt(point: point, withRadius: radius)
        //let textLabel = SKLabelNode(fontNamed: "AvenirNext-Bold")
        let textLabel = SKLabelNode(fontNamed: "AvenirNext-Regular")
        textLabel.text = text
        // TODO: bajar el factor de corrección a 1 si van dos caracteres para bemoles y sostenidos
        textLabel.fontSize = radius * 1.2 //factor de corrección de tamaño aplicado
        textLabel.verticalAlignmentMode = .center
        textLabel.horizontalAlignmentMode = .center
        textLabel.position = point
      textLabel.alpha = 0
      nodeNote.alpha = 0
        addChild(textLabel)
        addChild(nodeNote)
      let action = SKAction.fadeAlpha(to: 1.0, duration: 2.0)
      textLabel.run(action)
      nodeNote.run(action)
    }
    
    func calculateMatrizPositionNotes () {
        for posString in arrayPositionStrings {
            var positionsOneString = [CGPoint]()
            for posFret in arrayPositionFrets {
                let posX = posFret + anchoTraste / 2
                let posY = posString
                positionsOneString.append(CGPoint(x: posX, y: posY))
            }
            matrizPositionNotes.append(positionsOneString)
        }
    }
    
    func drawNeck() {
        var positionString = Medidas.bottomSpace
        for _ in 1...Medidas.numStrings {
            arrayPositionStrings.append(positionString)
            addChild(drawLine(from: CGPoint(x: 0, y: positionString), to: CGPoint(x: size.width, y: positionString)))
            positionString += spaceBetweenStrings
        }
    }
    
    // Dibuja los trastes
    func drawFrets() {
        let posOrigenY = arrayPositionStrings[0]
        let posFinalY  = arrayPositionStrings[Medidas.numStrings - 1]
        for n in arrayPositionFrets {
            let puntoOrigen = CGPoint(x: n, y: posOrigenY)
            let puntoFinal  = CGPoint(x: n, y: posFinalY)
            addChild(drawLine(from: puntoOrigen, to: puntoFinal))
        }
    }
    
    func drawLine(from: CGPoint, to: CGPoint) -> SKShapeNode {
        let line = SKShapeNode()
        let path = CGMutablePath()
        path.addLines(between: [from, to])
        line.path = path
        line.strokeColor = Colores.strings
        line.lineWidth = Medidas.widthString
        return line
    }
    
    func drawCircleAt(point: CGPoint, withRadius radius: CGFloat) -> SKShapeNode {
        let path = CGMutablePath()
        path.addArc(center: point, radius: radius, startAngle: 0, endAngle: CGFloat.pi * 2, clockwise: true)
        let circle = SKShapeNode(path: path)
        circle.isUserInteractionEnabled = false
        circle.name = "circle"
        circle.lineWidth = 1
        circle.fillColor = Colores.background
        circle.strokeColor = Colores.noteStroke
        circle.glowWidth = 0.5
        return circle
    }
  
  // Dibuja una flecha
  func drawArrow(from start: CGPoint, to end: CGPoint, tailWidth: CGFloat, headWidth: CGFloat, headLength: CGFloat) -> SKShapeNode {
      let length = hypot(end.x - start.x, end.y - start.y)
      let tailLength = length - headLength
      
      func p(_ x: CGFloat, _ y: CGFloat) -> CGPoint { return CGPoint(x: x, y: y) }
      let points: [CGPoint] = [
        p(0, tailWidth / 2),
        p(tailLength, tailWidth / 2),
        p(tailLength, headWidth / 2),
        p(length, 0),
        p(tailLength, -headWidth / 2),
        p(tailLength, -tailWidth / 2),
        p(0, -tailWidth / 2)
      ]
      
      let cosine = (end.x - start.x) / length
      let sine = (end.y - start.y) / length
      let transform = CGAffineTransform(a: cosine, b: sine, c: -sine, d: cosine, tx: start.x, ty: start.y)
      
      let path = CGMutablePath()
      path.addLines(between: points, transform: transform)
      path.closeSubpath()
  
    let arrow = SKShapeNode(path: path)
    arrow.fillColor = .white
    return arrow
  }
}
