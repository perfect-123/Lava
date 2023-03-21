//
//  ContentView.swift
//  Lava
//
//  Created by Perfect Ackah on 11/14/22.
//

import SwiftUI
//
class Particle{
    var x: Double
    var y: Double
    let xSpeed: Double
    let ySpeed: Double
    let deathDate = Date.now.timeIntervalSinceReferenceDate + 2
    
    init(x: Double, y: Double, xSpeed: Double, ySpeed: Double) {
        self.x = x
        self.y = y
        self.xSpeed = xSpeed
        self.ySpeed = ySpeed
    
        
    }
}
class ParticleSystem {
    var particles = [Particle]()
    var lastUpdate = Date.now.timeIntervalSinceReferenceDate
    
    func update(date:TimeInterval, size: CGSize)
    {
        let delta = date - lastUpdate
        lastUpdate = date
        
        // update all particles here
        for (index, particle) in particles.enumerated(){
            if particle.deathDate < date {
                particles.remove(at: index)
            } else{
                particle.x += particle.xSpeed * delta
                particle.y += particle.ySpeed * delta
            }
        }
        
        //New particles show up in th view
        let newParticle = Particle(x: . random(in: -32...size.width), y:-32, xSpeed: .random(in: -50...50), ySpeed: .random(in: 100...600))
        particles.append(newParticle)
    }
}


struct ContentView: View {
    @State private var particleSystem = ParticleSystem()
    
    var body: some View {
        
        LinearGradient(colors:[.red,.yellow], startPoint: .top, endPoint: . bottom).mask{
            TimelineView(.animation){
                timeline in
                Canvas {
                    ctx, size in
                    let timelineDate = timeline.date.timeIntervalSinceReferenceDate
                    particleSystem.update(date: timelineDate, size: size)
                    ctx.addFilter(.alphaThreshold(min: 0.5, color: .white))
                    ctx.addFilter(.blur(radius: 10))
                    
                    ctx.drawLayer{ ctx in
                        for particle in particleSystem.particles{
                            ctx.opacity = particle.deathDate - timelineDate
                            ctx.fill(Circle().path(in: CGRect(x: particle.x, y: particle.y, width: 32, height: 32)), with: .color(.white))
                        }
                    }
                }
            }
        }.ignoresSafeArea()
        .background(.blue)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
