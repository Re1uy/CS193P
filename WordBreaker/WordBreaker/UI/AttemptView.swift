//
//  AttemptView.swift
//  WordBreaker
//
//  Created by 千秋 on 2026/2/19.
//

import SwiftUI

struct AttemptView: View {
    let word: String
    let matches: [Match]
    let total: Int
    let Over:Bool
    
    var body: some View {
        HStack(spacing: 10) {
            let chars = Array(word)
            ForEach(0..<total, id: \.self) { i in
                Text(i < chars.count ? String(chars[i]) : "")
                    .font(.system(size: 30, weight: .bold))
                    .frame(width: 45, height: 45)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(lineWidth: 2)
                    )
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Over ? Color.green(0.85) : Color.clear)
                    )
            }
        }
    }
}
//
//#Preview {
//    AttemptView()
//}
