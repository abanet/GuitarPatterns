//
//  Posicion.swift
//  Guitar Patterns
//
//  Created by Alberto Banet Masa on 16/11/2018.
//  Copyright © 2018 Alberto Banet Masa. All rights reserved.
//

import Foundation



enum TipoPatron {
    case escala (TipoModo)
    case arpegio
    case acorde
}

class Patron {
    var tipo: TipoPatron
    var intervalica: [TipoIntervalo]
    private var posPrimeraTonica: PosicionTraste  // Posición de la primera tónica. No tiene pq coincidir con la primera posición aunque generalmente será así
    private var incrementos: [Incremento]
    lazy var posiciones: [PosicionTraste] = { // se calculan a partir de la posición de la tónica y los incrementos
        return calcularPosiciones()
    }()
    
    var nombre: String?
    var descripcion: String?
    var dedo: Int = 1
    
    init(){
        posPrimeraTonica = PosicionTraste(cuerda: 6, traste: 2) // posición de origen por defecto
        incrementos = [Incremento]()
        self.tipo = .escala(.jonico)
        self.intervalica = Escala(modo: .jonico).intervalica
    }
    
    init(tipo: TipoPatron, posTonica: PosicionTraste, incrementos: [Incremento]) {
        self.tipo = tipo
        self.posPrimeraTonica = posTonica
        self.incrementos = incrementos
        switch tipo {
        case .escala(let modo):
            self.intervalica = Escala(modo:modo).intervalica
        case .arpegio:
            break
        case .acorde:
            break
        }
        self.intervalica = Escala(modo:.jonico).intervalica
    }
    
    
    func setPosTonica(_ origen: PosicionTraste) {
        self.posPrimeraTonica = origen
    }
    
    func getPosTonica() -> PosicionTraste {
        return posPrimeraTonica
    }
    
    
    func addPosicion(_ posicion: PosicionTraste) {
        posiciones.append(posicion)
    }
    
    func removePosicion(_ posicion: PosicionTraste) {
        posiciones = posiciones.filter { $0 != posicion }
    }
    
    // Dada la posicion básica y los incrementos que definen el patrón se calculan todas las posiciones en el mastil
    func calcularPosiciones() -> [PosicionTraste] {
        var arrayPosiciones = [PosicionTraste]()
        arrayPosiciones.append(self.posPrimeraTonica)
        for incremento in incrementos {
            if let siguienteTraste = self.posPrimeraTonica.incrementar(incremento) {
                arrayPosiciones.append(siguienteTraste)
            }
        }
        return arrayPosiciones
    }
    
}


// Definición de los patrones
struct PatronesDdbb {
    var patrones: [Patron] = [Patron]()
    var escalas: [Patron] = [Patron]()
    
    
    init() {
        self.incorporarPatrones()
    }
    
