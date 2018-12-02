//
//  Escala.swift
//  Guitar Patterns
//
//  Created by Alberto Banet Masa on 19/11/2018.
//  Copyright © 2018 Alberto Banet Masa. All rights reserved.
//

import Foundation


enum TipoEscala: String, CaseIterable {
    case jonico = "Modo Jónico"
    case dorico = "Modo Dórico"
    case frigio = "Modo Frigio"
    case lidio = "Modo Lidio"
    case mixolidio = "Modo Mixolidio"
    case eolico = "Modo Eólico"
    case locrio = "Modo Locrio"
    case pentatonicaMayor = "Pentatónica mayor"
    case pentatonicaMenor = "Pentatónica menor"
    case pentatonicaMayorBlues = "Pentatónica mayor de blues"
    case pentatonicaMenorBlues = "Pentatónica menor de blues"
}



class Escala {
    var modo: TipoEscala
    var intervalica: [TipoIntervalo]
    var mayor: Bool
    
    let escalas: [TipoEscala:[TipoIntervalo]] = [
    .jonico: [TipoIntervalo.segundamayor, .terceramayor, .cuartajusta, .quintajusta, .sextamayor, .septimamayor, .unisono, .octavajusta],
    .dorico: [TipoIntervalo.segundamayor, .terceramenor, .cuartajusta, .quintajusta, .sextamayor, .septimamenor, .unisono, .octavajusta],
    .frigio: [TipoIntervalo.segundamenor, .terceramenor, .cuartajusta, .quintajusta, .sextamenor, .septimamenor, .unisono, .octavajusta],
    .lidio : [TipoIntervalo.segundamayor, .terceramayor, .cuartaaumentada, .quintajusta, .sextamayor, .septimamayor, .unisono, .octavajusta],
    .mixolidio: [TipoIntervalo.segundamayor, .terceramayor, .cuartajusta, .quintajusta, .sextamayor, .septimamenor, .unisono, .octavajusta],
    .eolico: [TipoIntervalo.segundamayor, .terceramenor, .cuartajusta, .quintajusta, .sextamenor, .septimamenor, .unisono, .octavajusta],
    .locrio: [TipoIntervalo.segundamenor, .terceramenor, .cuartajusta, .quintadisminuida, .sextamenor, .septimamenor, .unisono, .octavajusta],
    .pentatonicaMayor:
        [TipoIntervalo.segundamayor, .terceramayor, .quintajusta, .sextamayor, .unisono, .octavajusta],
    .pentatonicaMenor: [TipoIntervalo.terceramenor, .cuartajusta, .quintajusta, .septimamenor, .unisono, .octavajusta],
    .pentatonicaMayorBlues: [TipoIntervalo.segundamayor, .terceramenor, .terceramayor, .quintajusta, .sextamayor, .unisono, .octavajusta],
    .pentatonicaMenorBlues: [TipoIntervalo.terceramenor, .cuartajusta, .quintadisminuida, .quintajusta, .septimamenor, .unisono, .octavajusta]
    ]
    
    init(modo: TipoEscala) {
        self.modo = modo
        if modo == .jonico || modo == .lidio || modo == .mixolidio || modo == .pentatonicaMayor || modo == .pentatonicaMayorBlues {
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
