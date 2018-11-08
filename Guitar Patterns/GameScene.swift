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
    case realizarDemo
    case jugando
}

class GameScene: SKScene {
    var armonia: Armonia!
    var guitarra: GuitarraGrafica!  // parte gráfica del mástil
    var mastil: Mastil!             // parte lógica del mástil
    let ddbb = DatabaseEjercicios()
    var ejercicio: Ejercicio!
    
    var fase: FasesJuego = .mostrandoInstrucciones
   
    override func didMove(to view: SKView) {
        backgroundColor = Colores.background
        iniciarGuitarra()
        dibujarMastil()
      addChild(guitarra.drawArrow(from: CGPoint(x:50, y:50), to: CGPoint(x:100, y:100), tailWidth: 1, headWidth: 10, headLength: 20))
        armonia = Armonia()
        ejercicio = ddbb.ejercicios[0] // nuestro único ejercicio por ahora!
        
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Ciclo principal
        switch fase {
        case .mostrandoInstrucciones:
            view?.isUserInteractionEnabled = false
            // Mostrar instrucciones ejercicio. Wait
            dibujarTablonInstrucciones(ejercicio.instrucciones!, yPasarFase: .realizarDemo)
          
        case .realizarDemo:
          
        case .jugando:
          dibujarIndicacionesPaso(indicaciones: "hola")
        }
        
            
            
        // Realizar demo
        
        // Mostrar enunciado. Wait
     
        // Cuenta atrás para que usuario responda
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
  
  func dibujarIntervalo(_ intervalo: Intervalo) {
    let x = intervalo.origen.cuerda ?? 6
    let y = intervalo.origen.traste ?? 3
    guitarra.drawNoteAt(point: guitarra.matrizPositionNotes[x][y], withText: "T")
    for incremento in intervalo.posiciones {
      if let nuevaPosicion = intervalo.origen.incrementar(incremento) {
        let x = nuevaPosicion.cuerda!
        let y = nuevaPosicion.traste!
        guitarra.drawNoteAt(point: guitarra.matrizPositionNotes[x][y])
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
  
  // Dibuja las instrucciones de cada paso en la parte superior de la pantalla
  func dibujarIndicacionesPaso(indicaciones:String) {
    let texto = SKLabelNode(text: indicaciones)
    texto.fontSize = 18
    texto.preferredMaxLayoutWidth = size.width - Medidas.marginSpace
    texto.numberOfLines = 0
    texto.verticalAlignmentMode = .center
    texto.horizontalAlignmentMode = .center
    texto.position = CGPoint(x:view!.frame.width / 2, y: view!.frame.height - Medidas.topSpace / 2)
    addChild(texto)
  }
  
  func realizarPasos(ejercicio: Ejercicio) {
    guard ejercicio.pasos != nil else {
      return
    }
    for (indicacion,paso) in ejercicio.pasos! {
      dibujarIndicacionesPaso(indicaciones: indicacion)
      ejecutarPaso(paso)
    }
  }
  
  func ejecutarPaso(paso: )
}
