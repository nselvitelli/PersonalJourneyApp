//
//  CirclularProgressBar.swift
//  TestBackgroundModelContext
//
//  Created by Nick Selvitelli on 12/3/23.
//

import SwiftUI


struct CircularProgressView: View {
    
    
    @Binding var progress: Double
    
    let lineWidth : CGFloat = 5
    let size : CGFloat = 20
    
    @AppStorage("sliderBackgroundColor") var sliderBackgroundColor = Color.green.opacity(0.5)
    @AppStorage("sliderProgressColor") var sliderProgressColor = Color.green
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(
                    sliderBackgroundColor,
                    lineWidth: lineWidth
                )
            Circle()
                .trim(from: 0, to: progress)
                .stroke(
                    sliderProgressColor,
                    style: StrokeStyle(
                        lineWidth: lineWidth,
                        lineCap: .round
                    )
                )
                .rotationEffect(.degrees(-90))
                // 1
                .animation(.easeOut, value: progress)

        }
        .frame(width: size, height: size)
    }
}


#Preview {
    CircularProgressView(progress: .constant(0.5))
}
