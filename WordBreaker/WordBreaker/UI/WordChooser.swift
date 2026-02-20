//
//  WordChooser.swift
//  WordBreaker
//
//  Created by 千秋 on 2026/2/16.
//

import SwiftUI

struct WordChooser: View {
    let choices: [Character]
    var onChoose: ((Character) -> Void)?
    
    var body: some View {
        HStack{
            ForEach((choices), id:\.self) { ch in
                Button {
                    onChoose?(ch)
                } label: {
                    Text(String(ch))
                        .font(.system(size: 20, weight: .bold))
                        .frame(width: 32, height: 34)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10).stroke(lineWidth: 2)
                        
                        )
                }
            }
        }
    }
}

