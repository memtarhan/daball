//
//  MatchDetailsView.swift
//  Daball
//
//  Created by Mehmet Tarhan on 3.02.2025.
//  Copyright © 2025 MEMTARHAN. All rights reserved.
//

import SwiftUI

struct MatchDetailsView: View {
    var matchId: String
    var body: some View {
        Text(matchId)
    }
}

#Preview {
    MatchDetailsView(matchId: "ac04a5d2")
}
