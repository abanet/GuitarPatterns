//
//  Escala.swift
//  Guitar Patterns
//
//  Created by Alberto Banet Masa on 19/11/2018.
//  Copyright © 2018 Alberto Banet Masa. All rights reserved.
//

import Foundation


enum TipoModo {
    case jonico
    case dorico
    case frigio
    case lidio
    case mixolidio
    case eolico
    case locrio
}




class Escala {
    var modo: TipoModo
    var intervalica: [TipoIntervalo]
    var mayor: Bool
    
    let escalas: [TipoModo:[TipoIntervalo]] = [
    .jonico: [TipoIntervalo.segundamayor, .terceramayor, .cuartajusta, .quintajusta, .sextamayor, .septimamayor],
    .dorico: [TipoIntervalo.segundamayor, .terceramenor, .cuartajusta, .quintajusta, .sextamayor, .septimamenor],
    .frigio: [TipoIntervalo.segundamenor, .terceramenor, .cuartajusta, .quintajusta, .sextamenor, .septimamenor],
    .lidio : [TipoIntervalo.segundamayor, .terceramayor, .cuartaaumentada, .quintajusta, .sextamayor, .septimamayor],
    .mixolidio: [TipoIntervalo.segundamayor, .terceramayor, .cuartajusta, .quintajusta, .sextamayor, .septimamenor],
    .eolico: [TipoIntervalo.segundamayor, .terceramenor, .cuartajusta, .quintajusta, .sextamenor, .septimamenor],
    .locrio: [TipoIntervalo.segundamenor, .terceramenor, .cuartajusta, .quintadisminuida, .sextamenor, .septimamenor]
    ]
    
    init(modo: TipoModo) {
        self.modo = modo
        if modo == .jonico || modo == .lidio || modo == .mixolidio {
            mayor = true
        } else {
            mayor = false
        }
        intervalica = escalas[modo]!
    }
    
    
}
