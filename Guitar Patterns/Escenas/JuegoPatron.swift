//
//  JuegoPatron.swift
//  Guitar Patterns
//
//  Created by Alberto Banet Masa on 19/11/2018.
//  Copyright © 2018 Alberto Banet Masa. All rights reserved.
//

import SpriteKit

class JuegoPatron: SKScene {
    var guitarra: GuitarraGrafica!  // parte gráfica del mástil
    var patron  : Patron = PatronesDdbb().escalas[1] // el único q tenemos por ahora
    let xMinimaBolas: CGFloat = 50.0
    
    var nivel: Nivel! // sustituir parámetros sueltos por esta variable de nivel
    lazy var tiempoRecorrerNotaPantalla: Double = nivel.tiempoRecorrerPantalla

    var objetivos: [String]  = [String]()
    var notasObjetivo: [SKShapeNode] = [SKShapeNode]()
    var ultimoObjetivoEscogido: String = "" // evitar q salgan dos intervalos objetivo seguidos
    
    var lastUpdateTime: TimeInterval = 0
    var dt: TimeInterval = 0
    
    
    var posicionInicial: CGPoint!
    var hud = HUD()
    
    
    var radius: CGFloat { // radio de la nota en el corredor
        get {
            //return (Medidas.topSpace) / 3
            return (Medidas.porcentajeTopSpace * size.height) / 5
        }
    }
    
    // MARK: Ciclo de vida de la escena
    
