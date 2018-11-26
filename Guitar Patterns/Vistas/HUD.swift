//
//  HUD.swift
//  Guitar Patterns
//
//  Created by Alberto Banet Masa on 22/11/2018.
//  Copyright © 2018 Alberto Banet Masa. All rights reserved.
//

import SpriteKit

enum HUDSettings {
    static let font = "Noteworthy-Bold"
    static let fontSize: CGFloat = 22
}

class HUD: SKNode {
    
    var timerLabel: SKLabelNode?
    var puntosLabel: SKLabelNode?
    
    override init() {
        super.init()
        name = "HUD"
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func add(message: String, position: CGPoint,
                fontSize: CGFloat = HUDSettings.fontSize) {
        let label: SKLabelNode
        label = SKLabelNode(fontNamed: HUDSettings.font)
        label.text = message
        label.name = message
        label.zPosition = 100
        addChild(label)
        label.fontSize = fontSize
        label.position = position
    }
    
    func updateTimer(time: Int) {
        guard time >= 0 else { return }
        let minutes = (time/60) % 60
        let seconds = time % 60
        let timeText = String(format: "%02d:%02d", minutes, seconds)
        timerLabel?.text = timeText
    }
    
    func addTimer(time: Int, position: CGPoint) {
        guard scene != nil else { return }
        add(message: "Timer", position: position, fontSize: 24)
        timerLabel = childNode(withName: "Timer") as? SKLabelNode
        timerLabel?.verticalAlignmentMode = .bottom
        timerLabel?.fontName = "Menlo"
        updateTimer(time: time)
    }
    
    func addPuntos(position: CGPoint) {
        guard scene != nil else { return }
        add(message: "Puntos", position: position, fontSize: 24)
        puntosLabel = childNode(withName: "Puntos") as? SKLabelNode
        puntosLabel?.verticalAlignmentMode = .bottom
        puntosLabel?.fontName = "Menlo"
        puntosLabel?.text = "000000"
    }
    
    func updatePuntosTo(_ puntos: Int) {
        puntosLabel?.text = String(format: "%06d", puntos)
    }
}
