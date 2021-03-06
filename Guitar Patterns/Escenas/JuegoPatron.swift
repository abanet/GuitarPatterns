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
    var patron  : Patron = (PatronesDdbb().diccionarioEscalas[.pentatonicaMenorBlues]?[0])!//PatronesDdbb().escalas[1]
    let xMinimaBolas: CGFloat = 50.0
    var ruedaDentada: SKSpriteNode = SKSpriteNode(imageNamed: "ruedaDentada")
    
    var nivel: Nivel! // sustituir parámetros sueltos por esta variable de nivel
    lazy var tiempoRecorrerNotaPantalla: Double = nivel.tiempoRecorrerPantalla // indica la velocidad

    var objetivos: [String]  = [String]()
    var notasObjetivo: [SKShapeNode] = [SKShapeNode]()
    var ultimoObjetivoEscogido: String = "" // evitar q salgan dos intervalos objetivo seguidos
    
    var lastUpdateTime: TimeInterval = 0
    var dt: TimeInterval = 0
    
    
    var posicionInicial: CGPoint!
    var hud = HUD()
    var elapsedTime: Int = 0
    var startTime: Int?
    
    var puntos: Double! // puntos que se llevan ganados
    var numAciertos: Int = 0 // los contamos para incrementar velocidad cada 3 aciertos
    
    var radius: CGFloat { // radio de la nota en el corredor
        get {
            //return (Medidas.topSpace) / 3
            return (Medidas.porcentajeTopSpace * size.height) / 5
        }
    }
    
    // MARK: Ciclo de vida de la escena
    
    init(size: CGSize, nivel: Nivel, patron: Patron) {
        self.nivel = nivel
        self.patron = patron
        super.init(size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMove(to view: SKView) {
        self.view?.backgroundColor = .blue
        prepararSonidos()
        // playBackgroundMusic(filename: "CJonico.mp3")
        iniciarGuitarra()
        dibujarPatron()
       self.posicionInicial =  CGPoint(x: size.width + Medidas.marginSpace, y: (size.height - Medidas.porcentajeTopSpace * size.height + 16))
        activarSalidaNotas()
        puntos = Puntuacion.getPuntuacionJuegoPatrones()
        setupHUD()
        
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Calcular el deltaTime
        if lastUpdateTime > 0 {
            dt = currentTime - lastUpdateTime
        } else {
            dt = 0
        }
        lastUpdateTime = currentTime
        updateHUD(currentTime: currentTime)
        checkPasoNivel()
        comprobarDestruccionNodos()
        puntos = puntos + 0.01
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
                            acierto()
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
                    fallo()
                }
                //mynode.fillColor = Colores.noteFillResaltada
            }
        }
    }
    
    // Ha ocurrido un acierto
    func acierto() {
        puntos += 20
        numAciertos += 1
        if numAciertos == Velocidad.aciertosParaIncrementarVelocidad {
            numAciertos = 0
            // hay que eliminar todas las acciones en las notas objetivo y  cambiarlas por la nueva
            tiempoRecorrerNotaPantalla += Velocidad.decrementoTiempoRecorrerPantalla
            //cambiarVelocidadesNotas(tiempoRecorrerNotaPantalla)
            self.removeAction(forKey: "salidaNotas")
            run(SKAction.sequence([SKAction.wait(forDuration: 2.0),
                                   SKAction.run {
                                    self.activarSalidaNotas()
                }]))
            
        }
    }
    
    // Ha ocurrido un fallo
    func fallo() {
        puntos -= 10
    }
    
    
    func cambiarVelocidadesNotas(_ velocidad: Double) {
        enumerateChildNodes(withName: "objetivo") {[unowned self] (node, _) in
            // calculamos la nueva velocidad
            let vel = node.position.x * CGFloat(self.tiempoRecorrerNotaPantalla) / self.size.width
            let actionMove = SKAction.moveTo(x: 0, duration: Double(vel))
            node.removeAllActions()
            node.run(actionMove)
        }
    }
    // MARK: Generación de objetivos (spawnEnemy)
    func activarSalidaNotas() {
        eliminarNotasObjetivo {
            // se eliminan todas para evitar conflictos de velocidad...
            let periodo = Double((CGFloat(tiempoRecorrerNotaPantalla) * (radius * 4)) / size.width)
            run(SKAction.repeatForever(
                SKAction.sequence([SKAction.run() { [weak self] in
                    self?.spawnNota()
                    },
                    SKAction.wait(forDuration: periodo)])), withKey: "salidaNotas")
        }
    }
    
    func spawnNota() {
        let contenidoAzar = obtenerObjetivo()
        objetivos.append(contenidoAzar)
        let nota = drawCircleAt(point: CGPoint.zero, withRadius: radius, withText: contenidoAzar)
        nota.position = posicionInicial
//        nota.physicsBody = SKPhysicsBody(circleOfRadius: radius)
//        nota.physicsBody?.affectedByGravity = false
//        nota.physicsBody?.usesPreciseCollisionDetection = true
//        nota.physicsBody?.collisionBitMask = 0b001
//        nota.physicsBody?.velocity.dx = -60.0
        addChild(nota)
        notasObjetivo.append(nota)
        // movimiento constante
        let actionMove = SKAction.moveTo(x: 0, duration: tiempoRecorrerNotaPantalla)
        nota.run(actionMove)
    }
    
    func eliminarNotasObjetivo(completion: () -> Void) {
        var pausa = 0.0
        enumerateChildNodes(withName: "objetivo") {[unowned self] (node, _) in
            pausa += 0.2
            let group = SKAction.group([SKAction.fadeAlpha(to:0, duration: 0.4), self.collectcoin])
            let secuencia = SKAction.sequence([SKAction.wait(forDuration: pausa), group, SKAction.run {
                node.removeFromParent()
                }])
            node.run(secuencia)
        }
        objetivos.removeAll()
        notasObjetivo.removeAll()
        completion()
    }
    
    // Obtiene al azar un intervalo que pertenece a la interválica que estamos tratando
    func obtenerObjetivo() -> String  {
        let objetivosPosibles = patron.intervalica
        var objetivoElegido: String
        repeat {
            var intervaloElegido: TipoIntervalo
            repeat {
                let pos = Int.random(in: 0..<objetivosPosibles.count)
                intervaloElegido = patron.intervalica[pos]
            } while intervaloElegido == TipoIntervalo.unisono || intervaloElegido == TipoIntervalo.octavajusta
            objetivoElegido = intervaloElegido.rawValue
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
            marcarNotasConIntervalo(pos: posicion, nivel: nivel)
        }
    }
    
    func restaurarNombresNotasEnMastil() {
        for child in guitarra.children {
            if let shapeNota = child as? ShapeNote, shapeNota.name == "notaFallada" || shapeNota.name == "notaAcertada" {
                shapeNota.name = "nota"
                if shapeNota.getTagShapeNote() != nil && nivel.marcarNotas { // contiene información de nota
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
    
    func marcarNotasConIntervalo(pos: PosicionTraste, nivel: Nivel) {
        guitarra.enumerateChildNodes(withName: "nota") { nodoNota , _ in
            if let shapeNota = nodoNota as? ShapeNote {
                if shapeNota.posicionEnMastil == pos {
                    if nivel.marcarNotas {
                        shapeNota.setSelected(true)
                    }
                    let tonica = self.patron.getPosTonica()
                    if let intervalo = tonica.intervaloHasta(posicion: pos, intervalica: self.patron.intervalica) {
                        if nivel.mostrarNotas {
                            shapeNota.setTextShapeNote(intervalo.rawValue)
                        }
                        shapeNota.setTagShapeNote(intervalo.rawValue)
                        shapeNota.setDistanciaDesdeTonica(valor: tonica.semitonosHasta(posicion: pos))
                        if intervalo == TipoIntervalo.octavajusta {
                            shapeNota.setTipoShapeNote(.tonica)
                            if !nivel.mostrarTodasLasTonicas && pos != tonica {
                                // Sólo hay q mostrar la primera. El resto la coloreamos como es debido
                                if nivel.marcarNotas {
                                shapeNota.fillColor = Colores.noteFillResaltada
                                } else {
                                    shapeNota.fillColor = Colores.noteFill
                                }
                            }
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
    let collectcoin = SKAction.playSoundFileNamed("collectcoin.wav", waitForCompletion: true)
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
    
    // MARK: HUD Setup
    func setupHUD(){
        guard let view = view, let nivel = nivel else { return }
        let position = CGPoint(x:view.frame.width - 100, y: view.frame.height - 32)
        addChild(hud)
        // Timer
        hud.addTimer(time: Int(nivel.tiempoJuego), position: position)
        // Title
        if let nombre = patron.descripcion {
            hud.add(message: nombre, position: CGPoint(x:view.frame.width / 2, y: view.frame.height - 32))
        }
        // Nivel
        hud.add(message: "Nivel \(nivel.idNivel)", position: CGPoint(x: 50, y: view.frame.height - 32))
        // Marcador
        hud.addPuntos(position: CGPoint(x:50, y: view.frame.height - 60))
        // Rueda
        ruedaDentada.position = CGPoint(x: 150, y: size.height - 60)
        ruedaDentada.scale(to: CGSize(width: 70, height: 70))
        let girar = SKAction.rotate(byAngle: .pi * 2, duration: 5)
        let girarForever = SKAction.repeatForever(girar)
        ruedaDentada.run(girarForever)
        addChild(ruedaDentada)
        
    }
    
    func updateHUD(currentTime: TimeInterval) {
        if let startTime = startTime {
            elapsedTime = Int(currentTime) - startTime
        } else {
            startTime = Int(currentTime) - elapsedTime
        }
        hud.updateTimer(time: Int(nivel.tiempoJuego) - elapsedTime)
        hud.updatePuntosTo(Int(puntos))
    }
    
    func checkPasoNivel() {
        if Int(nivel.tiempoJuego) - elapsedTime <= 0 {
            // hemos logrado finalizar el nivel. Pasamos al siguiente
            Puntuacion.setPuntuacionJuegoPatrones(puntos: puntos)
            presentarSiguienteNivel(nivel.siguienteNivel())
        }
    }
    
    func presentarSiguienteNivel(_ nivel: Int) {
        let wait = SKAction.wait(forDuration: 2.0)
        let presentarNivel = SKAction.run {
            let scene = PresentacionNivel(size: self.size, level: nivel, patron: self.patron)
            let reveal = SKTransition.flipHorizontal(withDuration: 0.5)
            self.view?.presentScene(scene)//, transition: reveal)
            
        }
        self.run(SKAction.sequence([wait, presentarNivel]))
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

class Nivel {
    
    static let tiempoMinimoRecorrerPantalla: Double = 20.0  // Indica la velocidad máxima de la bola
    static let segundosParaIncrementoVelocidad: Double = 3  // Indica los segundos para incrementar la velocidad
    static let incrementoVelocidad: Int = -2   // Habrá 2 segundos menos para que la bola recorra la pantalla
    
    var idNivel: Int
    var tiempoRecorrerPantalla: TimeInterval
    var tiempoJuego: TimeInterval // Tiempo para completar cambio de nivel. 0 para tiempo infinito
    var mostrarTodasLasTonicas: Bool
    var mostrarNotas: Bool // true si se quiere enseñar el texto con los intervalos
    var marcarNotas: Bool   // true si se quiere colorear las notas
    
    init(idNivel: Int, tiempoPantalla: TimeInterval, tiempoJuego: TimeInterval, mostrarTonicas: Bool, mostrarNotas: Bool, marcarNotas: Bool) {
        self.idNivel = idNivel
        self.tiempoRecorrerPantalla = tiempoPantalla
        self.tiempoJuego = tiempoJuego
        self.mostrarTodasLasTonicas = mostrarTonicas
        self.mostrarNotas = mostrarNotas
        self.marcarNotas = marcarNotas
    }
    
    convenience init(idNivel: Int, tiempoPantalla: TimeInterval) {
        self.init(idNivel: idNivel, tiempoPantalla: tiempoPantalla, tiempoJuego: 0, mostrarTonicas: true, mostrarNotas: true, marcarNotas: true)
    }
    
    
    
    // Algunos niveles para probar
    class func getNivel(_ dificultad: Int) -> Nivel {
        var nivel: Nivel
        switch dificultad {
        case 1:
            nivel = Nivel(idNivel: 1, tiempoPantalla: 40, tiempoJuego: 60, mostrarTonicas: true, mostrarNotas: true, marcarNotas: true)
            
        case 2:
            nivel = Nivel(idNivel: 2, tiempoPantalla: 40, tiempoJuego: 60, mostrarTonicas: false, mostrarNotas: true, marcarNotas: true)
        case 3:
            nivel = Nivel(idNivel: 3, tiempoPantalla: 40, tiempoJuego: 60, mostrarTonicas: true, mostrarNotas: false, marcarNotas: true)
        case 4:
            nivel = Nivel(idNivel: 4, tiempoPantalla: 40, tiempoJuego: 60, mostrarTonicas: false, mostrarNotas: false, marcarNotas: true)
        case 5:
            nivel = Nivel(idNivel: 5, tiempoPantalla: 40, tiempoJuego: 60, mostrarTonicas: true, mostrarNotas: false, marcarNotas: false)
        case 6:
            nivel = Nivel(idNivel: 6, tiempoPantalla: 40, tiempoJuego: 60, mostrarTonicas: false, mostrarNotas: false, marcarNotas: false)
        default:
            nivel = Nivel(idNivel: 1, tiempoPantalla: 40, tiempoJuego: 0, mostrarTonicas: true, mostrarNotas: true, marcarNotas: true)
        }
        return nivel
    }
    
    func siguienteNivel() -> Int {
        if idNivel < 6 {
            return idNivel + 1
        } else {
            return idNivel
        }
    }
}
