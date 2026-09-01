import XCTest
@testable import GTA6Companion

@MainActor
final class ViewModelTests: XCTestCase {
    
    func testFeedViewModelInitialState() {
        let viewModel = FeedViewModel()
        XCTAssertTrue(viewModel.posts.isEmpty)
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertNil(viewModel.errorMessage)
    }
    
    func testFetchPosts() async {
        let viewModel = FeedViewModel()
        await viewModel.fetchPosts()
        XCTAssertFalse(viewModel.posts.isEmpty)
        XCTAssertFalse(viewModel.isLoading)
    }
    
    func testWalkthroughViewModelInitialState() {
        let viewModel = WalkthroughViewModel()
        XCTAssertTrue(viewModel.walkthroughs.isEmpty)
        XCTAssertFalse(viewModel.isLoading)
    }
    
    func testLoadWalkthroughs() async {
        let viewModel = WalkthroughViewModel()
        await viewModel.loadWalkthroughs()
        XCTAssertFalse(viewModel.walkthroughs.isEmpty)
        XCTAssertFalse(viewModel.isLoading)
    }
    
    func testTrophyViewModelInitialState() {
        let viewModel = TrophyViewModel()
        XCTAssertTrue(viewModel.trophies.isEmpty)
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertEqual(viewModel.currentPlatform, .playStation)
    }
    
    func testLoadTrophies() async {
        let viewModel = TrophyViewModel()
        await viewModel.loadTrophies()
        XCTAssertFalse(viewModel.trophies.isEmpty)
        XCTAssertFalse(viewModel.isLoading)
    }
    
    func testForumViewModelInitialState() {
        let viewModel = ForumViewModel()
        XCTAssertTrue(viewModel.threads.isEmpty)
        XCTAssertFalse(viewModel.isLoading)
    }
    
    func testLoadForumThreads() async {
        let viewModel = ForumViewModel()
        await viewModel.loadForumThreads()
        XCTAssertFalse(viewModel.threads.isEmpty)
        XCTAssertFalse(viewModel.isLoading)
    }
}
