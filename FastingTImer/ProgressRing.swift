//
//  ProgressRing.swift
//  FastingTImer
//
//  Created by kittawat phuangsombat on 2022/8/28.
//

import SwiftUI

struct ProgressRing: View {
    @EnvironmentObject var fastingManager: FastingManger
    
    let timer = Timer
        .publish(every: 1, on: .main, in: .common)
        .autoconnect()
    
    var body: some View {
        ZStack{
            //MARK: Placeholder Ring
            
            Circle()
                .stroke(lineWidth: 20)
                .foregroundColor(.gray)
                .opacity(0.1)
            
                //MARK: Colored Ring
            Circle()
                .trim(from: 0.0, to: min(fastingManager.progress, 1.0))
                .stroke(AngularGradient(gradient: Gradient(colors: [Color(#colorLiteral(red: 0.7669664621, green: 0, blue: 0.4258552194, alpha: 1)), Color(#colorLiteral(red: 0.1064938232, green: 0.1932004988, blue: 0.7289923429, alpha: 1)), Color(#colorLiteral(red: 0, green: 0.713614583, blue: 0.1597209573, alpha: 1)), Color(#colorLiteral(red: 0.7338178158, green: 0.5099902749, blue: 0, alpha: 1)), Color(#colorLiteral(red: 0, green: 0.7137106061, blue: 0.6779013276, alpha: 1))]), center: .center), style: StrokeStyle(lineWidth: 15.0, lineCap: .round, lineJoin: .round))
                .rotationEffect(Angle(degrees: 270))
                .animation(.easeInOut(duration: 1.0), value: fastingManager.progress)
            
            VStack(spacing: 30){
                if fastingManager.fastingState == .notStarted {
                    //MARK: Upcoming Time
                    
                    VStack(spacing: 5){
                        Text("Upcoming fast")
                            .opacity(0.7)
                        
                        Text("\(fastingManager.fastingPlan.fastingPeriod.formatted()) Hours")
                            .font(.title)
                            .fontWeight(.bold)
                    }
                } else {
                //MARK: Elapsed Time
                
                VStack(spacing: 5){
                    Text("Elapsed time (\(fastingManager.progress.formatted(.percent)))")
                        .opacity(0.7)
                    
                    Text(fastingManager.startTime, style: .timer)
                        .font(.title)
                        .fontWeight(.bold)
                }.padding(.top)
                
                //MARK: Remaining Time
                
                VStack(spacing: 5){
                    if !fastingManager.elapsed{
                        Text("Remaining time (\((1-fastingManager.progress).formatted(.percent)))")
                            .opacity(0.7)
                    }else{
                        Text("Extra time")
                            .opacity(0.7)
                    }
                    
                    Text(fastingManager.endTime, style: .timer)
                        .font(.title2)
                        .fontWeight(.bold)
                }
                }
            }
        }
        .frame(width: 250, height: 250)
        .padding()
//        .onAppear{
//            fastingManager.progress = 1
//        }
        .onReceive(timer) { _ in
            fastingManager.track()
        }
    }
}

struct ProgressRing_Previews: PreviewProvider {
    static var previews: some View {
        ProgressRing()
            .environmentObject(FastingManger())
    }
}
