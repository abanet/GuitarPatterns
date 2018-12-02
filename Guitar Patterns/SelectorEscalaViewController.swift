//
//  SelectorEscalaViewController.swift
//  Guitar Patterns
//
//  Created by Alberto Banet Masa on 28/11/2018.
//  Copyright © 2018 Alberto Banet Masa. All rights reserved.
//

import UIKit
import SpriteKit

class SelectorEscalaViewController: UIViewController {
    
    var picker: UIPickerView = {
        let p = UIPickerView()
        p.translatesAutoresizingMaskIntoConstraints = false
       // p.autoresizingMask = .flexibleWidth
        return p
    }()
    
    var btnGoGame : UIButton = {
        let btn = UIButton()
        btn.addTarget(self, action: #selector(btnGoGamePressed(_:)), for: .touchDown)
        btn.frame = .zero //CGRect(x: 100, y: 100, width: 200, height: 50)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setTitle("Start", for: .normal)
        btn.titleLabel?.textAlignment = .center
        return btn
    }()
    
    let patrones = PatronesDdbb()
    var escalasPosibles: [String] = [String]()
    
    var escalaEscogida: TipoEscala = TipoEscala.jonico // valor por defecto
    var numPatronEscogido: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadViews()
        layoutVistas()
        picker.delegate = self
        picker.dataSource = self
        poblarEscalasPosibles()
    }
    
    
    
    func poblarEscalasPosibles() {
        escalasPosibles = TipoEscala.allCases.map({$0.rawValue})
    }
    
   @objc func btnGoGamePressed(_ sender: UIButton) {
    //let patron = (PatronesDdbb().diccionarioEscalas[.pentatonicaMenorBlues]?[1])!
    if let patronAJugar = patrones.diccionarioEscalas[escalaEscogida]?[numPatronEscogido] {
        let secondViewController = GameViewController(patron: patronAJugar)
        self.present(secondViewController, animated: true, completion: nil)
    }
    }
    
    // MARK: funciones de Layout
    func loadViews() {
        view.addSubview(picker)
        view.addSubview(btnGoGame)
    }
    
    func layoutVistas(){
        // UIPicker layout
        let centerVertically = NSLayoutConstraint(item: picker,
                                                  attribute: .centerX,
                                                  relatedBy: .equal,
                                                  toItem: view,
                                                  attribute: .centerX,
                                                  multiplier: 1.0,
                                                  constant: 0.0)
        let centerHorizontally = NSLayoutConstraint(item: picker,
                                                    attribute: .centerY,
                                                    relatedBy: .equal,
                                                    toItem: view,
                                                    attribute: .centerY,
                                                    multiplier: 1.0,
                                                    constant: 0.0)
        NSLayoutConstraint.activate([centerVertically, centerHorizontally])
        picker.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        picker.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        
        // Button layout
        btnGoGame.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 16).isActive = true
        let centerButtonHorizontally = NSLayoutConstraint(item: btnGoGame,
                                                          attribute: .centerY,
                                                          relatedBy: .equal,
                                                          toItem: view,
                                                          attribute: .centerY,
                                                          multiplier: 1.0,
                                                          constant: 0.0)
        NSLayoutConstraint.activate([centerButtonHorizontally])
        
    }
}

extension SelectorEscalaViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    // UIPickerViewDataSource
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0 { // Tipos de escalas
            return escalasPosibles.count
        }
        if component == 1 { // Variaciones dentro de la escala escogida
            if let patronesEscalaEscogida = patrones.diccionarioEscalas[escalaEscogida] {
                return patronesEscalaEscogida.count
            } else {
                return 0
            }
        }
        return 10 // algo ha ido mal...
    }
    
    // UIPickerViewDelegate
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if component == 0 {
            escalaEscogida = TipoEscala(rawValue: escalasPosibles[row])!
            pickerView.reloadComponent(1)
            numPatronEscogido = 0 // al cambiar de escala por defecto se escoge el primer valor
        }
        if component == 1 {
            numPatronEscogido = row
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if component == 0 {
            return escalasPosibles[row]
        }
        if component == 1 {
            if let patrones = patrones.diccionarioEscalas[escalaEscogida] {
                return patrones[row].descripcion
            }
        }
        return "NOOOOO!!!"
    }
    
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        if component == 0 {
            return view.bounds.width / 3
        }
        return view.bounds.width * 2 / 3
    }
}
