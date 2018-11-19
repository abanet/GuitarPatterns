//
//  Mastil.swift
//  Guitar Patterns
//
//  Created by Alberto Banet Masa on 06/11/2018.
//  Copyright © 2018 Alberto Banet Masa. All rights reserved.
//
//  El mástil es la parte lógica de la guitarra gráfica

import Foundation




class Mastil {
    var armonia: Armonia = Armonia() // Definición de la armonía utilizada
    var trastes: [[TipoTraste]] = [[TipoTraste]]()
    
    init() {
        createEmptyMastil()
       // let nota = TipoTraste.nota("C#")
       // drawIntervalFrom(inicial: PosicionTraste(cuerda: 6, traste: 2), interval: armonia.intervalos[0])
       // writeNote(nota, inString: 1, atFret: 6)
    }
    
    // Crea el array definitorio del mástil con todos los trastes vacios
    func createEmptyMastil() {
        for _ in 0..<Medidas.numStrings {
            var oneString = [TipoTraste]()
            for _ in 0..<Medidas.numTrastes {
                let unTraste = TipoTraste.vacio
                oneString.append(unTraste)
            }
            trastes.append(oneString)
        }
    }
    
    //
    // MARK: Escritura de intervalos
    //
    
    // Dada una posición del mástil y un intervalo lo dibuja en el mástil
    // Controlar que está dentro de los límites antes de dibujarlo
    // Esta función dibuja todos los intervalos posibles aportados en la definición de intervalo
    func drawIntervalFrom(inicial: PosicionTraste, interval: Intervalo) {
        // calcular posición a dibujar
        var nuevosTrastes = [PosicionTraste]() // un intervalo puede aportar varias formas
        for unIncremento in interval.posiciones {
            if let nuevoTraste = inicial.incrementar(unIncremento) {
                nuevosTrastes.append(nuevoTraste)
            }
        }
        
        for unTraste in nuevosTrastes {
            writeNote(TipoTraste.nota("B"), enTraste: unTraste)
        }
    }
    
    //
    // MARK: Escritura de notas en el mástil
    //
    
    func writeNote(_ note: TipoTraste, enTraste traste: PosicionTraste) {
        let cuerda = traste.cuerda
        let fret = traste.traste
        writeNote(note, inString: cuerda, atFret: fret)
    }
    
    // escribe una nota en la posición indicada
    // Aquí la posición pasada por parámetro se dará desde la perspectiva de la guitarra
    func writeNote(_ note: TipoTraste, inString string:Int, atFret fret: Int) {
        let (x,y) = coordinatesFromGuitarToArray(string: string, fret: fret)
        trastes[x][y] = note
    }
    
    
    
}
