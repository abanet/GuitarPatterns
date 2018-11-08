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
    case jugando
}
class GameScene: SKScene {
    var armonia: Armonia!
    var guitarra: GuitarraGrafica!  // parte gráfica del mástil
    var mastil: Mastil!             // parte lógica del mástil
    var ejercicio: Ejercicio!
    
    var fase: FasesJuego = .mostrandoInstrucciones
   
    override func didMove(to view: SKView) {
        backgroundColor = Colores.background
        iniciarGuitarra()
        dibujarMastil()
        armonia = Armonia()
        ejercicio = Ejercicio(instrucciones: "Vas a aprender el intervalo de octava.",
                              enunciado: "Ahora pulsa tu en la octava de la nota propuesta",
                              ejercicio: armonia.intervalos[0])
        
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Ciclo principal
        switch fase {
        case .mostrandoInstrucciones:
            view?.isUserInteractionEnabled = false
            // Mostrar instrucciones ejercicio. Wait
            dibujarTablonInstrucciones(ejercicio.instrucciones, yPasarFase: .jugando)
        case .jugando:
            break
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
    
    func dibujarTablonInstrucciones(_ texto: String, yPasarFase fase: FasesJuego) {
        let tablon = SKShapeNode(rectOf: CGSize(width: size.width - Medidas.marginSpace * 2, height: size.height / 2), cornerRadius: 0.5)
        tablon.fillColor = SKColor.gray
        tablon.position = view!.center
        tablon.zPosition = 100
        
        let texto = SKLabelNode(fontNamed: "Chalkduster")
        texto.text = texto
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
}
