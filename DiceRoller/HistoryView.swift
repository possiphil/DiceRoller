//
//  HistoryView.swift
//  DiceRoller
//
//  Created by Philipp Sanktjohanser on 28.01.23.
//

import SwiftUI

struct HistoryView: View {
    let history: [Roll]
    
    var body: some View {
        List {
            ForEach(history) { history in
                HStack {
                    Text("Result: \(history.result)")
                    
                    Spacer()
                    
                    Text("Rolls: \(history.rolls.joined(separator: ", "))")
                }
            }
        }
    }
}

struct HistoryView_Previews: PreviewProvider {
    static var previews: some View {
        HistoryView(history: [Roll.example])
    }
}
