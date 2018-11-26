//
//  Puntuacion.swift
//  Guitar Patterns
//
//  Created by Alberto Banet Masa on 26/11/2018.
//  Copyright © 2018 Alberto Banet Masa. All rights reserved.
//

import Foundation


class Puntuacion {
    
    class func getPuntuacionJuegoPatrones() -> Double {
        return UserDefaults.standard.double(forKey: "puntosJuegoPatrones")
    }
    
    class func setPuntuacionJuegoPatrones(puntos: Double) {
        UserDefaults.standard.set(puntos, forKey: "puntosJuegoPatrones")
    }
}
