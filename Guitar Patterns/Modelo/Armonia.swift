//
//  Nota.swift
//  Guitar Patterns
//
//  Created by Alberto Banet Masa on 07/11/2018.
//  Copyright © 2018 Alberto Banet Masa. All rights reserved.
//

import Foundation

struct Nota {
    let literal: String
    let lugarArmonico: String // T, 2b, 5aug, etc
    let posicion: PosicionTraste
}

// Incremento para calcular otra nota
struct Incremento {
    let cuerda: Int
    let traste: Int
}

struct Intervalo {
    let origen: PosicionTraste
    let tipo: TipoIntervalo
    let posiciones: [Incremento] // las posibilidades de obtener en la guitarra los intervalos adyacentes
    let distancia: Int // el número de semitonos. De momento no lo usamos
    
}

enum TipoIntervalo {
    case segundamenor
    case segundamayor
    case terceramenor
    case terceramayor
    case cuartajusta
    case cuartaaumentada
    case quintadisminuida
    case quintajusta
    case sextamenor
    case sextamayor
    case septimamenor
    case septimamayor
    case octavajusta
}

struct Patron {
    let nombre: String
    let origen: Nota
    let sucesionNotas: [Nota]
    let sucesionIntervalos: [Intervalo]
}

/*
 *
 * CONOCIMIENTO MUSICAL
 *
 */

class Armonia {
    var intervalos: [Intervalo] = [Intervalo]()
    
    init() {
        definirIntervalosOctava()
    }
    
    //
    // MARK: Especificación de intervalos
    //
    
    func definirIntervalosOctava() {
        // Intervalo de octava desde la sexta cuerda
        let incrementos = [Incremento(cuerda: 2, traste: 2), Incremento(cuerda: 5, traste: 0)]
        let intervaloOctavaDesdeSexta = Intervalo(origen: PosicionTraste(cuerda: 6), tipo: TipoIntervalo.octavajusta, posiciones: incrementos, distancia: 12)
        let intervaloOctavaDesdeQuinta = Intervalo(origen: PosicionTraste(cuerda: 5), tipo: TipoIntervalo.octavajusta, posiciones: [incrementos[0]], distancia: 12)
        let incremento4y3 = Incremento(cuerda: 2, traste: 3)
        let intervaloOctavaDesdeCuarta = Intervalo(origen: PosicionTraste(cuerda: 4), tipo: TipoIntervalo.octavajusta, posiciones: [incremento4y3], distancia: 12)
        let intervaloOctavaDesdeTercera = Intervalo(origen: PosicionTraste(cuerda: 3), tipo: TipoIntervalo.octavajusta, posiciones: [incremento4y3], distancia: 12)
        intervalos.append(intervaloOctavaDesdeSexta)
        intervalos.append(intervaloOctavaDesdeQuinta)
        intervalos.append(intervaloOctavaDesdeCuarta)
        intervalos.append(intervaloOctavaDesdeTercera)
    }
    
    func definirIntervalosSeptimaMayor(){
        let incrementos = [Incremento(cuerda: 2, traste: 1), Incremento(cuerda: 5, traste: -1), Incremento(cuerda: 0
            , traste: -1)]
        let intervaloSeptimaDesdeSexta = Intervalo(origen: PosicionTraste(cuerda: 6), tipo: .septimamayor, posiciones: incrementos, distancia: 11)
        let intervaloSeptimaDesdeQuinta = Intervalo(origen: PosicionTraste(cuerda: 5), tipo: .septimamayor, posiciones: [incrementos[0]], distancia: 11)
        let incremento4y3 = Incremento(cuerda: 2, traste: 2)
        let intervaloSeptimaDesdeCuarta = Intervalo(origen: PosicionTraste(cuerda: 4), tipo: .septimamayor, posiciones: [incremento4y3], distancia: 11)
        let intervaloSeptimaDesdeTercera = Intervalo(origen: PosicionTraste(cuerda: 3), tipo: .septimamayor, posiciones: [incremento4y3], distancia: 11)
        intervalos.append(intervaloSeptimaDesdeSexta)
        intervalos.append(intervaloSeptimaDesdeQuinta)
        intervalos.append(intervaloSeptimaDesdeCuarta)
        intervalos.append(intervaloSeptimaDesdeTercera)
    }
    
    func definirIntervalosSeptimaMenor(){
        let incrementos = [Incremento(cuerda: 2, traste: 0), Incremento(cuerda: 5, traste: -2), Incremento(cuerda: 0
            , traste: -2)]
        let intervaloSeptimaDesdeSexta = Intervalo(origen: PosicionTraste(cuerda: 6), tipo: .septimamenor, posiciones: incrementos, distancia: 10)
        let intervaloSeptimaDesdeQuinta = Intervalo(origen: PosicionTraste(cuerda: 5), tipo: .septimamenor, posiciones: [incrementos[0]], distancia: 10)
        let incremento4y3 = Incremento(cuerda: 2, traste: 1)
        let intervaloSeptimaDesdeCuarta = Intervalo(origen: PosicionTraste(cuerda: 4), tipo: .septimamenor, posiciones: [incremento4y3], distancia: 10)
        let intervaloSeptimaDesdeTercera = Intervalo(origen: PosicionTraste(cuerda: 3), tipo: .septimamenor, posiciones: [incremento4y3], distancia: 10)
        intervalos.append(intervaloSeptimaDesdeSexta)
        intervalos.append(intervaloSeptimaDesdeQuinta)
        intervalos.append(intervaloSeptimaDesdeCuarta)
        intervalos.append(intervaloSeptimaDesdeTercera)
    }
    
    func definirIntervalosSextaMayor(){
        let incrementos = [Incremento(cuerda: 2, traste: -1), Incremento(cuerda: 4, traste: 2)]
        let intervaloSeptimaDesdeSexta = Intervalo(origen: PosicionTraste(cuerda: 6), tipo: .septimamenor, posiciones: incrementos, distancia: 10)
        let intervaloSeptimaDesdeQuinta = Intervalo(origen: PosicionTraste(cuerda: 5), tipo: .septimamenor, posiciones: [incrementos[0]], distancia: 10)
        let incremento4y3 = Incremento(cuerda: 2, traste: 1)
        let intervaloSeptimaDesdeCuarta = Intervalo(origen: PosicionTraste(cuerda: 4), tipo: .septimamenor, posiciones: [incremento4y3], distancia: 10)
        let intervaloSeptimaDesdeTercera = Intervalo(origen: PosicionTraste(cuerda: 3), tipo: .septimamenor, posiciones: [incremento4y3], distancia: 10)
        intervalos.append(intervaloSeptimaDesdeSexta)
        intervalos.append(intervaloSeptimaDesdeQuinta)
        intervalos.append(intervaloSeptimaDesdeCuarta)
        intervalos.append(intervaloSeptimaDesdeTercera)
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
