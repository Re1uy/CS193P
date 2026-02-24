//
//  Flitter.swift
//  WordBreaker
//
//  Created by 千秋 on 2026/2/24.
//

import SwiftUI

struct Filter: View {
    @Binding var selectedFilter: GameList.GameFilter
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            Form {
                Picker("Game Status", selection: $selectedFilter) {
                    ForEach(GameList.GameFilter.allCases) { filter in
                        Text(filter.rawValue).tag(filter)
                    }
                }
                .pickerStyle(.inline)
            }
            .navigationTitle("Filter Options")
            .toolbar {
                Button("Done") {
                    dismiss()
                }
            }
        }
    }
}

#Preview {
    Filter(selectedFilter: .constant(.all))
}
