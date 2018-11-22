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
        let minutes = (time/60) % 60
        let seconds = time % 60
        let timeText = String(format: "%02d:%02d", minutes, seconds)
        timerLabel?.text = timeText
    }
    
    func addTimer(time: Int) {
        guard let scene = scene else { return }
        // 1
        let position = CGPoint(x: 0,
                               y: scene.frame.height/2 - 10)
        add(message: "Timer", position: position, fontSize: 24)
        // 2
        timerLabel = childNode(withName: "Timer") as? SKLabelNode
        timerLabel?.verticalAlignmentMode = .top
        timerLabel?.fontName = "Menlo"
        updateTimer(time: time)
    }
    
}
