import SwiftUI

struct WalkthroughListView: View {
    @StateObject private var viewModel = WalkthroughViewModel()
    
    var body: some View {
        NavigationStack {
            List(viewModel.walkthroughs) { guide in
                NavigationLink(destination: WalkthroughDetailView(guide: guide)) {
                    WalkthroughCard(guide: guide)
                }
            }
            .listStyle(.plain)
            .navigationTitle("Guides")
            .task {
                await viewModel.loadWalkthroughs()
            }
            .preferredColorScheme(.dark)
        }
    }
}

struct WalkthroughCard: View {
    let guide: Walkthrough
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(guide.title)
                .font(.headline)
            Text(guide.description)
                .font(.subheadline)
                .lineLimit(2)
            
            HStack {
                Text(guide.difficulty.rawValue)
                    .font(.caption)
                    .padding(4)
                    .background(Color.gray.opacity(0.3))
                    .cornerRadius(4)
                
                Spacer()
                
                Label("\(guide.rating, specifier: "%.1f")", systemImage: "star.fill")
                    .font(.caption)
                    .foregroundStyle(.yellow)
            }
        }
        .padding(.vertical, 8)
    }
}

struct WalkthroughDetailView: View {
    let guide: Walkthrough
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text(guide.title)
                    .font(.largeTitle.bold())
                
                Text(guide.description)
                    .font(.body)
                
                Divider()
                
                Text("Steps")
                    .font(.title2.bold())
                
                ForEach(guide.steps) { step in
                    VStack(alignment: .leading, spacing: 8) {
                        Text("\(step.stepNumber). \(step.title)")
                            .font(.headline)
                        Text(step.description)
                            .font(.body)
                    }
                    .padding()
                    .background(Constants.Colors.cardBackground)
                    .cornerRadius(8)
                }
            }
            .padding()
        }
        .navigationTitle("Details")
        .navigationBarTitleDisplayMode(.inline)
        .preferredColorScheme(.dark)
    }
}
