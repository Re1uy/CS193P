//
//  PegChooser.swift
//  CodeBreaker
//
//  Created by 千秋 on 2026/2/15.
//

import SwiftUI

struct PegChooser: View {
    let supportColors: [Peg]
    let choices: [Peg]
    let onChoose: ((Peg) -> Void)?
    
    var body: some View {
        HStack{
            ForEach(choices, id:\.self) { peg in
                Button {
                    onChoose?(peg)
                } label: {
                    PegView(peg: peg,supportColors: supportColors)
                }
            }
        }
    }
}

//#Preview {
//    PegChooser()
//}
