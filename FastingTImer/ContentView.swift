//
//  ContentView.swift
//  FastingTImer
//
//  Created by kittawat phuangsombat on 2022/8/28.
//

import SwiftUI

struct ContentView: View {
    @StateObject var fastingManager = FastingManger()
    @State private var showingAlert = false
    
    var title: String{
        switch fastingManager.fastingState{
            
        case .notStarted:
            return "Let's fast"
        case .fasting:
            return "You are now fasting"
        case .feeding:
            return "You can now eat"
        }
    }
    
    var body: some View {
        ZStack{
            //MARK: Background
            
            Color(fastingManager.fastingState.backgroundColor.self)
                .ignoresSafeArea()
            
            content
        }
    }
    
    var content: some View {
        ZStack {
            VStack(spacing: 40){
                //MARK: Title
                
                Text(title)
                    .font(.headline)
                    .foregroundColor(Color(ChoosenIs.pastel.rawValue))
                
                
                //MARK: Fasting Plan
                
                Button {
                    //change plan
                    fastingManager.change(plan: fastingManager.fastingPlan)
                    
                } label: {
                    Text(fastingManager.fastingPlan.rawValue)
                        .fontWeight(.semibold)
                        .padding(.horizontal, 24)
                        .padding(.vertical, 8)
                        .background(.thinMaterial)
                        .cornerRadius(20)
                }
//                .disabled(fastingManager.fastingState == .fasting)
                Spacer()
            }
            .padding()
                
            VStack(spacing: 40){
                //MARK: Progress Ring
                
                ProgressRing()
                    .environmentObject(fastingManager)
                HStack(spacing: 60){
                    //MARK: Start Time
                    
                    VStack(spacing: 5){
                        Text(fastingManager.fastingState == .notStarted ? "Start" : "From")
                            .opacity(0.7)
                        Text(fastingManager.startTime, format: .dateTime.weekday().hour().minute())
                            .fontWeight(.bold )
                    }
                    
                    //MARK: End Time
                    
                    VStack(spacing: 5){
                        Text(fastingManager.fastingState == .notStarted ? "End" : "To")
                            .opacity(0.7)
                        Text(fastingManager.endTime, format: .dateTime.weekday().hour().minute())
                            .fontWeight(.bold )
                    }
                }
                .opacity(fastingManager.fastingState == .fasting ? 1 : 0)

                
                //MARK: Button
                Button {
                    switch fastingManager.fastingState{
                    case .notStarted:
                        fastingManager.toggleFastingState()
                    case .fasting:
                        showingAlert = true
                    case .feeding:
                        fastingManager.toggleFastingState()
                    }
                    print(fastingManager.fastingState)
                    
                } label: {
                    Text(fastingManager.fastingState == .fasting ? "End fast": "Start fasting")
                        .font(.title3)
                        .fontWeight(.semibold)
                        .padding(.horizontal, 24)
                        .padding(.vertical, 8)
                        .background(.thinMaterial)
                        .cornerRadius(20)
                }
                .alert("Are you sure you want to stop fasting ?", isPresented: $showingAlert) {
                    Button("Confirm") {
                        fastingManager.toggleFastingState()
                    }
                    Button("Cancel", role: .cancel) { }
                }
                
            }
            .padding()
        }
        .foregroundColor(.white)
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
