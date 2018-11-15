//
//  GameScene.swift
//  Guitar Patterns
//
//  Created by Alberto Banet Masa on 05/11/2018.
//  Copyright © 2018 Alberto Banet Masa. All rights reserved.
//

import SpriteKit
import GameplayKit

enum FasesJuego {
    case mostrandoInstrucciones
    case exponiendoEjercicio
    case esperandoUsuario
    case usuarioPulsaPantalla
    case jugando
    case preparandoExamen
    case proponiendoPregunta
    case esperandoRespuesta
    case preguntaRespondida
    case examenTerminado
}

class GameScene: SKScene {
    var armonia: Armonia!
    var guitarra: GuitarraGrafica!  // parte gráfica del mástil
    var mastil: Mastil!             // parte lógica del mástil
    let ddbb = DatabaseEjercicios()
    var ejercicio: Ejercicio!
    var siguientePaso = 0
    var posicionNotaPropuesta: PosicionTraste = PosicionTraste(cuerda: 6, traste: 2) // por defecto una posición válida
    
    var fase: FasesJuego = .preparandoExamen //.mostrandoInstrucciones
    
    var elapsedTime: Int = 0  // tiempo transcurrido
    var startTime: Int?         // tiempo en el que se comienza
    
    var existeTableroPuntuacion = false
    
    
    
    // Variables de mantenimiento de la puntuación
    let  labelQuedan: SKLabelNode = {
        let label = SKLabelNode(fontNamed: "AvenirNext-Regular")
        label.horizontalAlignmentMode = .left
        label.verticalAlignmentMode = .bottom
        label.fontSize = 25
        return label
    }()
    
    let labelAciertos: SKLabelNode = {
        let label = SKLabelNode(fontNamed: "AvenirNext-Regular")
        label.horizontalAlignmentMode = .left
        label.verticalAlignmentMode = .bottom
        label.fontSize = 25
        return label
    }()
    let labelFallos: SKLabelNode = {
        let label = SKLabelNode(fontNamed: "AvenirNext-Regular")
        label.horizontalAlignmentMode = .left
        label.verticalAlignmentMode = .bottom
        label.fontSize = 25
        return label
    }()
    let labelTiempo: SKLabelNode = {
        let label = SKLabelNode(fontNamed: "AvenirNext-Regular")
        label.horizontalAlignmentMode = .left
        label.verticalAlignmentMode = .bottom
        label.fontSize = 25
        return label
    }()
    
    var quedan: Int = 0 {
        didSet {
            labelQuedan.text = "Quedan: \(quedan)"
        }
    }
    var aciertos: Int = 0 {
        didSet {
            labelAciertos.text = "Aciertos: \(aciertos)"
        }
    }
    var fallos: Int = 0 {
        didSet {
            labelFallos.text = "Fallos: \(fallos)"
        }
    }
    
