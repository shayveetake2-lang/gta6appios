import SwiftUI

struct FeedView: View {
    @StateObject private var viewModel = FeedViewModel()
    @State private var selectedCategory: PostCategory? = nil
    @State private var showingCreatePost = false
    
    var body: some View {
        NavigationStack {
            VStack {
                Picker("Category", selection: $selectedCategory) {
                    Text("All").tag(PostCategory?.none)
                    ForEach(PostCategory.allCases, id: \.self) { cat in
                        Text(cat.rawValue.capitalized).tag(PostCategory?.some(cat))
                    }
                }
                .pickerStyle(.segmented)
                .padding()
                
                if viewModel.isLoading {
                    ProgressView()
                } else {
                    List(viewModel.posts) { post in
                        PostCell(post: post)
                            .listRowBackground(Color.clear)
                            .listRowSeparator(.hidden)
                    }
                    .listStyle(.plain)
                    .refreshable {
                        await viewModel.fetchPosts(category: selectedCategory)
                    }
                }
            }
            .navigationTitle("Home")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button(action: { showingCreatePost = true }) {
                        Image(systemName: "square.and.pencil")
                    }
                }
            }
            .sheet(isPresented: $showingCreatePost) {
                CreatePostView(viewModel: viewModel)
            }
            .task {
                await viewModel.fetchPosts()
            }
            .onChange(of: selectedCategory) { newValue in
                Task {
                    await viewModel.fetchPosts(category: newValue)
                }
            }
            .preferredColorScheme(.dark)
        }
    }
}

struct PostCell: View {
    let post: Post
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Circle()
                    .fill(Constants.Colors.primary)
                    .frame(width: 40, height: 40)
                
                VStack(alignment: .leading) {
                    Text(post.author.username).font(.headline)
                    Text(post.timestamp.formatted()).font(.caption).foregroundStyle(.secondary)
                }
                
                Spacer()
                
                Text(post.category.rawValue)
                    .font(.caption2.bold())
                    .padding(4)
                    .background(Constants.Colors.secondary.opacity(0.3))
                    .cornerRadius(4)
            }
            
            Text(post.content)
                .font(.body)
            
            HStack(spacing: 20) {
                Button(action: {}) {
                    Label("\(post.likes)", systemImage: post.liked ? "heart.fill" : "heart")
                }
                .foregroundStyle(post.liked ? .red : .primary)
                
                Button(action: {}) {
                    Label("\(post.comments)", systemImage: "bubble.right")
                }
                .foregroundStyle(.primary)
            }
        }
        .padding()
        .background(Constants.Colors.cardBackground)
        .cornerRadius(12)
    }
}

struct CreatePostView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var viewModel: FeedViewModel
    @State private var content = ""
    @State private var category = PostCategory.discussion
    
    var body: some View {
        NavigationStack {
            Form {
                Picker("Category", selection: $category) {
                    ForEach(PostCategory.allCases, id: \.self) { cat in
                        Text(cat.rawValue.capitalized).tag(cat)
                    }
                }
                
                TextEditor(text: $content)
                    .frame(height: 150)
                
                Text("\(content.count)/500")
                    .font(.caption)
                    .foregroundStyle(content.count > 500 ? .red : .secondary)
            }
            .navigationTitle("New Post")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Post") {
                        Task {
                            _ = await viewModel.createPost(content: content, category: category)
                            dismiss()
                        }
                    }
                    .disabled(content.isEmpty || content.count > 500)
                }
            }
            .preferredColorScheme(.dark)
        }
    }
}
