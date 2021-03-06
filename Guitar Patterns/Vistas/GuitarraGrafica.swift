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

struct EstiloNota {
    var colorRelleno: SKColor
    var colorTrazo: SKColor
    var anchoLinea: CGFloat
    
    init(relleno: SKColor, trazo: SKColor, anchoLinea: CGFloat) {
        self.colorRelleno = relleno
        self.colorTrazo = trazo
        self.anchoLinea = anchoLinea
    }
}

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
            //return (size.height - Medidas.topSpace - Medidas.bottomSpace) / CGFloat(Medidas.numStrings)
            return (size.height - Medidas.porcentajeTopSpace * size.height - Medidas.bottomSpace) / CGFloat(Medidas.numStrings)
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
    var matrizShapeNotes: [[ShapeNote]] = [[ShapeNote]]()
    
    init(size:CGSize) {
        self.size = size
        super.init()
        drawNeck()
        drawFrets()
        calculateMatrizPositionNotes()
        drawAllNotes()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    

    func desvanecerMastil(tiempo: TimeInterval, completion: @escaping ()->() ) {
        let actionReducirAlpha = SKAction.fadeAlpha(to: 0.5, duration: tiempo)
        let actionAumentarAlpha = SKAction.fadeAlpha(to: 1.0, duration: tiempo)
        
        // Difuminamos primero las notas falladas y después las acertadas
        enumerateChildNodes(withName: "notaFallada") { (nodo, _) in
            if let nodoNota = nodo as? ShapeNote {
                nodoNota.name = "nota"
                nodoNota.run(actionReducirAlpha) {
                    nodoNota.fillColor = Colores.background
                    nodoNota.run(actionAumentarAlpha)
                    
                }
            }
        }
        
        enumerateChildNodes(withName: "notaAcertada") { (nodo, _) in
            if let nodoNota = nodo as? ShapeNote {
                nodoNota.name = "nota"
                self.limpiarTextoEnNodo(nodoNota)
                nodoNota.run(actionReducirAlpha) {
                    nodoNota.fillColor = Colores.background
                    nodoNota.run(actionAumentarAlpha)
                    completion()
                }
            }
        }
       
    }
    
    /**
     Dibuja las dos notas del intervalo con una pausa intermedia.
     */
    func dibujarIntervalo(_ intervalo: Intervalo, notaOrigen: String, notaFinal: String, conPausa: TimeInterval) {
        let cuerda = intervalo.origen.cuerda
        let traste = intervalo.origen.traste
        
        // Calcular segunda nota
        if let nuevaNota = intervalo.origen.incrementar(intervalo.posiciones[0])
            {
                let nuevaCuerda = nuevaNota.cuerda
                let nuevoTraste = nuevaNota.traste
            let nota1 = createNodeNote(notaOrigen, inString: cuerda, atFret: traste, alpha: 0.0)
            let nota2 = createNodeNote(notaFinal, inString: nuevaCuerda, atFret: nuevoTraste, alpha: 0.0)
            nota1.fillColor = Colores.noteFillResaltada
            nota2.fillColor = Colores.noteFillResaltada
            
            let aparecer = SKAction.fadeAlpha(to: 1.0, duration: Pausas.aparicionNota)
            let desaparecer = SKAction.fadeAlpha(to: 0.0, duration: Pausas.aparicionNota)
            let actionWait  = SKAction.wait(forDuration: 1.0)
            
            if let camino = dibujarCaminoIntervalo(intervalo) {
                camino.alpha = 0
                addChild(nota1)
                addChild(nota2)
                addChild(camino)
                nota1.run(SKAction.sequence([aparecer, actionWait])) {
                    camino.run(SKAction.sequence([aparecer, actionWait, desaparecer]))
                    nota2.run(SKAction.sequence([aparecer, actionWait]))
                }
                
            }
        }
    }
    
    
    // MARK: Funciones de escritura con parámetros de guitarra
    // Aquí la posición pasada por parámetro se dará desde la perspectiva de la guitarra
    // Dibuja una nota de la que se indica la cuerda y el traste en el mástil de la guitarra
    func writeNote(_ note: String, inString string:Int, atFret fret: Int, timeToAppear: TimeInterval = Pausas.aparicionNota, fillColor: SKColor = Colores.noteFill, withName name: String = "nota") {
        drawShapeNoteAt(string: string, fret: fret, withText: note, timeToAppear: timeToAppear, fillColor: fillColor, withName: name)
    }
    
    func createNodeNote(_ note: String, inString string: Int, atFret fret: Int, alpha: CGFloat = 1.0) -> ShapeNote {
        let (x,y) = coordinatesFromGuitarToArray(string: string, fret: fret)
        let punto = matrizPositionNotes[x][y]
        return createNodeNoteAt(point: punto, withText: note, alpha: alpha)
    }
    
    
    // MARK: Funciones para dibujar notas
    
    // Dibujamos los círculos de posición pero sin notas asociadas.
    // Se establece como fondo permanente
    func drawAllNotes() {
        for n in 0..<Medidas.numStrings {
            for m in 0..<Medidas.numTrastes {
                //drawNoteAt(point: matrizPositionNotes[n][m])
                if let pos = coordinatesFromArrayToGuitar(x: n, y: m) {
                    drawShapeNoteVaciaAt(cuerda: pos.cuerda, traste: pos.traste)
                }
            }
        }
    }
    

    func drawShapeNoteVaciaAt(cuerda: TipoPosicionCuerda, traste: TipoPosicionTraste) {
//        let (x,y) = coordinatesFromGuitarToArray(string: cuerda, fret: traste)
//        let shapeNote = drawCircleAt(point: matrizPositionNotes[x][y], withRadius: radius)
//        shapeNote.posicionEnMastil.cuerda = cuerda
//        shapeNote.posicionEnMastil.traste = traste
//
//        addChild(shapeNote)
        drawShapeNoteAt(string: cuerda, fret: traste)
    }
  
    func drawShapeNoteAt(string: Int, fret: Int, withText text: String = "", withName name: String = "nota") {
        drawShapeNoteAt(string: string, fret: fret, withText: text, timeToAppear: 0.1, withName: name)
    }
    
    func drawShapeNoteAt(string: Int, fret: Int, withText text: String, alpha: CGFloat = 1.0, timeToAppear: TimeInterval = Pausas.aparicionNota, fillColor: SKColor = Colores.noteFill, withName name: String = "nota") {
        let (x,y) = coordinatesFromGuitarToArray(string: string, fret: fret)
        let punto = matrizPositionNotes[x][y]
        let node = createNodeNoteAt(point: punto, withText: text, fillColor: fillColor, withName: name)
        node.posicionEnMastil.cuerda = string
        node.posicionEnMastil.traste = fret
        let action = SKAction.fadeAlpha(to: alpha, duration: timeToAppear)
        addChild(node)
        node.run(action)
    }
    
    
    // Devuelve una ShapeNote en la posición indicada
    func returnShapeNoteAt(string: Int, fret: Int, withText text: String, alpha: CGFloat = 1.0,fillColor: SKColor = Colores.noteFill, withName name: String = "nota") -> ShapeNote {
        let (x,y) = coordinatesFromGuitarToArray(string: string, fret: fret)
        let punto = matrizPositionNotes[x][y]
        let node = createNodeNoteAt(point: punto, withText: text, fillColor: fillColor, withName: name)
        node.posicionEnMastil.cuerda = string
        node.posicionEnMastil.traste = fret
        return node
    }
    
    func drawNoteAt(point: CGPoint) {
        drawNoteAt(point: point, withText: "", alpha: 1.0, timeToAppear: 0.1, fillColor: Colores.background)
        //addChild(drawCircleAt(point: point, withRadius: radius))
    }
    
    // Dibuja la nota en el punto dado
    func drawNoteAt(point: CGPoint, withText text: String, alpha: CGFloat = 1.0, timeToAppear: TimeInterval = Pausas.aparicionNota, fillColor: SKColor = Colores.noteFill) {
        let node = createNodeNoteAt(point: point, withText: text, fillColor: fillColor)
        let action = SKAction.fadeAlpha(to: alpha, duration: timeToAppear)
        addChild(node)
        node.run(action)
    }
    
    // Devuelve un nodo con la nota requerida y el alpha indicado
    func createNodeNoteAt(point: CGPoint, withText text: String, alpha: CGFloat = 0.0, fillColor: SKColor = Colores.noteFill, withName name: String = "nota") -> ShapeNote {
        let nodeNote = drawCircleAt(point: .zero, withRadius: radius)
        nodeNote.fillColor = fillColor
        nodeNote.position = point
        //let textLabel = SKLabelNode(fontNamed: "AvenirNext-Bold")
        let textLabel = SKLabelNode(fontNamed: "AvenirNext-Regular")
        textLabel.text = text
        // TODO: bajar el factor de corrección a 1 si van dos caracteres para bemoles y sostenidos
        textLabel.fontSize = radius * 1.2 //factor de corrección de tamaño aplicado
        textLabel.verticalAlignmentMode = .center
        textLabel.horizontalAlignmentMode = .center
        textLabel.position = .zero
        textLabel.alpha = 1.0
        nodeNote.alpha = alpha
        nodeNote.addChild(textLabel)
        nodeNote.name = name
        return nodeNote
    }
    
    
    // MARK: funciones de limpieza de notos
    
    // Elimina todas las tónicas que aparecen en el mastil
    func limpiarTonicas() {
        for child in children {
            if let nodo = child as? ShapeNote {
                for nodo in nodo.children {
                if let nodoTexto = nodo as? SKLabelNode, nodoTexto.text == "T" {
                    nodoTexto.text = ""
                }
                }
            }
        }
    }
    
    func limpiarTextoEnNodo (_ nodo: ShapeNote) {
        for child in nodo.children {
            if let nodoTexto = child as? SKLabelNode {
                nodoTexto.text = ""
            }
        }
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
    
    // Dibujar círculos de posición pero sin ser nodos a tener en cuenta
    
    
    func dibujarCaminoIntervalo (_ intervalo: Intervalo) -> SKShapeNode? {
        let cuerda = intervalo.origen.cuerda
        let traste = intervalo.origen.traste
        // Calcular segunda nota
        if let nuevaNota = intervalo.origen.incrementar(intervalo.posiciones[0]) {
            let nuevaCuerda = nuevaNota.cuerda
            let nuevoTraste = nuevaNota.traste
            let (x1, y1) = coordinatesFromGuitarToArray(string: cuerda, fret: traste)
            let (x2, y2) = coordinatesFromGuitarToArray(string: nuevaCuerda, fret: nuevoTraste)
            let punto1 = matrizPositionNotes[x1][y1] + CGPoint(x: radius, y: 0)
            let punto2 = matrizPositionNotes[x1][y1] + CGPoint(x: matrizPositionNotes[x2][y2].x - matrizPositionNotes[x1][y1].x, y: 0)
            // desplazamiento vertical
            let punto3 = matrizPositionNotes[x2][y2] + CGPoint(x: 0, y: -radius)
            let line = SKShapeNode()
            let path = CGMutablePath()
            path.addLines(between: [punto1, punto2, punto3])
            line.path = path
            line.strokeColor = Colores.camino
            line.lineWidth = Medidas.anchoCamino
            line.name = "camino"
            return line
        } else {
            return nil
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
    
    func drawCircleAt(point: CGPoint, withRadius radius: CGFloat, withEstilo estilo: EstiloNota = EstilosDefault.notas) -> ShapeNote {
        let path = CGMutablePath()
        path.addArc(center: point, radius: radius, startAngle: 0, endAngle: CGFloat.pi * 2, clockwise: true)
        let circle = ShapeNote(path: path)
        circle.isUserInteractionEnabled = false
        circle.name = "circle"
        circle.lineWidth = estilo.anchoLinea
        circle.fillColor = estilo.colorRelleno
        circle.strokeColor = estilo.colorTrazo
        circle.glowWidth = 0.5
        return circle
    }
    
    // Dibuja una flecha
    func drawArrow(from start: CGPoint, to end: CGPoint, tailWidth: CGFloat = 1, headWidth: CGFloat = 10, headLength: CGFloat = 20, alpha: CGFloat = 1.0) -> SKShapeNode {
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
        arrow.name = "arrow"
        arrow.fillColor = .white
        arrow.alpha = alpha
        return arrow
    }
    
    // Elimina todos los nodos "nota" y "camino" que estén dibujados en pantalla
    func limpiarGuitarra() {
        for child in children {
            if child.name == "nota" || child.name == "camino" || child.name == "circle" {
                child.removeFromParent()
            }
        }
    }
}
