//
//  Nota.swift
//  Guitar Patterns
//
//  Created by Alberto Banet Masa on 07/11/2018.
//  Copyright © 2018 Alberto Banet Masa. All rights reserved.
//

import Foundation

enum NombreNota: String {
    case C = "C"
    case D = "D"
    case E = "E"
    case F = "F"
    case G = "G"
    case A = "A"
    case B = "B"
}

enum TipoIntervalo: String {
    case unisono            = ""
    case segundamenor       = "2b"
    case segundamayor       = "2"
    case terceramenor       = "3b"
    case terceramayor       = "3"
    case cuartajusta        = "4"
    case cuartaaumentada    = "4+"
    case quintadisminuida   = "5-"
    case quintajusta        = "5"
    case sextamenor         = "6b"
    case sextamayor         = "6"
    case septimamenor       = "7b"
    case septimamayor       = "7"
    case octavajusta        = "T"
    
    
}

extension TipoIntervalo: Hashable {
    static func == (lhs: TipoIntervalo, rhs: TipoIntervalo) -> Bool {
        return lhs.rawValue == rhs.rawValue
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(rawValue)
    }
}

let InversionesIntervalo: [TipoIntervalo:TipoIntervalo] =
    [
        .unisono            : .unisono,
        .segundamenor       : .septimamenor,
        .segundamayor       : .septimamenor,
        .terceramenor       : .sextamayor,
        .terceramayor       : .sextamenor,
        .cuartajusta        : .quintajusta,
        .cuartaaumentada    : .quintadisminuida,
        .quintadisminuida   : .cuartajusta,
        .quintajusta        : .cuartajusta,
        .sextamenor         : .terceramayor,
        .sextamayor         : .terceramenor,
        .septimamenor       : .segundamayor,
        .septimamayor       : .segundamenor,
        .octavajusta        : .octavajusta
]

let DistanciaIntervalos: [TipoIntervalo: Int] = [
    .unisono            : 0,
    .segundamenor       : 1,
    .segundamayor       : 2,
    .terceramenor       : 3,
    .terceramayor       : 4,
    .cuartajusta        : 5,
    .cuartaaumentada    : 6,
    .quintadisminuida   : 6,
    .quintajusta        : 7,
    .sextamenor         : 8,
    .sextamayor         : 9,
    .septimamenor       : 10,
    .septimamayor       : 11,
    .octavajusta        : 12
]




// Incremento para calcular otra nota
struct Incremento {
    let cuerda: Int
    let traste: Int
}

/**
    Define un intervalo musical
 
 Parametros:
    - origen: PosicionTraste
    - tipo: TipoIntervalo
    - posiciones: [Incremento] -> define todos los incrementos que crean el intervalo
    - distancia: Int -> número de semitonos.
 */
struct Intervalo {
    var origen: PosicionTraste
    var tipo: TipoIntervalo
    var posiciones: [Incremento] // las posibilidades de obtener en la guitarra los intervalos adyacentes
    var distancia: Int // el número de semitonos. De momento no lo usamos
    var notaOrigen: String? // Nombre de la nota origen
    var notaFinal : String? // Nombre de la nota que termina el intervalo
    
    init(origen: PosicionTraste, tipo: TipoIntervalo, posiciones: [Incremento], distancia: Int) {
        self.origen = origen
        self.tipo = tipo
        self.posiciones = posiciones
        self.distancia = distancia   
    }
}






/*
 *
 * CONOCIMIENTO MUSICAL
 *
 */

class Armonia {
  
    var intervalos: [TipoIntervalo:[Intervalo]] = [TipoIntervalo:[Intervalo]]()
    
    
    init() {
        definirIntervalosOctava()
    }
    
    //
    // MARK: Especificación de intervalos
    //
    
    func definirIntervalosOctava() {
        // Intervalo de octava desde la sexta cuerda
        let incrementos = [Incremento(cuerda: -2, traste: 2), Incremento(cuerda: -5, traste: 0)]
        let intervaloOctavaDesdeSexta = Intervalo(origen: PosicionTraste(cuerda: 6), tipo: TipoIntervalo.octavajusta, posiciones: incrementos, distancia: 12)
        let intervaloOctavaDesdeQuinta = Intervalo(origen: PosicionTraste(cuerda: 5), tipo: TipoIntervalo.octavajusta, posiciones: [incrementos[0]], distancia: 12)
        let incremento4y3 = Incremento(cuerda: -2, traste: 3)
        let intervaloOctavaDesdeCuarta = Intervalo(origen: PosicionTraste(cuerda: 4), tipo: TipoIntervalo.octavajusta, posiciones: [incremento4y3], distancia: 12)
        let intervaloOctavaDesdeTercera = Intervalo(origen: PosicionTraste(cuerda: 3), tipo: TipoIntervalo.octavajusta, posiciones: [incremento4y3], distancia: 12)
        intervalos[.octavajusta] = [intervaloOctavaDesdeSexta, intervaloOctavaDesdeQuinta, intervaloOctavaDesdeCuarta, intervaloOctavaDesdeTercera]
    }
    
