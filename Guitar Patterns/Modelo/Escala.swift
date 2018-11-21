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

enum TipoAcorde {
    case mayor
    case mayor7
    case menor
    case menor7
    case Maj7
    case Maj7sus
    case Maj7novena
    case Maj7sexta
    case Maj713
    case Maj711
    case Maj713sus
    case sexta
    case add9
    case sextanovena
    case add9sus
    case sextasus
    case sextanovenasus
    case sus4
}

class Acorde {
    var tipo: TipoAcorde
    var intervalica: [TipoIntervalo]
    
    
    let intervalos: [TipoAcorde:[TipoIntervalo]] = [
        .mayor: [TipoIntervalo.terceramayor, .quintajusta],
        .menor: [TipoIntervalo.terceramenor, .quintajusta],
        .Maj7:  [TipoIntervalo.terceramayor, .quintajusta, .septimamayor],
        .sexta: [TipoIntervalo.terceramayor, .quintajusta, .sextamayor]
    ]
    
    init(tipo: TipoAcorde) {
        self.tipo = tipo
        intervalica = intervalos[tipo]!
    }
    
}
