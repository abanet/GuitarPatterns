//
//  GameViewController.swift
//  Guitar Patterns
//
//  Created by Alberto Banet Masa on 05/11/2018.
//  Copyright © 2018 Alberto Banet Masa. All rights reserved.
//

import UIKit
import SpriteKit


class GameViewController: UIViewController {
    let patron: Patron
    
    
    init(patron: Patron) {
        self.patron = patron
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        self.view = SKView()
        view.frame = UIScreen.main.bounds
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //let scene = GameScene(size:CGSize(width: view.frame.width, height: view.frame.height))
        //let scene = EditorPatrones(size: CGSize(width: view.frame.width, height: view.frame.height))
        //let scene = DibujarPatron(size: CGSize(width: view.frame.width, height: view.frame.height))
        let scene = PresentacionNivel(size: CGSize(width: view.frame.width, height: view.frame.height), level: 1, patron: patron)
        print("Tamaño escena: \(view.frame.width) x \(view.frame.height)")
        let skView = self.view as! SKView
        skView.ignoresSiblingOrder = true
        skView.presentScene(scene)
       
    }

   

    override var prefersStatusBarHidden: Bool {
        return true
    }
}
