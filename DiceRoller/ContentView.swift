//
//  ContentView.swift
//  DiceRoller
//
//  Created by Philipp Sanktjohanser on 28.01.23.
//

import SwiftUI

struct ContentView: View {
    private let saveKey = "history"
    private let savePath: URL
    @State private var rolls = [Roll]()
    
    private let die = [4, 6, 8, 10, 12, 20, 100]
    @State private var dice = 20
    @State private var amount = 0
    @State private var bonus = 0
    @State private var result = 0
    @State private var rolled = [0, 0, 0, 0, 0]
    
    init() {
        savePath = FileManager.documentsDirectory.appending(path: saveKey)
        
        do {
            let data = try Data(contentsOf: savePath)
            rolls = try JSONDecoder().decode([Roll].self, from: data)
        } catch {
            rolls = []
        }
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                VStack {
                    HStack(spacing: 24) {
                        Rectangle()
                            .stroke(lineWidth: 2)
                            .frame(width: 44, height: 44)
                            .overlay {
                                Text("\(rolled[0])")
                            }
                        
                        if amount >= 1 {
                            Rectangle()
                                .stroke(lineWidth: 2)
                                .frame(width: 44, height: 44)
                                .overlay {
                                    Text("\(rolled[1])")
                                }
                        }
                        
                        if amount >= 2 {
                            Rectangle()
                                .stroke(lineWidth: 2)
                                .frame(width: 44, height: 44)
                                .overlay {
                                    Text("\(rolled[2])")
                                }
                        }
                        
                        if amount >= 3 {
                            Rectangle()
                                .stroke(lineWidth: 2)
                                .frame(width: 44, height: 44)
                                .overlay {
                                    Text("\(rolled[3])")
                                }
                        }
                        
                        if amount == 4 {
                            Rectangle()
                                .stroke(lineWidth: 2)
                                .frame(width: 44, height: 44)
                                .overlay {
                                    Text("\(rolled[4])")
                                }
                        }
                    }
                    
                    Text("Result: \(result)")
                }
                
                Spacer()
                
                Form {
                    Section("Dice") {
                        Picker("Pick a dice", selection: $dice) {
                            ForEach(die, id: \.self) {
                                Text("\($0)")
                            }
                        }.pickerStyle(.segmented)
                    }
                    
                    Section("Amount of die") {
                        Picker("Pick a die amount", selection: $amount) {
                            ForEach(1..<6) {
                                Text("\($0)")
                            }
                        }.pickerStyle(.segmented)
                    }
                    
                    Section("Multiplier") {
                        Picker("Add your multiplier", selection: $bonus) {
                            ForEach(0..<11) {
                                Text("\($0)")
                            }
                        }.pickerStyle(.segmented)
                    }
                    
                    HStack {
                        Spacer()
                        Button { roll() } label: {
                            Text("Roll")
                                .foregroundColor(.primary)
                                .frame(width: 256, height: 44)
                                .background(.red)
                                .clipShape(Capsule())
                        }
                        Spacer()
                    }
                    .padding()
                }.formStyle(.columns)
            }
            .padding()
            .navigationTitle("Roll a dice")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink { HistoryView(history: rolls) } label: { Image(systemName: "clock") }
                }
            }
//            .onReceive(timer) { _ in
//                var tempRoll = [Int]()
//
//                for _ in 0..<5 {
//                    tempRoll.append(Int.random(in: 1...dice))
//                }
//
//                rolled = tempRoll
//            }
        }
    }
    
    func roll() {
        var tempRolled = [Int]()
        var tempResult = 0
        let rollAmount = amount + 1
        
        for _ in 0..<rollAmount {
            let roll = Int.random(in: 1...dice)
            tempRolled.append(roll)
            tempResult += roll + bonus
        }
        for _ in 0..<4 { tempRolled.append(0) }
        
        UINotificationFeedbackGenerator().notificationOccurred(.success)
        
        let timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
            var tempRoll = [Int]()
            
            for _ in 0..<5 {
                tempRoll.append(Int.random(in: 1...dice))
            }
            
            rolled = tempRoll
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            timer.invalidate()
            
//            withAnimation(.spring()) {
                rolled = tempRolled
                result = tempResult
//            }
            
            let formattedValues = rolled.filter { $0 != 0 }
            let formattedRolls = formattedValues.map { "\($0) + \(bonus)"}
            rolls.append(Roll(id: "\(Date.now)", result: result, rolls: formattedRolls))
            save()
        }
    }
    
    func save() {
        if let encoded = try? JSONEncoder().encode(rolls) {
            try? encoded.write(to: savePath, options: .atomic)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
