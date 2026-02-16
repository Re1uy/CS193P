//
//  CodeView.swift
//  CodeBreaker
//
//  Created by 千秋 on 2026/2/15.
//

import SwiftUI

struct CodeView: View {
    //MARK: Data In
    let code: Code
    let supportColors: [Peg]
    
    //MARK:
    @Binding var selection: Int
    
    // MARK: - Body
    var body: some View {
        ForEach(code.pegs.indices, id:\.self) { index in
            PegView(peg: code.pegs[index], supportColors: supportColors)
                .padding(Selection.border)
                .background {
                    if selection == index, code.kind == .guess {
                        Selection.shape
                            .foregroundStyle(Selection.color)
                    }
                }
                .overlay {
                    Selection.shape.foregroundStyle(code.isHidden ? Color.gray : .clear)
                }
                .onTapGesture {
                    if code.kind == .guess {
                        selection = index
                    }
                }
        }
    }
    
    struct Selection {
        static let border:CGFloat = 5
        static let cornerRadius: CGFloat = 10
        static let color: Color = Color.gray(0.85)
        static let shape = RoundedRectangle(cornerRadius: cornerRadius)
    }
}

//#Preview {
//}
