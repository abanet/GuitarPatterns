//
//  Traste.swift
//  Guitar Patterns
//
//  Created by Alberto Banet Masa on 16/11/2018.
//  Copyright © 2018 Alberto Banet Masa. All rights reserved.
//

import Foundation

typealias TipoPosicionCuerda = Int
typealias TipoPosicionTraste = Int

/**
 * case vacio, blanco, nota(String), relacion(Int)
 */
enum TipoTraste {
    case vacio
    case blanco
    case nota(String)
    case relacion(Int) // igual no hace falta y los tratamos como notas
}

/**
 Almacena una posición de traste en formato cuerda, traste.
 Incluye funciones matemáticas para el cálculo de trastes a partir de la suma de intervalos
 */
struct PosicionTraste: Equatable {
    var cuerda: Int
    var traste: Int
    
    init(cuerda: Int) {
        self.cuerda = cuerda
        self.traste = 0
    }
    
    init(traste:Int) {
        self.traste = traste
        self.cuerda = 0
    }
    
    init(cuerda: Int, traste: Int) {
        self.cuerda = cuerda
        self.traste = traste
    }
    
    mutating func autoincrementar (_ inc: Incremento) { // Aquí no comprobamos si está en los límites
        cuerda = cuerda + inc.cuerda
        traste = traste + inc.traste
    }
    
    // Dado un traste y un incremento en cuerdas y trastes, la función calcula el traste resultante.
    func incrementar (_ inc: Incremento) -> PosicionTraste? {
        let nuevaPosicion = PosicionTraste(cuerda: cuerda + inc.cuerda, traste: traste + inc.traste)
        if nuevaPosicion.cuerda > Medidas.numStrings || nuevaPosicion.traste > Medidas.numTrastes {
            return nil
        } else {
            return nuevaPosicion
        }
        
    }
    
    // Calculamos el intervalo existente entre la posición actual y la posición dada.
    // Suposición: la tónica está siempre por encima de la segunda cuerda
    func intervaloHasta(posicion: PosicionTraste, intervalica: [TipoIntervalo]) -> TipoIntervalo? {
        guard let semitonos = semitonosHasta(posicion: posicion) else {
            return nil
        }
        
        // buscamos el intervalo a esa distancia que pertenezca a la interválica que estamos tratando
        for (key, value) in DistanciaIntervalos {
            if value == semitonos && intervalica.contains(key) {
                    return key
            }
        }
        return nil
    }
    
    
    
    func semitonosHasta(posicion: PosicionTraste) -> Int? {
        guard self.cuerda != 0 && self.traste != 0 else {
            return nil
        }
        
        let cuerdasInvolucradas = abs(self.cuerda - posicion.cuerda)
        var semitonos = 0
        if self.cuerda >= posicion.cuerda {
            semitonos = cuerdasInvolucradas * 5 // afinación universal: bajada por cuartas
        } else {
            semitonos = cuerdasInvolucradas * 7 // subida por quintas
        }
        if self.cuerda <= posicion.cuerda {
            if (self.cuerda...posicion.cuerda).contains(2) {
                semitonos -= 1              // Corrección por 2 cuerda
            }
        } else {
            if (posicion.cuerda...self.cuerda).contains(2) {
                semitonos -= 1              // Corrección por 2 cuerda
            }
            
        }
        
        semitonos += posicion.traste - self.traste
        if semitonos < 0 { // este caso se da cuando la nota está en la misma cuerda antes que la tónica
            semitonos = 12 + semitonos
        }
        
        semitonos = semitonos % 12
        if semitonos == 0 {
            semitonos = 12
        }
        
        return semitonos
    }
    
    
    func invertirIntervalo(_ intervalo: TipoIntervalo) -> TipoIntervalo {
        switch intervalo {
        case .unisono:
            return .unisono
        case .segundamenor:
            return .septimamayor
        case .segundamayor:
            return .septimamenor
        case .terceramenor:
            return .sextamayor
        case .terceramayor:
            return .sextamenor
        case .cuartajusta:
            return .quintajusta
        case .cuartaaumentada:
            return .quintadisminuida
        case .quintadisminuida:
            return .cuartaaumentada
        case .quintajusta:
            return .cuartajusta
        case .sextamenor:
            return .terceramayor
        case .sextamayor:
            return .terceramenor
        case .septimamenor:
            return .segundamayor
        case .septimamayor:
            return .segundamenor
        case .octavajusta:
            return .octavajusta
        }
    }
    
    // MARK: Equatable Protocol
    static func == (lhs: PosicionTraste, rhs: PosicionTraste) -> Bool {
        return lhs.cuerda == rhs.cuerda &&
            lhs.traste == rhs.traste
    }
}
