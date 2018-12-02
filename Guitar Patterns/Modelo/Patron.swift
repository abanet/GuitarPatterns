//
//  Posicion.swift
//  Guitar Patterns
//
//  Created by Alberto Banet Masa on 16/11/2018.
//  Copyright © 2018 Alberto Banet Masa. All rights reserved.
//

import Foundation
import UIKit



enum TipoPatron {
    case escala (TipoEscala)
    case arpegio (TipoAcorde)
    case acorde (TipoAcorde)
    case bordadura
    case sextas
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
        case .bordadura:
            break
        case .sextas:
            break
        }
        
        switch tipo {
        case .escala(let modo):
            self.intervalica = Escala(modo: modo).intervalica
        default:
            self.intervalica = Escala(modo: .jonico).intervalica 
        }
        
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
    
    var escalas: [Patron] = [Patron]()
    var arpegios: [Patron] = [Patron]()
    var acordes: [Patron] = [Patron]()
    var bordaduras: [Patron] = [Patron]()
    var sextas: [Patron] = [Patron]()
    
    var diccionarioEscalas : [TipoEscala: [Patron]] =  [TipoEscala: [Patron]] ()
    
    init() {
        self.incorporarPatronesEscalas()
    }
    
    mutating func incorporarPatronesEscalas() {
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
        
        
        let escalaJonicaRaizQuintaD2: Patron = Patron(tipo: .escala(.jonico), posTonica: PosicionTraste(cuerda: 5, traste: 3),
                    incrementos: [Incremento(cuerda: 0, traste: 0), Incremento(cuerda: 0, traste: 2),
                                Incremento(cuerda: -1, traste: -1), Incremento(cuerda: -1, traste: 0), Incremento(cuerda: -1, traste: 2),
                                Incremento(cuerda: -2, traste: -1), Incremento(cuerda: -2, traste: 1), Incremento(cuerda: -2, traste: 2),
                                Incremento(cuerda: -3, traste: 0), Incremento(cuerda: -3, traste: 2),
                                Incremento(cuerda: -4, traste: -2), Incremento(cuerda: -4, traste: 0), Incremento(cuerda: -4, traste: 2)
                            ])
        escalaJonicaRaizQuintaD2.nombre = "Escala mayor"
        escalaJonicaRaizQuintaD2.descripcion = "Escala mayor con tónica en quinta y dedo 2"
        escalaJonicaRaizQuintaD2.dedo = 2
        
        let escalaJonicaRaizQuintaD4: Patron = Patron(tipo: .escala(.jonico), posTonica: PosicionTraste(cuerda: 5, traste: 5),
                    incrementos: [Incremento(cuerda: 0, traste: 0),
                    Incremento(cuerda: -1, traste: -3), Incremento(cuerda: -1, traste: -1), Incremento(cuerda: -1, traste: 0),
                    Incremento(cuerda: -2, traste: -1), Incremento(cuerda: -2, traste: -3),
                    Incremento(cuerda: -3, traste: -3), Incremento(cuerda: -3, traste: -1), Incremento(cuerda: -3, traste: 0),
                    Incremento(cuerda: -4, traste: -3), Incremento(cuerda: -4, traste: -1),
                    Incremento(cuerda: -4, traste: 0)
                  ])
        escalaJonicaRaizQuintaD4.nombre = "Escala mayor"
        escalaJonicaRaizQuintaD4.descripcion = "Escala mayor con tónica en quinta y dedo 4"
        escalaJonicaRaizQuintaD4.dedo = 4
        
      
        // Patron pentatonica mayor
        let pentatonicaMayor1: Patron = Patron(tipo: .escala(.pentatonicaMayor), posTonica: PosicionTraste(cuerda: 6, traste: 3),
                incrementos: [Incremento(cuerda: 0, traste: 0), Incremento(cuerda: 0, traste: 2),
                              Incremento(cuerda: -1, traste: -1), Incremento(cuerda: -1, traste: 2),
                              Incremento(cuerda: -2, traste: -1), Incremento(cuerda: -2, traste: 2),
                              Incremento(cuerda: -3, traste: -1), Incremento(cuerda: -3, traste: 1),
                              Incremento(cuerda: -4, traste: 0), Incremento(cuerda: -4, traste: 2),
                              Incremento(cuerda: -5, traste: 0), Incremento(cuerda: -5, traste: 2)
            ])
        pentatonicaMayor1.nombre = "Escala Pentatónica mayor"
        pentatonicaMayor1.descripcion = "Escala Pentatónica mayor"
        pentatonicaMayor1.dedo = 2 // se ataca la posición con el segundo dedo
        
        let pentatonicaMayor2: Patron = Patron(tipo: .escala(.pentatonicaMayor), posTonica: PosicionTraste(cuerda: 4, traste: 3), incrementos: [Incremento(cuerda: 0, traste: 0), Incremento(cuerda: 0, traste: 2),
                        Incremento(cuerda: -1, traste: -1), Incremento(cuerda: -1, traste: 2),
                        Incremento(cuerda: -2, traste: 0), Incremento(cuerda: -2, traste: 3),
                        Incremento(cuerda: -3, traste: 0), Incremento(cuerda: -3, traste: 2),
                        Incremento(cuerda: 1, traste: 0), Incremento(cuerda: 1, traste: 2),
                        Incremento(cuerda: 2, traste: 0), Incremento(cuerda: 2, traste: 2)
                    ])
        pentatonicaMayor2.nombre = "Escala Pentatónica mayor - Segundo patrón"
        pentatonicaMayor2.descripcion = "Escala Pentatónica mayor  - Segundo patrón"
        pentatonicaMayor2.dedo = 2 // se ataca la posición con el segundo dedo
   
        let pentatonicaMayor3: Patron = Patron(tipo: .escala(.pentatonicaMayor), posTonica: PosicionTraste(cuerda: 5, traste: 5), incrementos: [Incremento(cuerda: 0, traste: 0), Incremento(cuerda: 0, traste: -3),                                             Incremento(cuerda: -1, traste: -3), Incremento(cuerda: -1, traste: -1),
            Incremento(cuerda: -2, traste: -3), Incremento(cuerda: -2, traste: -1),
            Incremento(cuerda: -3, traste: -2), Incremento(cuerda: -3, traste: 0),
            Incremento(cuerda: -4, traste: -3), Incremento(cuerda: -4, traste: 0),
            Incremento(cuerda: 1, traste: -3), Incremento(cuerda: 1, traste: 0)
        ])
        pentatonicaMayor3.nombre = "Escala Pentatónica mayor - Tercer patrón"
        pentatonicaMayor3.descripcion = "Escala Pentatónica mayor  - Tercer patrón"
        pentatonicaMayor3.dedo = 1 // se ataca la posición con el primer dedo
        
        
        let pentatonicaMayor4: Patron = Patron(tipo: .escala(.pentatonicaMayor), posTonica: PosicionTraste(cuerda: 5, traste: 3), incrementos: [Incremento(cuerda: 0, traste: 0), Incremento(cuerda: 0, traste: 2),                                             Incremento(cuerda: -1, traste: -1), Incremento(cuerda: -1, traste: 2),
            Incremento(cuerda: -2, traste: -1), Incremento(cuerda: -2, traste: 2),
            Incremento(cuerda: -3, traste: 0), Incremento(cuerda: -3, traste: 2),
            Incremento(cuerda: -4, traste: 0), Incremento(cuerda: -4, traste: 2),
            Incremento(cuerda: 1, traste: 0), Incremento(cuerda: 1, traste: 2)
            ])
        pentatonicaMayor4.nombre = "Escala Pentatónica mayor - Cuarto patrón"
        pentatonicaMayor4.descripcion = "Escala Pentatónica mayor  - Cuarto patrón"
        pentatonicaMayor4.dedo = 2 // se ataca la posición con el primer dedo
        
        
        let pentatonicaMayor5: Patron = Patron(tipo: .escala(.pentatonicaMayor), posTonica: PosicionTraste(cuerda: 6, traste: 5), incrementos: [Incremento(cuerda: 0, traste: 0), Incremento(cuerda: 0, traste: -3),                                             Incremento(cuerda: -1, traste: -3), Incremento(cuerda: -1, traste: -1),
            Incremento(cuerda: -2, traste: -3), Incremento(cuerda: -2, traste: -1),
            Incremento(cuerda: -3, traste: -3), Incremento(cuerda: -3, traste: -1),
            Incremento(cuerda: -4, traste: -3), Incremento(cuerda: -4, traste: 0),
            Incremento(cuerda: -5, traste: -3), Incremento(cuerda: -5, traste: 0)
            ])
        pentatonicaMayor5.nombre = "Escala Pentatónica mayor - Quinto patrón"
        pentatonicaMayor5.descripcion = "Escala Pentatónica mayor  - Quinto patrón"
        pentatonicaMayor5.dedo = 1 // se ataca la posición con el primer dedo
        
        
        // Patron pentatonica mayor de blues
        let pentatonicaMayorBlues1: Patron = Patron(tipo: .escala(.pentatonicaMayorBlues), posTonica: PosicionTraste(cuerda: 6, traste: 3),
                    incrementos: [Incremento(cuerda: 0, traste: 0), Incremento(cuerda: 0, traste: 2), Incremento(cuerda: 0, traste: 3),
                    Incremento(cuerda: -1, traste: -2),Incremento(cuerda: -1, traste: -1), Incremento(cuerda: -1, traste: 2),
                    Incremento(cuerda: -2, traste: -1), Incremento(cuerda: -2, traste: 2),
                    Incremento(cuerda: -3, traste: -1), Incremento(cuerda: -3, traste: 0), Incremento(cuerda: -3, traste: 1),
                    Incremento(cuerda: -4, traste: 0), Incremento(cuerda: -4, traste: 2),
                    Incremento(cuerda: -5, traste: 0), Incremento(cuerda: -5, traste: 2), Incremento(cuerda: -5, traste: 3)
            ])
        pentatonicaMayorBlues1.nombre = "Escala Pentatónica mayor de Blues"
        pentatonicaMayorBlues1.descripcion = "Escala Pentatónica mayor de Blues"
        pentatonicaMayorBlues1.dedo = 2 // se ataca la posición con el segundo dedo
        
        let pentatonicaMayorBlues2: Patron = Patron(tipo: .escala(.pentatonicaMayorBlues), posTonica: PosicionTraste(cuerda: 4, traste: 3),
                    incrementos: [Incremento(cuerda: 0, traste: 0), Incremento(cuerda: 0, traste: 2), Incremento(cuerda: 0, traste: 3),
                    Incremento(cuerda: -1, traste: -1), Incremento(cuerda: -1, traste: 2),
                    Incremento(cuerda: -2, traste: 0), Incremento(cuerda: -2, traste: 3),
                    Incremento(cuerda: -3, traste: 0), Incremento(cuerda: -3, traste: 1),Incremento(cuerda: -3, traste: 2),
                    Incremento(cuerda: 1, traste: 0), Incremento(cuerda: 1, traste: 2),
                    Incremento(cuerda: 2, traste: 0), Incremento(cuerda: 2, traste: 1),Incremento(cuerda: 2, traste: 2)
            ])
        pentatonicaMayorBlues2.nombre = "Escala Pentatónica mayor de Blues - Segundo patrón"
        pentatonicaMayorBlues2.descripcion = "Escala Pentatónica mayor de Blues  - Segundo patrón"
        pentatonicaMayorBlues2.dedo = 2 // se ataca la posición con el segundo dedo
        
        let pentatonicaMayorBlues3: Patron = Patron(tipo: .escala(.pentatonicaMayorBlues), posTonica: PosicionTraste(cuerda: 5, traste: 5),
                    incrementos: [Incremento(cuerda: 0, traste: 0), Incremento(cuerda: 0, traste: -3),                                             Incremento(cuerda: -1, traste: -3), Incremento(cuerda: -1, traste: -1),
                        Incremento(cuerda: -2, traste: -3), Incremento(cuerda: -2, traste: -2),Incremento(cuerda: -2, traste: -1),
                        Incremento(cuerda: -3, traste: -2), Incremento(cuerda: -3, traste: 0), Incremento(cuerda: -3, traste: 1),
                        Incremento(cuerda: -4, traste: -3), Incremento(cuerda: -4, traste: 0),
                        Incremento(cuerda: 1, traste: -3), Incremento(cuerda: 1, traste: 0)
            ])
        pentatonicaMayorBlues3.nombre = "Escala Pentatónica mayor de Blues - Tercer patrón"
        pentatonicaMayorBlues3.descripcion = "Escala Pentatónica mayor de Blues  - Tercer patrón"
        pentatonicaMayorBlues3.dedo = 1 // se ataca la posición con el primer dedo
        
        
        let pentatonicaMayorBlues4: Patron = Patron(tipo: .escala(.pentatonicaMayorBlues), posTonica: PosicionTraste(cuerda: 5, traste: 3),
                    incrementos: [Incremento(cuerda: 0, traste: 0), Incremento(cuerda: 0, traste: 2), Incremento(cuerda: 0, traste: 3),                                           Incremento(cuerda: -1, traste: -1), Incremento(cuerda: -1, traste: 2),
                        Incremento(cuerda: -2, traste: -1), Incremento(cuerda: -2, traste: 2),
                        Incremento(cuerda: -3, traste: 0), Incremento(cuerda: -3, traste: 1), Incremento(cuerda: -3, traste: 2),
                        Incremento(cuerda: -4, traste: 0), Incremento(cuerda: -4, traste: 2),
                        Incremento(cuerda: 1, traste: 0), Incremento(cuerda: 1, traste: 2)
            ])
        pentatonicaMayorBlues4.nombre = "Escala Pentatónica mayor de Blues - Cuarto patrón"
        pentatonicaMayorBlues4.descripcion = "Escala Pentatónica mayor de Blues - Cuarto patrón"
        pentatonicaMayorBlues4.dedo = 2 // se ataca la posición con el primer dedo
        
        
        let pentatonicaMayorBlues5: Patron = Patron(tipo: .escala(.pentatonicaMayorBlues), posTonica: PosicionTraste(cuerda: 6, traste: 5),
                    incrementos: [Incremento(cuerda: 0, traste: 0), Incremento(cuerda: 0, traste: -3),                                             Incremento(cuerda: -1, traste: -3), Incremento(cuerda: -1, traste: -2), Incremento(cuerda: -1, traste: -1),
                        Incremento(cuerda: -2, traste: -3), Incremento(cuerda: -2, traste: -1),
                        Incremento(cuerda: -3, traste: -3), Incremento(cuerda: -3, traste: -1), Incremento(cuerda: -3, traste: 0),
                        Incremento(cuerda: -4, traste: -3), Incremento(cuerda: -4, traste: 0),
                        Incremento(cuerda: -5, traste: -3), Incremento(cuerda: -5, traste: 0)
            ])
        pentatonicaMayorBlues5.nombre = "Escala Pentatónica mayor de Blues- Quinto patrón"
        pentatonicaMayorBlues5.descripcion = "Escala Pentatónica mayor de Blues - Quinto patrón"
        pentatonicaMayorBlues5.dedo = 1 // se ataca la posición con el primer dedo
        
        // Pentatónica menor
        let pentatonicaMenor1: Patron = Patron(tipo: .escala(.pentatonicaMenor), posTonica: PosicionTraste(cuerda: 6, traste: 2),
                incrementos: [Incremento(cuerda: 0, traste: 0), Incremento(cuerda: 0, traste: 3),                                             Incremento(cuerda: -1, traste: 0), Incremento(cuerda: -1, traste: 2),
                    Incremento(cuerda: -2, traste: 0), Incremento(cuerda: -2, traste: 2),
                    Incremento(cuerda: -3, traste: 0), Incremento(cuerda: -3, traste: 2),
                    Incremento(cuerda: -4, traste: 0), Incremento(cuerda: -4, traste: 3),
                    Incremento(cuerda: -5, traste: 0), Incremento(cuerda: -5, traste: 3)
            ])
        pentatonicaMenor1.nombre = "Escala Pentatónica menor"
        pentatonicaMenor1.descripcion = "Escala Pentatónica menor"
        pentatonicaMenor1.dedo = 1 // se ataca la posición con el primer dedo
        
        let pentatonicaMenor2: Patron = Patron(tipo: .escala(.pentatonicaMenor), posTonica: PosicionTraste(cuerda: 4, traste: 2),
            incrementos: [Incremento(cuerda: 0, traste: 0), Incremento(cuerda: 0, traste: 3),                                             Incremento(cuerda: -1, traste: 0), Incremento(cuerda: -1, traste: 2),
                Incremento(cuerda: -2, traste: 1), Incremento(cuerda: -2, traste: 3),
                Incremento(cuerda: -3, traste: 1), Incremento(cuerda: -3, traste: 3),
                Incremento(cuerda: 1, traste: 0), Incremento(cuerda: 1, traste: 3),
                Incremento(cuerda: 2, traste: 1), Incremento(cuerda: 2, traste: 3)
            ])
        pentatonicaMenor2.nombre = "Escala Pentatónica menor - segundo patrón"
        pentatonicaMenor2.descripcion = "Escala Pentatónica menor - segundo patrón"
        pentatonicaMenor2.dedo = 2 // se ataca la posición con el primer dedo
        
        let pentatonicaMenor3: Patron = Patron(tipo: .escala(.pentatonicaMenor), posTonica: PosicionTraste(cuerda: 5, traste: 4),
                incrementos: [Incremento(cuerda: 0, traste: 0), Incremento(cuerda: 0, traste: -2),                                             Incremento(cuerda: -1, traste: 0), Incremento(cuerda: -1, traste: -2),
                    Incremento(cuerda: -2, traste: -3), Incremento(cuerda: -2, traste: 0),
                    Incremento(cuerda: -3, traste: -2), Incremento(cuerda: -3, traste: 1),
                    Incremento(cuerda: -4, traste: -2), Incremento(cuerda: -4, traste: 0),
                    Incremento(cuerda: 1, traste: -2), Incremento(cuerda: 1, traste: 0)
            ])
        pentatonicaMenor3.nombre = "Escala Pentatónica menor - tercer patrón"
        pentatonicaMenor3.descripcion = "Escala Pentatónica menor - tercer patrón"
        pentatonicaMenor3.dedo = 1 // se ataca la posición con el primer dedo
        
        let pentatonicaMenor4: Patron = Patron(tipo: .escala(.pentatonicaMenor), posTonica: PosicionTraste(cuerda: 5, traste: 2),
                incrementos: [Incremento(cuerda: 0, traste: 0), Incremento(cuerda: 0, traste: 3),                                             Incremento(cuerda: -1, traste: 0), Incremento(cuerda: -1, traste: 2),
                    Incremento(cuerda: -2, traste: 0), Incremento(cuerda: -2, traste: 2),
                    Incremento(cuerda: -3, traste: 1), Incremento(cuerda: -3, traste: 3),
                    Incremento(cuerda: -4, traste: 0), Incremento(cuerda: -4, traste: 3),
                    Incremento(cuerda: 1, traste: 0), Incremento(cuerda: 1, traste: 3)
            ])
        pentatonicaMenor4.nombre = "Escala Pentatónica menor - cuarto patrón"
        pentatonicaMenor4.descripcion = "Escala Pentatónica menor - cuarto patrón"
        pentatonicaMenor4.dedo = 1 // se ataca la posición con el primer dedo
        
        let pentatonicaMenor5: Patron = Patron(tipo: .escala(.pentatonicaMenor), posTonica: PosicionTraste(cuerda: 6, traste: 4),
                incrementos: [Incremento(cuerda: 0, traste: 0), Incremento(cuerda: 0, traste: -2),                                             Incremento(cuerda: -1, traste: -2), Incremento(cuerda: -1, traste: 0),
                    Incremento(cuerda: -2, traste: -3), Incremento(cuerda: -2, traste: 0),
                    Incremento(cuerda: -3, traste: -3), Incremento(cuerda: -3, traste: 0),
                    Incremento(cuerda: -4, traste: -2), Incremento(cuerda: -4, traste: 0),
                    Incremento(cuerda: -5, traste: -2), Incremento(cuerda: -5, traste: 0)
            ])
        pentatonicaMenor5.nombre = "Escala Pentatónica menor"
        pentatonicaMenor5.descripcion = "Escala Pentatónica menor"
        pentatonicaMenor5.dedo = 2 // se ataca la posición con el primer dedo
        
        // Pentatónica menor de blues
        let pentatonicaMenorBlues1: Patron = Patron(tipo: .escala(.pentatonicaMenorBlues), posTonica: PosicionTraste(cuerda: 6, traste: 2),
            incrementos: [Incremento(cuerda: 0, traste: 0), Incremento(cuerda: 0, traste: 3),                                             Incremento(cuerda: -1, traste: 0), Incremento(cuerda: -1, traste: 1), Incremento(cuerda: -1, traste: 2),
                Incremento(cuerda: -2, traste: 0), Incremento(cuerda: -2, traste: 2),
                Incremento(cuerda: -3, traste: 0), Incremento(cuerda: -3, traste: 2), Incremento(cuerda: -3, traste: 3),
                Incremento(cuerda: -4, traste: -1), Incremento(cuerda: -4, traste: 0), Incremento(cuerda: -4, traste: 3),
                Incremento(cuerda: -5, traste: 0), Incremento(cuerda: -5, traste: 3)
            ])
        pentatonicaMenorBlues1.nombre = "Escala Pentatónica menor de Blues"
        pentatonicaMenorBlues1.descripcion = "Escala Pentatónica menor de Blues"
        pentatonicaMenorBlues1.dedo = 1 // se ataca la posición con el primer dedo
        
        let pentatonicaMenorBlues2: Patron = Patron(tipo: .escala(.pentatonicaMenorBlues), posTonica: PosicionTraste(cuerda: 4, traste: 2),
            incrementos: [Incremento(cuerda: 0, traste: 0), Incremento(cuerda: 0, traste: 3),                                             Incremento(cuerda: -1, traste: 0), Incremento(cuerda: -1, traste: 1), Incremento(cuerda: -1, traste: 2),
                Incremento(cuerda: -2, traste: 1), Incremento(cuerda: -2, traste: 3),
                Incremento(cuerda: -3, traste: 1), Incremento(cuerda: -3, traste: 3), Incremento(cuerda: -3, traste: 4),
                Incremento(cuerda: 1, traste: -1), Incremento(cuerda: 1, traste: 0), Incremento(cuerda: 1, traste: 3),
                Incremento(cuerda: 2, traste: 1), Incremento(cuerda: 2, traste: 3), Incremento(cuerda: 2, traste: 4)
            ])
        pentatonicaMenorBlues2.nombre = "Escala Pentatónica menor de Blues - segundo patrón"
        pentatonicaMenorBlues2.descripcion = "Escala Pentatónica menor de Blues - segundo patrón"
        pentatonicaMenorBlues2.dedo = 2 // se ataca la posición con el primer dedo
        
        let pentatonicaMenorBlues3: Patron = Patron(tipo: .escala(.pentatonicaMenorBlues), posTonica: PosicionTraste(cuerda: 5, traste: 4),
            incrementos: [Incremento(cuerda: 0, traste: 0), Incremento(cuerda: 0, traste: -2),                                             Incremento(cuerda: -1, traste: -2), Incremento(cuerda: -1, traste: 0), Incremento(cuerda: -1, traste: 1),
                Incremento(cuerda: -2, traste: -4), Incremento(cuerda: -2, traste: -3), Incremento(cuerda: -2, traste: 0),
                Incremento(cuerda: -3, traste: -2), Incremento(cuerda: -3, traste: 1),
                Incremento(cuerda: -4, traste: -2), Incremento(cuerda: -4, traste: -1), Incremento(cuerda: -4, traste: 0),
                Incremento(cuerda: 1, traste: -2), Incremento(cuerda: 1, traste: -1), Incremento(cuerda: 1, traste: 0)
            ])
        pentatonicaMenor3.nombre = "Escala Pentatónica menor de Blues - tercer patrón"
        pentatonicaMenor3.descripcion = "Escala Pentatónica menor de Blues - tercer patrón"
        pentatonicaMenor3.dedo = 1 // se ataca la posición con el primer dedo
        
        let pentatonicaMenorBlues4: Patron = Patron(tipo: .escala(.pentatonicaMenorBlues), posTonica: PosicionTraste(cuerda: 5, traste: 2),
            incrementos: [Incremento(cuerda: 0, traste: 0), Incremento(cuerda: 0, traste: 3),                                             Incremento(cuerda: -1, traste: 0), Incremento(cuerda: -1, traste: 1), Incremento(cuerda: -1, traste: 2),
                Incremento(cuerda: -2, traste: 0), Incremento(cuerda: -2, traste: 2),
                Incremento(cuerda: -3, traste: 1), Incremento(cuerda: -3, traste: 3), Incremento(cuerda: -3, traste: 4),
                Incremento(cuerda: -4, traste: -1), Incremento(cuerda: -4, traste: 0), Incremento(cuerda: -4, traste: 3),
                Incremento(cuerda: 1, traste: -1), Incremento(cuerda: 1, traste: 0), Incremento(cuerda: 1, traste: 3)
            ])
        pentatonicaMenorBlues4.nombre = "Escala Pentatónica menor de Blues - cuarto patrón"
        pentatonicaMenorBlues4.descripcion = "Escala Pentatónica menor de Blues - cuarto patrón"
        pentatonicaMenorBlues4.dedo = 1 // se ataca la posición con el primer dedo
        
        let pentatonicaMenorBlues5: Patron = Patron(tipo: .escala(.pentatonicaMenorBlues), posTonica: PosicionTraste(cuerda: 6, traste: 5),
            incrementos: [Incremento(cuerda: 0, traste: 0), Incremento(cuerda: 0, traste: -2),                                             Incremento(cuerda: -1, traste: -2), Incremento(cuerda: -1, traste: 0), Incremento(cuerda: -1, traste: 1),
                Incremento(cuerda: -2, traste: -4), Incremento(cuerda: -2, traste: -3), Incremento(cuerda: -2, traste: 0),
                Incremento(cuerda: -3, traste: -3), Incremento(cuerda: -3, traste: 0),
                Incremento(cuerda: -4, traste: -2), Incremento(cuerda: -4, traste: -1), Incremento(cuerda: -4, traste: 0),
                Incremento(cuerda: -5, traste: -2), Incremento(cuerda: -5, traste: 0)
            ])
        pentatonicaMenorBlues5.nombre = "Escala Pentatónica menor de Blues - quinto patrón"
        pentatonicaMenorBlues5.descripcion = "Escala Pentatónica menor de Blues - quinto patrón"
        pentatonicaMenorBlues5.dedo = 2 // se ataca la posición con el primer dedo
        
        // Incorporamos todos los patrones
        escalas.append(escalaJonicaRaizBordonD1)
        escalas.append(escalaJonicaRaizBordonD2)
        escalas.append(escalaJonicaRaizBordonD4)
        escalas.append(escalaJonicaRaizQuintaD1)
        escalas.append(escalaJonicaRaizQuintaD2)
        escalas.append(escalaJonicaRaizQuintaD4)
        
        escalas.append(pentatonicaMayor1)
        escalas.append(pentatonicaMayor2)
        escalas.append(pentatonicaMayor3)
        escalas.append(pentatonicaMayor4)
        escalas.append(pentatonicaMayor5)
        
        escalas.append(pentatonicaMayorBlues1)
        escalas.append(pentatonicaMayorBlues2)
        escalas.append(pentatonicaMayorBlues3)
        escalas.append(pentatonicaMayorBlues4)
        escalas.append(pentatonicaMayorBlues5)
        
        escalas.append(pentatonicaMenor1)
        escalas.append(pentatonicaMenor2)
        escalas.append(pentatonicaMenor3)
        escalas.append(pentatonicaMenor4)
        escalas.append(pentatonicaMenor5)
        
        escalas.append(pentatonicaMenorBlues1)
        escalas.append(pentatonicaMenorBlues2)
        escalas.append(pentatonicaMenorBlues3)
        escalas.append(pentatonicaMenorBlues4)
        escalas.append(pentatonicaMenorBlues5)
        
        // Incorporamos mejor a un diccionario
        diccionarioEscalas[.jonico] = [escalaJonicaRaizBordonD1, escalaJonicaRaizBordonD2, escalaJonicaRaizBordonD4, escalaJonicaRaizQuintaD1, escalaJonicaRaizQuintaD2, escalaJonicaRaizQuintaD4]
        diccionarioEscalas[.pentatonicaMayor] = [pentatonicaMayor1, pentatonicaMayor2, pentatonicaMayor3, pentatonicaMayor4, pentatonicaMayor5]
        diccionarioEscalas[.pentatonicaMayorBlues] = [pentatonicaMayorBlues1, pentatonicaMayorBlues2, pentatonicaMayorBlues3, pentatonicaMayorBlues4, pentatonicaMayorBlues5]
       diccionarioEscalas[.pentatonicaMenor] = [pentatonicaMenor1, pentatonicaMenor2, pentatonicaMenor3, pentatonicaMenor4, pentatonicaMenor5]
        diccionarioEscalas[.pentatonicaMenorBlues] = [pentatonicaMenorBlues1, pentatonicaMenorBlues2, pentatonicaMenorBlues3, pentatonicaMenorBlues4, pentatonicaMenorBlues5]
    }
    
    
    mutating func incorporarPatronesArpegios() {
        //
        // Arpegio Maj7 Tónica en sexta cuerda, posición de dedo 1
        let arpegioMaj7BordonD1: Patron = Patron(tipo: .arpegio(.Maj7), posTonica: PosicionTraste(cuerda: 6, traste: 2),
            incrementos: [Incremento(cuerda: 0, traste: 0), Incremento(cuerda: 0, traste: 4),
                Incremento(cuerda: -1, traste: 2),
                Incremento(cuerda: -2, traste: 1), Incremento(cuerda: -2, traste: 2),
                Incremento(cuerda: -3, traste: 1), Incremento(cuerda: -3, traste: 4),
                Incremento(cuerda: -4, traste: 4),
                Incremento(cuerda: -5, traste: 0), Incremento(cuerda: -5, traste: 4),
            ])
        arpegioMaj7BordonD1.nombre = "Arpegio Maj7"
        arpegioMaj7BordonD1.descripcion = "Arpegio Maj7 con tónica en sexta y dedo 1"
        arpegioMaj7BordonD1.dedo = 1
        
        arpegios.append(arpegioMaj7BordonD1)
    }
    
    mutating func incorporarPatronesAcordes() {
        //
        // Arpegio Maj7 Tónica en sexta cuerda, posición de dedo 1
        let acordeMaj7BordonD1: Patron = Patron(tipo: .acorde(.Maj7), posTonica: PosicionTraste(cuerda: 6, traste: 2),
                        incrementos: [Incremento(cuerda: 0, traste: 0),
                        Incremento(cuerda: -2, traste: 1),
                        Incremento(cuerda: -3, traste: 1),
                        Incremento(cuerda: -4, traste: 0),
        ])
        
        acordeMaj7BordonD1.nombre = "Acorde Maj7"
        acordeMaj7BordonD1.descripcion = "Acorde Maj7 con tónica en sexta y dedo 1"
        acordeMaj7BordonD1.dedo = 1
        
        acordes.append(acordeMaj7BordonD1)
    }
    
    mutating func incorporarPatronesBordaduras(){
        
        // Bordaduras con tónica en 5 cuerda
        // 6 patrones
        // Patron 1
        let bordadura5cuerda_1: Patron = Patron(tipo: .bordadura, posTonica: PosicionTraste(cuerda: 5, traste: 2),
                                                incrementos: [Incremento(cuerda: 0, traste: 0),
                                                              Incremento(cuerda: -2, traste: 4),
                                                              Incremento(cuerda: -3, traste: 2),
                                                              Incremento(cuerda: -4, traste: 4),
                                                              ])
        
        bordadura5cuerda_1.nombre = "Bordadura con Tónica en quinta cuerda"
        bordadura5cuerda_1.descripcion = "Bordadura con Tónica en quinta cuerda - Patrón 1"
        bordaduras.append(bordadura5cuerda_1)
        
        // Patron 2
        let bordadura5cuerda_2: Patron = Patron(tipo: .bordadura, posTonica: PosicionTraste(cuerda: 5, traste: 2),
                                                incrementos: [Incremento(cuerda: 0, traste: 0),
                                                              Incremento(cuerda: -2, traste: 2),
                                                              Incremento(cuerda: -3, traste: 0),
                                                              Incremento(cuerda: -4, traste: 2),
                                                              ])
        
        bordadura5cuerda_2.nombre = "Bordadura con Tónica en quinta cuerda"
        bordadura5cuerda_2.descripcion = "Bordadura con Tónica en quinta cuerda - Patrón 2"
        bordaduras.append(bordadura5cuerda_2)
        
        // Patron 3
        let bordadura5cuerda_3: Patron = Patron(tipo: .bordadura, posTonica: PosicionTraste(cuerda: 5, traste: 3),
                                                incrementos: [Incremento(cuerda: 0, traste: 0),
                                                              Incremento(cuerda: -2, traste: 1),
                                                              Incremento(cuerda: -3, traste: -2),
                                                              Incremento(cuerda: -4, traste: 0),
                                                              ])
        
        bordadura5cuerda_3.nombre = "Bordadura con Tónica en quinta cuerda"
        bordadura5cuerda_3.descripcion = "Bordadura con Tónica en quinta cuerda - Patrón 3"
        bordaduras.append(bordadura5cuerda_3)
        
        // Patron 4
        let bordadura5cuerda_4: Patron = Patron(tipo: .bordadura, posTonica: PosicionTraste(cuerda: 5, traste: 2),
                                                incrementos: [Incremento(cuerda: 0, traste: 0),
                                                              Incremento(cuerda: -1, traste: 2),
                                                              Incremento(cuerda: -2, traste: 4),
                                                              Incremento(cuerda: -3, traste: 2),
                                                              ])
        
        bordadura5cuerda_4.nombre = "Bordadura con Tónica en quinta cuerda"
        bordadura5cuerda_4.descripcion = "Bordadura con Tónica en quinta cuerda - Patrón 4"
        bordaduras.append(bordadura5cuerda_4)
        
        // Patron 5
        let bordadura5cuerda_5: Patron = Patron(tipo: .bordadura, posTonica: PosicionTraste(cuerda: 5, traste: 3),
                                                incrementos: [Incremento(cuerda: 0, traste: 0),
                                                              Incremento(cuerda: -1, traste: -1),
                                                              Incremento(cuerda: -2, traste: 2),
                                                              Incremento(cuerda: -3, traste: 0),
                                                              ])
        
        bordadura5cuerda_5.nombre = "Bordadura con Tónica en quinta cuerda"
        bordadura5cuerda_5.descripcion = "Bordadura con Tónica en quinta cuerda - Patrón 5"
        bordaduras.append(bordadura5cuerda_5)
        
        // Patron 1
        let bordadura5cuerda_6: Patron = Patron(tipo: .bordadura, posTonica: PosicionTraste(cuerda: 5, traste: 3),
                                                incrementos: [Incremento(cuerda: 0, traste: 0),
                                                              Incremento(cuerda: -1, traste: -1),
                                                              Incremento(cuerda: -2, traste: 1),
                                                              Incremento(cuerda: -3, traste: -2),
                                                              ])
        
        bordadura5cuerda_6.nombre = "Bordadura con Tónica en quinta cuerda"
        bordadura5cuerda_6.descripcion = "Bordadura con Tónica en quinta cuerda - Patrón 6"
        bordaduras.append(bordadura5cuerda_6)
        
        
    }
    
    mutating func incorporarPatronesSextas(){
        
    }
    
}







