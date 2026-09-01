import SwiftUI

struct TrophyListView: View {
    @StateObject private var viewModel = TrophyViewModel()
    
    let columns = [GridItem(.flexible()), GridItem(.flexible())]
    
    var body: some View {
        NavigationStack {
            VStack {
                Picker("Platform", selection: $viewModel.currentPlatform) {
                    ForEach(Platform.allCases, id: \.self) { platform in
                        Text(platform.rawValue).tag(platform)
                    }
                }
                .pickerStyle(.segmented)
                .padding()
                
                if viewModel.isLoading {
                    ProgressView()
                } else {
                    ScrollView {
                        LazyVGrid(columns: columns, spacing: 16) {
                            ForEach(viewModel.trophies) { trophy in
                                TrophyCell(trophy: trophy)
                            }
                        }
                        .padding()
                    }
                }
            }
            .navigationTitle("Trophies")
            .task {
                await viewModel.loadTrophies()
            }
            .onChange(of: viewModel.currentPlatform) { newValue in
                Task {
                    await viewModel.switchPlatform(newValue)
                }
            }
            .preferredColorScheme(.dark)
        }
    }
}

struct TrophyCell: View {
    let trophy: Trophy
    
    var body: some View {
        VStack {
            Image(systemName: trophy.earned ? "trophy.fill" : "trophy")
                .font(.system(size: 40))
                .foregroundStyle(trophy.earned ? .yellow : .gray)
                .padding()
            
            Text(trophy.name)
                .font(.headline)
                .multilineTextAlignment(.center)
            
            Text(trophy.rarity)
                .font(.caption)
                .foregroundStyle(Constants.Colors.secondary)
            
            if let progress = trophy.progress {
                ProgressView(value: progress, total: 100)
                    .tint(Constants.Colors.primary)
            }
        }
        .padding()
        .background(Constants.Colors.cardBackground)
        .cornerRadius(12)
    }
}
