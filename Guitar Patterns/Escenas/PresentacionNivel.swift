//
//  PresentacionNivel.swift
//  Guitar Patterns
//
//  Created by Alberto Banet Masa on 21/11/2018.
//  Copyright © 2018 Alberto Banet Masa. All rights reserved.
//

import SpriteKit

class PresentacionNivel: SKScene {
    let level: Int
    let patron: Patron
    
    init(size: CGSize, level: Int, patron: Patron) {
        self.level = level
        self.patron = patron
        super.init(size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMove(to view: SKView) {
        view.backgroundColor = .gray
        let titulo = "Nivel \(level)"
        let descripcion = "¡ Completa los intervalos en orden de aparición antes de que se autodestruyan !"
        addTitulo(titulo)
        addInstrucciones(descripcion)
        irAJuego()
    }
    
    func addTitulo(_ titulo: String) {
        let tituloNodo = SKLabelNode(fontNamed: "Chalkduster")
        tituloNodo.text = titulo
        tituloNodo.name = "titulo"
        tituloNodo.fontSize = 50
        tituloNodo.fontColor = Colores.indicaciones
        tituloNodo.preferredMaxLayoutWidth = size.width - Medidas.marginSpace
        tituloNodo.numberOfLines = 0
        tituloNodo.verticalAlignmentMode = .center
        tituloNodo.horizontalAlignmentMode = .center
        tituloNodo.position = CGPoint(x:view!.frame.width / 2, y: view!.frame.height / 1.5)
        addChild(tituloNodo)
    }
    
    func addInstrucciones(_ texto: String) {
        let tituloNodo = SKLabelNode(fontNamed: "Chalkduster")
        tituloNodo.text = texto
        tituloNodo.name = "titulo"
        tituloNodo.fontSize = 25
        tituloNodo.fontColor = Colores.indicaciones
        tituloNodo.preferredMaxLayoutWidth = size.width - Medidas.marginSpace
        tituloNodo.numberOfLines = 0
        tituloNodo.verticalAlignmentMode = .center
        tituloNodo.horizontalAlignmentMode = .center
        tituloNodo.position = CGPoint(x:view!.frame.width / 2, y: view!.frame.height / 2)
        addChild(tituloNodo)
    }
    
    func irAJuego() {
        guard let vista = self.scene?.view else {
            return
        }
        let wait = SKAction.wait(forDuration: 2.0)
        let nivel: Nivel = Nivel.getNivel(level)
        let irJuegoPatron = SKAction.run {
            let escena = JuegoPatron(size: self.size, nivel: nivel, patron: self.patron)
            vista.ignoresSiblingOrder = true
            let reveal = SKTransition.flipHorizontal(withDuration: 0.5)
            // https://stackoverflow.com/questions/35713804/in-spritekit-presentscene-transition-wont-work-however-presentscene-does
            vista.presentScene(escena)//, transition: reveal)
        }
        self.run(SKAction.sequence([wait, irJuegoPatron]))
    }
}



