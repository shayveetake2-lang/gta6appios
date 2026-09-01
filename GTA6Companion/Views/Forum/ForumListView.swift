import SwiftUI

struct ForumListView: View {
    @StateObject private var viewModel = ForumViewModel()
    
    var body: some View {
        NavigationStack {
            List(viewModel.threads) { thread in
                NavigationLink(destination: ForumThreadDetailView(thread: thread)) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text(thread.title).font(.headline)
                        HStack {
                            Text(thread.author.username).font(.caption).foregroundStyle(.secondary)
                            Spacer()
                            Text("\(thread.replies.count) replies").font(.caption).foregroundStyle(.secondary)
                        }
                    }
                }
            }
            .navigationTitle("Forum")
            .task {
                await viewModel.loadForumThreads()
            }
            .preferredColorScheme(.dark)
        }
    }
}

struct ForumThreadDetailView: View {
    let thread: ForumThread
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text(thread.title).font(.title.bold())
                Text("By \(thread.author.username)").font(.subheadline).foregroundStyle(.secondary)
                
                Text(thread.content)
                    .padding(.vertical)
                
                Divider()
                
                Text("Replies").font(.headline)
                
                ForEach(thread.replies) { reply in
                    VStack(alignment: .leading) {
                        Text(reply.author.username).font(.subheadline.bold())
                        Text(reply.content).font(.body)
                    }
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Constants.Colors.cardBackground)
                    .cornerRadius(8)
                }
            }
            .padding()
        }
        .navigationTitle("Thread")
        .navigationBarTitleDisplayMode(.inline)
        .preferredColorScheme(.dark)
    }
}