    init(size: CGSize, nivel: Nivel) {
        self.nivel = nivel
        super.init(size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMove(to view: SKView) {
        prepararSonidos()
        iniciarGuitarra()
        dibujarPatron()
        if let nombre = patron.descripcion {
            addTitulo(nombre)
        }
        //self.posicionInicial =  CGPoint(x: size.width + Medidas.marginSpace, y: (size.height - Medidas.topSpace) ) // comienza fuera de la pantalla
       self.posicionInicial =  CGPoint(x: size.width + Medidas.marginSpace, y: (size.height - Medidas.porcentajeTopSpace * size.height + 16))
        activarSalidaNotas()
        
        
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Calcular el deltaTime
        if lastUpdateTime > 0 {
            dt = currentTime - lastUpdateTime
        } else {
            dt = 0
        }
        lastUpdateTime = currentTime
        
        comprobarDestruccionNodos()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {
            return
        }
        let touchPosition = touch.location(in: self)
        let touchedNodes = nodes(at: touchPosition)
        for node in touchedNodes {
            if let mynode = node as? ShapeNote, node.name == "nota", mynode.getTagShapeNote() != "T" {
                // si hemos acertado sumar un punto y eliminar la primera nota
                if let textoEnNota = mynode.getTagShapeNote(), textoEnNota == objetivos[0] {
                    // Marcar en verde como que está acertada pero hay q comprobar que no queden más
                    mynode.fillColor = SKColor.green
                    mynode.name = "notaAcertada"
                    hacerSonarNotaConTonica(mynode)
                    if !quedanNotas(withText: textoEnNota) {
                        // se acertaron todas, eliminar notaObjetivo y restaurar mástil para que todas las notas sean "nota"
                        objetivos.remove(at: 0)
                        if let nota = notasObjetivo.first {
                            nota.removeFromParent()
                            notasObjetivo.remove(at: 0)
                        }
                        let espera = SKAction.wait(forDuration: 0.8)
                        run(espera) {
                            self.restaurarNombresNotasEnMastil()
                        }
                    } else {
                        // aún quedan notas por acertar
                    }
                    
                } else {
                    // colorear en gris para que se vea que se ha utilizado (modo ayuda on)
                    mynode.fillColor = Colores.fallo
                    mynode.name = "notaFallada"
                }
                //mynode.fillColor = Colores.noteFillResaltada
            }
        }
    }
    
    // MARK: Generación de objetivos (spawnEnemy)
    func activarSalidaNotas() {
        let periodo = Double((CGFloat(tiempoRecorrerNotaPantalla) * (radius * 4)) / size.width)
        run(SKAction.repeatForever(
            SKAction.sequence([SKAction.run() { [weak self] in
                self?.spawnNota()
                },
            SKAction.wait(forDuration: periodo)])))
    }
    
    func spawnNota() {
        let contenidoAzar = obtenerObjetivo()
        objetivos.append(contenidoAzar)
        let nota = drawCircleAt(point: CGPoint.zero, withRadius: radius, withText: contenidoAzar)
        //nota.physicsBody = SKPhysicsBody(circleOfRadius: radius)
        //nota.physicsBody?.affectedByGravity = false
        nota.position = posicionInicial
        addChild(nota)
        notasObjetivo.append(nota)
        let actionMove = SKAction.moveTo(x: 0, duration: tiempoRecorrerNotaPantalla)
        nota.run(actionMove)
    }
    
    // Obtiene al azar un intervalo (de momento, en un futuro también nota según en que modo se esté de juego nota) del patrón.
    func obtenerObjetivo() -> String  {
        let objetivosPosibles = patron.intervalica
        var objetivoElegido: String
        repeat {
            let pos = Int.random(in: 0..<objetivosPosibles.count)
            objetivoElegido = patron.intervalica[pos].rawValue
        } while objetivoElegido == ultimoObjetivoEscogido
        ultimoObjetivoEscogido = objetivoElegido
        return objetivoElegido
    }
    
    func comprobarDestruccionNodos() {
        enumerateChildNodes(withName: "objetivo") {[unowned self] (node, _) in
            if node.position.x < self.xMinimaBolas { // Punto x tope para las bolas
                let explosion = self.explosion(intensity: 2.0)
                explosion.position = node.position
                self.addChild(explosion)
                self.run(self.dropBomb)
                node.removeFromParent()
                self.notasObjetivo.remove(at: 0)
            }
        }
    }
    
    // devuelve true si quedan notas marcadas como "nota" con el texto pasado como parámetro
    func quedanNotas(withText text: String) -> Bool {
        for child in guitarra.children {
            if let nodo = child as? ShapeNote, nodo.name == "nota" {
                if nodo.getTagShapeNote() == text {
                    return true
                }
            }
        }
        return false
    }
    
    // MARK: Funciones de dibujo de guitarra y elementos gráficos
    func iniciarGuitarra() {
        backgroundColor = Colores.background
        guitarra = GuitarraGrafica(size: size)
        addChild(guitarra)
    }
    
    
    
    func dibujarPatron(){
        for posicion in patron.posiciones {
            marcarNotasConIntervalo(pos: posicion, tipoEjercicio: nivel.tipo)
        }
    }
    
    func restaurarNombresNotasEnMastil() {
        for child in guitarra.children {
            if let shapeNota = child as? ShapeNote, shapeNota.name == "notaFallada" || shapeNota.name == "notaAcertada" {
                shapeNota.name = "nota"
                if shapeNota.getTagShapeNote() != nil && nivel.tipo != .alto { // contiene información de nota
                    shapeNota.fillColor = Colores.noteFillResaltada
                } else {
                    shapeNota.fillColor = Colores.noteFill
                }
            }
        }
    }
    
    func marcarNotaEnTraste(pos: PosicionTraste) {
        guitarra.enumerateChildNodes(withName: "nota") { nodoNota , _ in
            if let shapeNota = nodoNota as? ShapeNote {
                if shapeNota.posicionEnMastil == pos {
                    shapeNota.setSelected(true)
                    
                }
            }
        }
    }
    
    func marcarNotasConIntervalo(pos: PosicionTraste, tipoEjercicio: TipoNivel) {
        guitarra.enumerateChildNodes(withName: "nota") { nodoNota , _ in
            if let shapeNota = nodoNota as? ShapeNote {
                if shapeNota.posicionEnMastil == pos {
                    if tipoEjercicio == TipoNivel.bajo || tipoEjercicio == TipoNivel.medio {
                        shapeNota.setSelected(true)
                    }
                    let tonica = self.patron.getPosTonica()
                    if let intervalo = tonica.intervaloHasta(posicion: pos) {
                        if tipoEjercicio == TipoNivel.bajo {
                            shapeNota.setTextShapeNote(intervalo.rawValue)
                        }
                        shapeNota.setTagShapeNote(intervalo.rawValue)
                        shapeNota.setDistanciaDesdeTonica(valor: tonica.semitonosHasta(posicion: pos))
                        if intervalo == TipoIntervalo.octavajusta {
                            shapeNota.setTipoShapeNote(.tonica)
                        }
                    }
                }
            }
        }
    }
    
    
    
    // MARK: corredor de notas
    func drawCircleAt(point: CGPoint, withRadius radius: CGFloat, withEstilo estilo: EstiloNota = EstilosDefault.notas, withText text: String = "A") -> SKShapeNode {
        let path = CGMutablePath()
        path.addArc(center: point, radius: radius, startAngle: 0, endAngle: CGFloat.pi * 2, clockwise: true)
        let circle = SKShapeNode(path: path)
        circle.isUserInteractionEnabled = false
        circle.name = "objetivo"
        circle.lineWidth = estilo.anchoLinea
        circle.fillColor = estilo.colorRelleno
        circle.strokeColor = estilo.colorTrazo
        circle.glowWidth = 0.5
        let textLabel = SKLabelNode(fontNamed: "AvenirNext-Regular")
        textLabel.color = SKColor.green
        textLabel.text = text
        textLabel.fontSize = radius * 1.2 //factor de corrección de tamaño aplicado
        textLabel.verticalAlignmentMode = .center
        textLabel.horizontalAlignmentMode = .center
        textLabel.position = point
        circle.addChild(textLabel)
        return circle
    }
    
   
    func explosion(intensity: CGFloat) -> SKEmitterNode {
        let emitter = SKEmitterNode()
        let particleTexture = SKTexture(imageNamed: "spark")
        
        emitter.zPosition = 2
        emitter.particleTexture = particleTexture
        emitter.particleBirthRate = 4000 * intensity
        emitter.numParticlesToEmit = Int(400 * intensity)
        emitter.particleLifetime = 2.0
        emitter.emissionAngle = CGFloat(90.0).degreesToRadians()
        emitter.emissionAngleRange = CGFloat(360.0).degreesToRadians()
        emitter.particleSpeed = 600 * intensity
        emitter.particleSpeedRange = 1000 * intensity
        emitter.particleAlpha = 1.0
        emitter.particleAlphaRange = 0.25
        emitter.particleScale = 1.2
        emitter.particleScaleRange = 2.0
        emitter.particleScaleSpeed = -1.5
        emitter.particleColor = SKColor.orange
        emitter.particleColorBlendFactor = 1
        emitter.particleBlendMode = SKBlendMode.add
        emitter.run(SKAction.removeFromParentAfterDelay(2.0))
        
        return emitter
    }
    
    // MARK: Sonido
    
    // Sonidos
    let dropBomb = SKAction.playSoundFileNamed("bombDrop.wav", waitForCompletion: true)
    let sonidoC0 = SKAction.playSoundFileNamed("C0.wav", waitForCompletion: false)
    let sonidoC0s = SKAction.playSoundFileNamed("C0#.wav", waitForCompletion: false)
    let sonidoD0 = SKAction.playSoundFileNamed("D0.wav", waitForCompletion: false)
    let sonidoD0s = SKAction.playSoundFileNamed("D0#.wav", waitForCompletion: false)
    let sonidoE0 = SKAction.playSoundFileNamed("E0.wav", waitForCompletion: false)
    let sonidoF0 = SKAction.playSoundFileNamed("F0.wav", waitForCompletion: false)
    let sonidoF0s = SKAction.playSoundFileNamed("F0#.wav", waitForCompletion: false)
    let sonidoG0 = SKAction.playSoundFileNamed("G0.wav", waitForCompletion: false)
    let sonidoG0s = SKAction.playSoundFileNamed("G0#.wav", waitForCompletion: false)
    let sonidoA0 = SKAction.playSoundFileNamed("A0.wav", waitForCompletion: false)
    let sonidoA0s = SKAction.playSoundFileNamed("A0#.wav", waitForCompletion: false)
    let sonidoB0 = SKAction.playSoundFileNamed("B0.wav", waitForCompletion: false)
    var sonidos = [SKAction]()
    
    func prepararSonidos() {
    sonidos = [sonidoC0, sonidoC0s, sonidoD0, sonidoD0s, sonidoE0, sonidoF0, sonidoF0s, sonidoG0, sonidoG0s, sonidoA0, sonidoA0s, sonidoB0]
    }
    
    func hacerSonarNota(_ nodoNota: ShapeNote) {
        if let distanciaTonica = nodoNota.getDistanciaDesdeTonica() {
            let distancia = distanciaTonica % 12    // TODO: Crear toda la gama de sonidos para que cada nota tenga su propio sonido.
            run(sonidos[distancia])
        }
    }
    
    func hacerSonarNotaConTonica(_ nodoNota: ShapeNote) {
        if let distanciaTonica = nodoNota.getDistanciaDesdeTonica() {
            let distancia = distanciaTonica % 12    // TODO: Crear toda la gama de sonidos para que cada nota tenga su propio sonido.
            let secuenciaSonidos = SKAction.sequence([sonidos[0], SKAction.wait(forDuration: 0.4), sonidos[distancia]])
            run(secuenciaSonidos)
        }
    }
    
    
    // MARK: Cuadro de mandos y puntuación
    func addTitulo(_ titulo: String) {
        let tituloNodo = SKLabelNode(fontNamed: "AvenirNext-Regular")
        tituloNodo.text = titulo
        tituloNodo.name = "titulo"
        tituloNodo.fontSize = 22
        tituloNodo.fontColor = Colores.indicaciones
        tituloNodo.preferredMaxLayoutWidth = size.width - Medidas.marginSpace
        tituloNodo.numberOfLines = 0
        tituloNodo.verticalAlignmentMode = .center
        tituloNodo.horizontalAlignmentMode = .center
        tituloNodo.position = CGPoint(x:view!.frame.width / 2, y: view!.frame.height - 16)
        addChild(tituloNodo)
    }
    
    // MARK: HUD Setup
    func setupHUD(){
        hud.addTimer(time: Int(nivel!.tiempoJuego))
    }
    
}


/**
 * Define un nivel de dificultad en el juego del reconocimiento de patrones
 *
 * La dificultad del juego se basa diferentes parámetros:
 * - fácil: las notas o intervalos aparecen escritas en el patrón
 * - medio: las notas o intervalos aparecen coloreados pero sin texto
 * - alto : sólo aparecen las tónicas
 * - muy alto: sólo aparece una tónica
 *
 * Además en cada uno de estos tipos la dificultad se ve también afectada por:
 * - la velocidad de desplazamiento de las notas
 * - número de vidas (o bolas que dejamos explotar)
 * - tiempo que tenemos que aguantar en el nivel
 */

enum TipoNivel: Int {
    case bajo = 0, medio, alto
}


class Nivel {
    
    static let tiempoMinimoRecorrerPantalla: Double = 20.0  // Indica la velocidad máxima de la bola
    static let segundosParaIncrementoVelocidad: Double = 3  // Indica los segundos para incrementar la velocidad
    static let incrementoVelocidad: Int = -2   // Habrá 2 segundos menos para que la bola recorra la pantalla
    
    var tipo: TipoNivel
    var tiempoRecorrerPantalla: TimeInterval
    var tiempoJuego: TimeInterval // Tiempo para completar cambio de nivel. 0 para tiempo infinito
    var mostrarTodasLasTonicas: Bool
    
    init(tipo: TipoNivel, tiempoPantalla: TimeInterval, tiempoJuego: TimeInterval, mostrarTonicas: Bool) {
        self.tipo = tipo
        self.tiempoRecorrerPantalla = tiempoPantalla
        self.tiempoJuego = tiempoJuego
        self.mostrarTodasLasTonicas = mostrarTonicas
    }
    
    convenience init(tipo: TipoNivel, tiempoPantalla: TimeInterval) {
        self.init(tipo: tipo, tiempoPantalla: tiempoPantalla, tiempoJuego: 0, mostrarTonicas: true)
    }
    
    
    
    // Algunos niveles para probar
    class func getNivel(_ dificultad: Int) -> Nivel {
        var nivel: Nivel
        switch dificultad {
        case 1:
            nivel = Nivel(tipo: .bajo, tiempoPantalla: 40, tiempoJuego: 20, mostrarTonicas: true)
        case 2:
            nivel = Nivel(tipo: .bajo, tiempoPantalla: 40, tiempoJuego: 20, mostrarTonicas: false)
        case 3:
            nivel = Nivel(tipo: .medio, tiempoPantalla: 40, tiempoJuego: 20, mostrarTonicas: true)
        case 4:
            nivel = Nivel(tipo: .medio, tiempoPantalla: 40, tiempoJuego: 20, mostrarTonicas: false)
        case 5:
            nivel = Nivel(tipo: .alto, tiempoPantalla: 40, tiempoJuego: 20, mostrarTonicas: true)
        case 6:
            nivel = Nivel(tipo: .alto, tiempoPantalla: 40, tiempoJuego: 20, mostrarTonicas: false)
        default:
            nivel = Nivel(tipo: .bajo, tiempoPantalla: 40, tiempoJuego: 0, mostrarTonicas: true)
        }
        return nivel
    }
    
}