    mutating func incorporarPatrones() {
        // Patrón del MODO JÓNICO
        let escalaJonicaRaizBordonD1: Patron = Patron(tipo: .escala(.jonico), posTonica: PosicionTraste(cuerda: 6, traste: 2),
                    incrementos: [Incremento(cuerda: 0, traste: 0), Incremento(cuerda: 0, traste: 2), Incremento(cuerda: 0, traste: 4),
                                  Incremento(cuerda: -1, traste: 0), Incremento(cuerda: -1, traste: 2), Incremento(cuerda: -1, traste: 4),
                                  Incremento(cuerda: -2, traste: 1), Incremento(cuerda: -2, traste: 2), Incremento(cuerda: -2, traste: 4),
                                  Incremento(cuerda: -3, traste: 1), Incremento(cuerda: -3, traste: 2), Incremento(cuerda: -3, traste: 4),
                                  Incremento(cuerda: -4, traste: 2), Incremento(cuerda: -4, traste: 4),
                                  Incremento(cuerda: -5, traste: 0), Incremento(cuerda: -5, traste: 2), Incremento(cuerda: -5, traste: 4),
        ])
        escalaJonicaRaizBordonD1.nombre = "Escala mayor"
        escalaJonicaRaizBordonD1.descripcion = "Escala mayor con tónica en sexta y dedo 1"
        escalaJonicaRaizBordonD1.dedo = 1
        
        let escalaJonicaRaizBordonD2: Patron = Patron(tipo: .escala(.jonico), posTonica: PosicionTraste(cuerda: 6, traste: 3),
                    incrementos: [Incremento(cuerda: 0, traste: 0), Incremento(cuerda: 0, traste: 2),
                    Incremento(cuerda: -1, traste: -1), Incremento(cuerda: -1, traste: 0), Incremento(cuerda: -1, traste: 2),
                    Incremento(cuerda: -2, traste: -1), Incremento(cuerda: -2, traste: 1), Incremento(cuerda: -2, traste: 2),
                    Incremento(cuerda: -3, traste: -1), Incremento(cuerda: -3, traste: 1), Incremento(cuerda: -3, traste: 2),
                    Incremento(cuerda: -4, traste: 0), Incremento(cuerda: -4, traste: 2),
                    Incremento(cuerda: -5, traste: -1), Incremento(cuerda: -5, traste: 0), Incremento(cuerda: -5, traste: 2),
                                                                  ])
        escalaJonicaRaizBordonD2.nombre = "Escala mayor"
        escalaJonicaRaizBordonD2.descripcion = "Escala mayor con tónica en sexta y dedo 2"
        escalaJonicaRaizBordonD2.dedo = 2
        
        let escalaJonicaRaizBordonD4: Patron = Patron(tipo: .escala(.jonico), posTonica: PosicionTraste(cuerda: 6, traste: 5),
                    incrementos: [Incremento(cuerda: 0, traste: 0),
                    Incremento(cuerda: -1, traste: -3), Incremento(cuerda: -1, traste: -1), Incremento(cuerda: -1, traste: 0),
                    Incremento(cuerda: -2, traste: -3), Incremento(cuerda: -2, traste: -1), Incremento(cuerda: -2, traste: 1),
                    Incremento(cuerda: -3, traste: -3), Incremento(cuerda: -3, traste: -1),
                    Incremento(cuerda: -4, traste: -3), Incremento(cuerda: -4, traste: -2), Incremento(cuerda: -4, traste: 0),
                    Incremento(cuerda: -5, traste: -3), Incremento(cuerda: -5, traste: -1), Incremento(cuerda: -5, traste: 0),
                                                                             ])

        escalaJonicaRaizBordonD4.nombre = "Escala mayor"
        escalaJonicaRaizBordonD4.descripcion = "Escala mayor con tónica en sexta y dedo 4"
        escalaJonicaRaizBordonD4.dedo = 4
        
        
        
        let escalaJonicaRaizQuintaD1: Patron = Patron(tipo: .escala(.jonico), posTonica: PosicionTraste(cuerda: 5, traste: 2),
                    incrementos: [Incremento(cuerda: 0, traste: 0), Incremento(cuerda: 0, traste: 2), Incremento(cuerda: 0, traste: 4),
                                Incremento(cuerda: -1, traste: 0), Incremento(cuerda: -1, traste: 2), Incremento(cuerda: -1, traste: 4),
                                Incremento(cuerda: -2, traste: 1), Incremento(cuerda: -2, traste: 2), Incremento(cuerda: -2, traste: 4),
                                Incremento(cuerda: -3, traste: 2), Incremento(cuerda: -3, traste: 3),
                                Incremento(cuerda: -4, traste: 0), Incremento(cuerda: -4, traste: 2), Incremento(cuerda: -4, traste: 4)
                        ])
        escalaJonicaRaizQuintaD1.nombre = "Escala mayor"
        escalaJonicaRaizQuintaD1.descripcion = "Escala mayor con tónica en quinta y dedo 1"
        escalaJonicaRaizQuintaD1.dedo = 1
        
        
        let escalaJonicaRaizQuintaD2: Patron = Patron(tipo: .escala(.jonico), posTonica: PosicionTraste(cuerda: 6, traste: 3),
                    incrementos: [Incremento(cuerda: 0, traste: 0), Incremento(cuerda: 0, traste: 2),
                                Incremento(cuerda: -1, traste: -1), Incremento(cuerda: -1, traste: 0), Incremento(cuerda: -1, traste: 2),
                                Incremento(cuerda: -2, traste: -1), Incremento(cuerda: -2, traste: 1), Incremento(cuerda: -2, traste: 2),
                                Incremento(cuerda: -3, traste: 0), Incremento(cuerda: -3, traste: 2),
                                Incremento(cuerda: -4, traste: -2), Incremento(cuerda: -4, traste: 0), Incremento(cuerda: -4, traste: 2)
                            ])
        escalaJonicaRaizQuintaD2.nombre = "Escala mayor"
        escalaJonicaRaizQuintaD2.descripcion = "Escala mayor con tónica en quinta y dedo 2"
        escalaJonicaRaizQuintaD2.dedo = 2
        
        let escalaJonicaRaizQuintaD4: Patron = Patron(tipo: .escala(.jonico), posTonica: PosicionTraste(cuerda: 6, traste: 2),
                    incrementos: [Incremento(cuerda: 0, traste: 0), Incremento(cuerda: 0, traste: 2), Incremento(cuerda: 0, traste: 4),
                    Incremento(cuerda: -1, traste: 0), Incremento(cuerda: -1, traste: 2), Incremento(cuerda: -1, traste: 4),
                    Incremento(cuerda: -2, traste: 1), Incremento(cuerda: -2, traste: 2), Incremento(cuerda: -2, traste: 4),
                    Incremento(cuerda: -3, traste: 1), Incremento(cuerda: -3, traste: 2), Incremento(cuerda: -3, traste: 4),
                    Incremento(cuerda: -4, traste: 2), Incremento(cuerda: -4, traste: 4),
                    Incremento(cuerda: -5, traste: 0), Incremento(cuerda: -5, traste: 2), Incremento(cuerda: -5, traste: 4),
                                                                  ])
        escalaJonicaRaizQuintaD4.nombre = "Escala mayor"
        escalaJonicaRaizQuintaD4.descripcion = "Escala mayor con tónica en quinta y dedo 4"
        escalaJonicaRaizQuintaD4.dedo = 4
        
      
        escalas.append(escalaJonicaRaizBordonD1)
        escalas.append(escalaJonicaRaizBordonD2)
        escalas.append(escalaJonicaRaizBordonD4)
        escalas.append(escalaJonicaRaizQuintaD1)
        escalas.append(escalaJonicaRaizQuintaD2)
        escalas.append(escalaJonicaRaizQuintaD4)
       
    }
}



