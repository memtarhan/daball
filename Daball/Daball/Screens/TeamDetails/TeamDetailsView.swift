//
//  TeamDetailsView.swift
//  Daball
//
//  Created by Mehmet Tarhan on 2.02.2025.
//  Copyright © 2025 MEMTARHAN. All rights reserved.
//

import SwiftUI

struct TeamDetailsRow: View {
    var data: TeamDetailsModel
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(data.description)
                .font(.headline)
            
            Text(data.details)
                .font(.title3.weight(.thin))
            
            Divider()
        }
        .padding(8)
    }
}
struct TeamDetailsView: View {
    @StateObject private var viewModel = TeamDetailsViewModel()

    var teamId: String
    var teamName: String
    var body: some View {
        NavigationStack {
            ZStack {
                Color.element
                    .ignoresSafeArea(.all)
                
                if viewModel.loading {
                    ProgressView {
                        Text("Loading...")
                    }
                    
                } else {
                    ScrollView {
                        HStack(alignment: .center) {
                            AsyncImage(url: URL(string: viewModel.logo)) { image in
                                image
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                            } placeholder: {
                                Image(systemName: "figure.soccer")
                            }
                            .frame(width: 72, height: 72)
                            
                            Text(viewModel.title)
                                .font(.subheadline)
                        }
                        .padding()
                        .background(Color.element)
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                        .northWestShadow()
                        
                        VStack {
                            ForEach(viewModel.details) { details in
                                TeamDetailsRow(data: details)
                            }
                        }
                        .background(Color.element)
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                        .padding()
                        .southEastShadow()
                    }
                    .frame(maxWidth: .infinity)
                    .navigationTitle(teamName)
                    .navigationBarTitleDisplayMode(.inline)
                }
            }
        }
        .task {
            await viewModel.handleTeamDetails(teamId: teamId)
        }
    }
}

#Preview {
    TeamDetailsView(teamId: "206d90db", teamName: "Barcelona")
}