    // TODO: redefinir intervalos para que los desplazamientos de cuerda sean negativos!!!
    func definirIntervalosSeptimaMayor(){
        let incrementos = [Incremento(cuerda: 2, traste: 1), Incremento(cuerda: 5, traste: -1), Incremento(cuerda: 0
            , traste: -1)]
        let intervaloSeptimaDesdeSexta = Intervalo(origen: PosicionTraste(cuerda: 6), tipo: .septimamayor, posiciones: incrementos, distancia: 11)
        let intervaloSeptimaDesdeQuinta = Intervalo(origen: PosicionTraste(cuerda: 5), tipo: .septimamayor, posiciones: [incrementos[0]], distancia: 11)
        let incremento4y3 = Incremento(cuerda: 2, traste: 2)
        let intervaloSeptimaDesdeCuarta = Intervalo(origen: PosicionTraste(cuerda: 4), tipo: .septimamayor, posiciones: [incremento4y3], distancia: 11)
        let intervaloSeptimaDesdeTercera = Intervalo(origen: PosicionTraste(cuerda: 3), tipo: .septimamayor, posiciones: [incremento4y3], distancia: 11)
        intervalos[.septimamayor] = [intervaloSeptimaDesdeSexta, intervaloSeptimaDesdeQuinta, intervaloSeptimaDesdeCuarta, intervaloSeptimaDesdeTercera]
    }
    
    func definirIntervalosSeptimaMenor(){
        let incrementos = [Incremento(cuerda: 2, traste: 0), Incremento(cuerda: 5, traste: -2), Incremento(cuerda: 0
            , traste: -2)]
        let intervaloSeptimaDesdeSexta = Intervalo(origen: PosicionTraste(cuerda: 6), tipo: .septimamenor, posiciones: incrementos, distancia: 10)
        let intervaloSeptimaDesdeQuinta = Intervalo(origen: PosicionTraste(cuerda: 5), tipo: .septimamenor, posiciones: [incrementos[0]], distancia: 10)
        let incremento4y3 = Incremento(cuerda: 2, traste: 1)
        let intervaloSeptimaDesdeCuarta = Intervalo(origen: PosicionTraste(cuerda: 4), tipo: .septimamenor, posiciones: [incremento4y3], distancia: 10)
        let intervaloSeptimaDesdeTercera = Intervalo(origen: PosicionTraste(cuerda: 3), tipo: .septimamenor, posiciones: [incremento4y3], distancia: 10)
        intervalos[.septimamenor] = [intervaloSeptimaDesdeSexta, intervaloSeptimaDesdeQuinta, intervaloSeptimaDesdeCuarta, intervaloSeptimaDesdeTercera]
    }
    
    func definirIntervalosSextaMayor(){
        let incrementos = [Incremento(cuerda: 2, traste: -1), Incremento(cuerda: 4, traste: 2)]
        let intervaloSextaDesdeSexta = Intervalo(origen: PosicionTraste(cuerda: 6), tipo: .sextamayor, posiciones: incrementos, distancia: 9)
        let intervaloSextaDesdeQuinta = Intervalo(origen: PosicionTraste(cuerda: 5), tipo: .septimamenor, posiciones: [incrementos[0]], distancia: 9)
      // Aquí me quedo revisando intervalos
        let incremento4y3 = Incremento(cuerda: 2, traste: 1)
        let intervaloSextaDesdeCuarta = Intervalo(origen: PosicionTraste(cuerda: 4), tipo: .septimamenor, posiciones: [incremento4y3], distancia: 9)
        let intervaloSextaDesdeTercera = Intervalo(origen: PosicionTraste(cuerda: 3), tipo: .septimamenor, posiciones: [incremento4y3], distancia: 9)
        intervalos[.sextamayor] = [intervaloSextaDesdeSexta, intervaloSextaDesdeQuinta, intervaloSextaDesdeCuarta, intervaloSextaDesdeTercera]
    }
    
    func definirIntervalosSextaMenor(){
        
    }
    
    func definirIntervalosQuintaAumentada(){
        
    }
    
    func definirIntervalosQuintaJusta(){
        
    }
    
    func definirIntervalosCuartaAumentada(){
        
    }
    
    func definirIntervalosCuartaJusta(){
        
    }
    
    func definirIntervalosTerceraMayor(){
        
    }
    
    func definirIntervalosTerceraMenor(){
        
    }
    
    func definirIntervalosSegundaMayor(){
        
    }
    
    func definirIntervalosSegundaMenor(){
        
    }
    
}