    override func didMove(to view: SKView) {
        backgroundColor = Colores.background
        iniciarGuitarra()
        dibujarMastil()
        armonia = Armonia()
        ejercicio = ddbb.ejercicios[0] // nuestro único ejercicio por ahora!
        
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Ciclo principal
        switch fase {
        case .mostrandoInstrucciones:
            view?.isUserInteractionEnabled = false
            // Mostrar instrucciones ejercicio. Wait
            dibujarTablonInstrucciones(ejercicio.instrucciones!, yPasarFase: .esperandoUsuario)
            
        case .exponiendoEjercicio:
            if let pasos = ejercicio.pasos {
                guard siguientePaso < pasos.count else { return }
                ejecutarPaso(pasos[siguientePaso])
                siguientePaso = siguientePaso + 1
                fase = .esperandoUsuario
            }
            
        case .esperandoUsuario:
            view?.isUserInteractionEnabled = true
            
        case .usuarioPulsaPantalla:
            if let pasos = ejercicio.pasos {
                let esUltimoPaso = siguientePaso == pasos.count
                if esUltimoPaso {
                    fase = .jugando
                } else {
                    fase = .exponiendoEjercicio
                    limpiarTextoIndicaciones()
                }
            }
            
        case .jugando:
            view?.isUserInteractionEnabled = false
            limpiarTextoIndicaciones()
            dibujarTablonInstrucciones("¡Es tu turno!", yPasarFase: .preparandoExamen)
            
        case .preparandoExamen:
            fase = .proponiendoPregunta
            limpiarMastil()
            if !existeTableroPuntuacion {
                crearTableroPuntuacion(conTiempo: ejercicio.examen.tiempoLimite, numVeces: ejercicio.examen.veces)
                self.quedan = ejercicio.examen.veces
                
            }
            
        case .proponiendoPregunta:
            // Proponer comienzo de ejercicio
            view?.isUserInteractionEnabled = false
            posicionNotaPropuesta = ejercicio.examen.elegirNotaComienzo()
            guitarra.writeNote("T", inString: posicionNotaPropuesta.cuerda, atFret: posicionNotaPropuesta.traste, timeToAppear: 0.1, fillColor: SKColor.orange, withName: "notaAcertada")
            fase = .esperandoRespuesta
            
            
            
        case .esperandoRespuesta:
            view?.isUserInteractionEnabled = true
            // Actualizamos tiempo restante
            updateTiempoPantalla(currentTime: currentTime)
            // Si el tiempo se ha terminado fin del ejercicio
            let tiempoLimite = Int(ejercicio.examen.tiempoLimite)
            if tiempoLimite - elapsedTime <= 0 {
                //fase = .examenTerminado
            }
            
        case .preguntaRespondida:
            view?.isUserInteractionEnabled = false
            guitarra.desvanecerMastil(tiempo: 0.5) {
                self.view?.isUserInteractionEnabled = true
                self.quedan = self.quedan - 1
                self.fase = .proponiendoPregunta
            }
            
        case .examenTerminado:
            break
        }
        
        
        
        // Realizar demo
        
        // Mostrar enunciado. Wait
        
        // Cuenta atrás para que usuario responda
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if fase != .esperandoUsuario {
            guard let touch = touches.first else { return }
            let touchPosition = touch.location(in: self)
            let touchedNodes = nodes(at: touchPosition)
            for node in touchedNodes {
                if let mynode = node as? ShapeNote, node.name == "nota" {
                    mynode.fillColor = .orange
                    // Comprobar si es una respuesta correcta
                    if fase == .esperandoRespuesta {
                        if esRespuestaCorrecta(mynode.posicionEnMastil) {
                            // actualizar marcador respuestas
                            mynode.fillColor = Colores.noteFillResaltada
                            mynode.name = "notaAcertada"
                            self.aciertos = self.aciertos + 1
                            fase = .preguntaRespondida
                        } else {
                            // actualizar marcador fallos
                            mynode.fillColor = Colores.fallo
                            mynode.name = "notaFallada"
                            self.fallos = self.fallos + 1
                        }
                    }
                }
            }
        } else{ // esperando que usuario pulse para seguir ejercicio
            fase = .usuarioPulsaPantalla
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
                    if let pos = coordinatesFromArrayToGuitar(x: x, y: y) {
                        guitarra.drawShapeNoteAt(string: pos.cuerda, fret: pos.traste, withText: "", alpha: 1.0, timeToAppear: 0.1, fillColor: Colores.background)
                    }
                case let .nota(n):
                    if let pos = coordinatesFromArrayToGuitar(x: x, y: y) {
                        guitarra.drawShapeNoteAt(string: pos.cuerda, fret: pos.traste, withText: n, alpha: 1.0, timeToAppear: 0.1, fillColor: Colores.background)
                    }
                default:
                    break
                }
                
            }
        }
    }
    
    func limpiarMastil() {
        guitarra.limpiarGuitarra()
        mastil.createEmptyMastil()
        dibujarMastil()
    }
    
    
    
    func dibujarIntervalo(_ intervalo: Intervalo) {
        let x = intervalo.origen.cuerda
        let y = intervalo.origen.traste
        guitarra.drawShapeNoteAt(string: x, fret: y, withText: "T")
        //guitarra.drawNoteAt(point: guitarra.matrizPositionNotes[x][y], withText: "T")
        for incremento in intervalo.posiciones {
            if let nuevaPosicion = intervalo.origen.incrementar(incremento) {
                let x = nuevaPosicion.cuerda
                let y = nuevaPosicion.traste
                //guitarra.drawNoteAt(point: guitarra.matrizPositionNotes[x][y])
                guitarra.drawShapeNoteAt(string: x, fret: y)
            }
        }
    }
    
    
    func dibujarTablonInstrucciones(_ instrucciones: String, yPasarFase fase: FasesJuego) {
        let tablon = SKShapeNode(rectOf: CGSize(width: size.width - Medidas.marginSpace * 2, height: size.height / 2), cornerRadius: 0.5)
        tablon.fillColor = SKColor.gray
        tablon.position = view!.center
        tablon.zPosition = 100
        
        let texto = SKLabelNode(fontNamed: "Chalkduster")
        texto.text = instrucciones
        texto.fontSize = 25
        texto.preferredMaxLayoutWidth = size.width - Medidas.marginSpace * 3
        texto.numberOfLines = 0
        texto.verticalAlignmentMode = .center
        texto.horizontalAlignmentMode = .center
        texto.position = .zero
        tablon.addChild(texto)
        addChild(tablon)
        let actionWait = SKAction.wait(forDuration: 1.0)
        let actionEnableInteraction = SKAction.run {
            self.view?.isUserInteractionEnabled = true
            self.fase = fase
        }
        let actionRemove = SKAction.removeFromParent()
        tablon.run(SKAction.sequence([actionWait, actionEnableInteraction, actionRemove]))
        
    }
    
    
    func crearTableroPuntuacion(conTiempo tiempo: TimeInterval, numVeces: Int) {
        labelQuedan.text = "Quedan: \(numVeces)"
        labelAciertos.text = "Aciertos: 0"
        labelFallos.text = "Fallos: 0"
        labelTiempo.text = String(Int(tiempo))
        
        let yPosition = view!.frame.height - Medidas.topSpace
        labelQuedan.position = CGPoint(x: Medidas.marginSpace, y: yPosition)
        labelAciertos.position = CGPoint(x: view!.frame.width / 4, y: yPosition)
        labelFallos.position = CGPoint(x: view!.frame.width / 2, y: yPosition)
        labelTiempo.position = CGPoint(x:view!.frame.width - Medidas.marginSpace * 2, y: yPosition)
        
        addChild(labelTiempo)
        addChild(labelAciertos)
        addChild(labelFallos)
        addChild(labelQuedan)
        existeTableroPuntuacion = true
    }
    
    // Dibuja las instrucciones de cada paso en la parte superior de la pantalla
    func dibujarIndicacionesPaso(indicaciones:String) {
        let texto = SKLabelNode(fontNamed: "AvenirNext-Regular")
        texto.text = indicaciones
        texto.name = "indicacion"
        texto.alpha = 1.0
        texto.zPosition = 100
        texto.fontSize = 22
        texto.fontColor = Colores.indicaciones
        texto.preferredMaxLayoutWidth = size.width - Medidas.marginSpace
        texto.numberOfLines = 0
        texto.verticalAlignmentMode = .center
        texto.horizontalAlignmentMode = .center
        texto.position = CGPoint(x:view!.frame.width / 2, y: view!.frame.height - Medidas.topSpace / 2 - 16)
        addChild(texto)
    }
    
    
    func limpiarTextoIndicaciones() {
        let indicacion = self.childNode(withName: "indicacion")
        indicacion?.removeFromParent()
    }
    
    func ejecutarPaso(_ paso: TipoPaso) {
        let (indicacion, accion) = paso
        dibujarIndicacionesPaso(indicaciones: indicacion)
        switch accion {
        case .mostrarNota(let stringNota, let cuerda, let traste):
            guitarra.writeNote(stringNota, inString: cuerda, atFret: traste)
            print(stringNota)
        case .mostrarIntervalo(let intervalo, let notaOrigen, let notaFinal):
            guitarra.dibujarIntervalo(intervalo, notaOrigen: notaOrigen, notaFinal: notaFinal, conPausa: 2.0)
            print("mostrar intervalo")
        case .mostrarFlecha:
            print("Mostrar Flecha")
        }
    }
    
    // MARK: Funciones de control del tiempo
    func updateTiempoPantalla(currentTime: TimeInterval) {
        if let startTime = startTime {
            elapsedTime = Int(currentTime) - startTime
        } else {
            startTime = Int(currentTime) - elapsedTime
        }
        let tiempoLimite = ejercicio.examen.tiempoLimite
        labelTiempo.text = String(Int(tiempoLimite) - elapsedTime)
    }
    
    
    // Mal, se está comparando con la posición origen!!!
    func esRespuestaCorrecta(_ respuesta: PosicionTraste?) -> Bool {
        if respuesta != nil {
            return respuesta == posicionNotaPropuesta.incrementar(ejercicio.ejercicio!.posiciones[0])
        } else {
            return false
        }
    }
}
