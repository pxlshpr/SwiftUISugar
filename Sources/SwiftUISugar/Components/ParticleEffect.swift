import SwiftUI

public extension View {
    @ViewBuilder
    func particleEffect(systemImage: String, font: Font, status: Bool, activeColor: Color, inactiveColor: Color, moveDown: Bool = false) -> some View {
        self
            .modifier(
                ParticleModifier(systemImage: systemImage, font: font, status: status, activeColor: activeColor, inactiveColor: inactiveColor, moveDown: moveDown)
            )
    }
}

fileprivate struct ParticleModifier: ViewModifier {
    var systemImage: String
    var font: Font
    var status: Bool
    var activeColor: Color
    var inactiveColor: Color
    var moveDown: Bool
    @State private var particles: [Particle] = []
    
    func body(content: Content) -> some View {
        content
            .overlay(alignment: .top) {
                ZStack {
                    ForEach(particles) { particle in
                        Image(systemName: systemImage)
                            .foregroundColor(status ? activeColor : inactiveColor)
                            .scaleEffect(particle.scale)
                            .offset(x: particle.randomX, y: particle.randomY)
                            .opacity(particle.opacity)
                            .opacity(status ? 1 : 0)
                            .animation(.none, value: status)
                    }
                }
                .onAppear {
                    if particles.isEmpty {
                        for _ in 1...15 {
                            let particle = Particle()
                            particles.append(particle)
                        }
                    }
                }
                .onChange(of: status) { newValue in
                    if !newValue {
                        for index in particles.indices {
                            particles[index].reset()
                        }
                    } else {
                        for index in particles.indices {
                            let total: CGFloat = CGFloat(particles.count)
                            let progress: CGFloat = CGFloat(index) / total
                            
                            let maxX: CGFloat = (progress > 0.5) ? 100 : -100
                            let maxY: CGFloat = 60
                            
                            let randomX: CGFloat = ((progress > 0.5 ? progress - 0.5 : progress) * maxX)
                            let randomY: CGFloat = ((progress > 0.5 ? progress - 0.5 : progress) * maxY) + 35
                            
//                            let randomScale: CGFloat = .random(in: 0.35...1)
                            let randomScale: CGFloat = .random(in: 0.5...3)

//                            let SpringAnimation: Animation = .interactiveSpring(response: 0.6, dampingFraction: 0.7, blendDuration: 0.7)
                            let SpringAnimation: Animation = .easeOut(duration: 2.0)

                            withAnimation(SpringAnimation) {
                                let extraRandomX: CGFloat = (progress < 0.5 ? .random(in: 0...10) : .random(in: -10...0))
                                let extraRandomY: CGFloat = .random(in: 0...30)
                                particles[index].randomX = randomX + extraRandomX
                                
                                var y = -randomY - extraRandomY
                                if moveDown {
                                    y *= -1
                                }
                                particles[index].randomY = y
                            }

                            withAnimation(.easeInOut(duration: 0.3)) {
                                particles[index].scale = randomScale
                            }
                            
                            withAnimation(SpringAnimation.delay(1.0 + (Double(index) * 0.005))) {
                                particles[index].scale = 0.001
                            }
                        }
                    }
                }
            }
    }
}

import SwiftUI

struct Particle: Identifiable {
    var id: UUID = .init()
    var randomX: CGFloat = 0
    var randomY: CGFloat = 0
    var scale: CGFloat = 1
    var opacity: CGFloat = 1
    mutating func reset() {
        randomX = 0
        randomY = 0
        scale = 1
        opacity = 1
    }
}
