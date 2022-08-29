//
//  FastingManager.swift
//  FastingTImer
//
//  Created by kittawat phuangsombat on 2022/8/28.
// we did it!
 
import Foundation

enum FastingState{
    case notStarted
    case fasting
    case feeding
}

enum FastingPlan: String{
    case beginner = "12:12"
    case intermediate = "16:8"
    case advance = "20:4"
    
    var fastingPeriod: Double{
        switch self {
        case .beginner:
            return 12
        case .intermediate:
            return 16
        case .advance:
            return 20
        }
    }
}

class FastingManger: ObservableObject{
    @Published private(set) var fastingState: FastingState = .notStarted
    @Published private(set) var fastingPlan: FastingPlan = .intermediate
    @Published private(set) var startTime: Date{
        didSet{
            print("startTime", startTime.formatted(.dateTime.month().day().hour().minute().second()))
            
            if fastingState == .fasting{
                endTime = startTime.addingTimeInterval(fastingTime)
            }else{
                endTime = startTime.addingTimeInterval(feedingTime)
            }
        }
    }
    @Published private(set) var endTime: Date{
        didSet{
            print("endTime", endTime.formatted(.dateTime.month().day().hour().minute().second()))
        }
    }
    @Published private(set) var elapsed: Bool = false
    @Published private(set) var elapsedTIme: Double = 0.0
    @Published private(set) var progress:Double = 0.0
    
    var fastingTime: Double{
        return fastingPlan.fastingPeriod * 60 * 60
    }
    var feedingTime: Double{
        return (24 - fastingPlan.fastingPeriod) * 60 * 60
    }
    
    init(){
        let calendar = Calendar.current
//
//        var components = calendar.dateComponents([.year, .month, .day, .hour], from: Date())
//        components.hour = 20
//        print((components))
//
//        let scheduledTime = calendar.date(from: components) ?? Date.now
//        print("scheduledTime", scheduleTime.formatted(.dateTime.month().day().hour().minute().second()))
        
        let componets = DateComponents(hour: 20)
        let scheduledTime = calendar.nextDate(after: .now, matching: componets, matchingPolicy: .nextTime)!
        
        print("scheduleTime", scheduledTime.formatted(.dateTime.month().day().hour().minute().second()))
        
        
        startTime = scheduledTime
        endTime = scheduledTime.addingTimeInterval(FastingPlan.intermediate.fastingPeriod * 60 * 60 )
        
    }
    
    func toggleFastingState() {
        fastingState = fastingState == .fasting ? .feeding : .fasting
        startTime = Date()
        elapsedTIme = 0.0
        
    }
    
    func track(){
        guard fastingState != .notStarted else { return }
        
        print("now", Date().formatted(.dateTime.month().day().hour().minute().second()))
        if endTime >= Date(){
            print("Not elapesed")
            elapsed = false
        }else{
            print("elapsed")
            elapsed = true
        }
        
        elapsedTIme += 1
        print(elapsedTIme)
        
        let totaltime = fastingState == .fasting ? fastingTime : feedingTime
        progress = (elapsedTIme / totaltime * 100).rounded() / 100
        print("progress", progress)
        
    }
    func change(plan: FastingPlan) {
        switch plan {
        case .beginner:
            fastingPlan = .intermediate
        case .intermediate:
            fastingPlan = .advance
        case .advance:
            fastingPlan = .beginner
        }
    }
}
