//
//  Neumorphism.swift
//  Daball
//
//  Created by Mehmet Tarhan on 1.02.2025.
//  Copyright © 2025 MEMTARHAN. All rights reserved.
//

import SwiftUI

extension View {
    func northWestShadow(radius: CGFloat = 16, offset: CGFloat = 6) -> some View {
        return shadow(color: .highlight, radius: radius, x: -offset, y: -offset)
            .shadow(color: .shadow, radius: radius, x: offset, y: offset)
    }

    func southEastShadow(radius: CGFloat = 16, offset: CGFloat = 6) -> some View {
        return shadow(color: .shadow, radius: radius, x: -offset, y: -offset)
            .shadow(color: .highlight, radius: radius, x: offset, y: offset)
    }
}

extension Color {
    static let offWhite = Color(red: 225 / 255, green: 225 / 255, blue: 235 / 255)

    static let darkStart = Color(red: 50 / 255, green: 60 / 255, blue: 65 / 255)
    static let darkEnd = Color(red: 25 / 255, green: 25 / 255, blue: 30 / 255)

    static let lightStart = Color(red: 60 / 255, green: 160 / 255, blue: 240 / 255)
    static let lightEnd = Color(red: 30 / 255, green: 80 / 255, blue: 120 / 255)
}

extension LinearGradient {
    init(_ colors: Color...) {
        self.init(gradient: Gradient(colors: colors), startPoint: .topLeading, endPoint: .bottomTrailing)
    }
}

struct ColorfulBackground<S: Shape>: View {
    var isHighlighted: Bool
    var shape: S

    var body: some View {
        ZStack {
            if isHighlighted {
                shape
                    .fill(LinearGradient(Color.lightEnd, Color.lightStart))
                    .overlay(shape.stroke(LinearGradient(Color.lightStart, Color.lightEnd), lineWidth: 6))
                    .shadow(color: Color.shadow, radius: 10, x: 5, y: 5)
                    .shadow(color: Color.element, radius: 10, x: -5, y: -5)
            } else {
                shape
                    .fill(LinearGradient(Color.lightEnd.opacity(0.6), Color.lightStart.opacity(0.6)))
//                    .northWestShadow()
            }
        }
    }
}

struct ColorfulButtonStyle: ButtonStyle {
    var isPressed: Bool = false
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .padding()
            .contentShape(Circle())
            .background(
                ColorfulBackground(isHighlighted: isPressed, shape: Circle())
            )
    }
}
