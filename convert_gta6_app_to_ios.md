# GTA 6 Walkthrough App - iOS Conversion Specification

## Project Overview

**App Name:** Vice City Companion  
**Target Platform:** iOS 16+  
**Target Framework:** SwiftUI + Swift  
**Architecture:** MVVM  
**Backend:** Cloudflare Workers API  

---

## 1. Core Features & Functionality

### 1.1 Authentication System
- **Sign In / Registration** screen with email and password
- **Persistent authentication** using Keychain
- **Session management** with token refresh
- **Profile access** after authentication
- **Sign out functionality**

### 1.2 Feed & Community (Home Screen)
- **Real-time feed** of posts from community members
- **Post categories:** News, Guides, Discussions
- **Tab navigation:** All / News / Guides / Discussions
- **Create post** functionality (500 character limit)
- **Post display elements:**
  - Author name & avatar
  - Post content
  - Timestamp (formatted as "MM/DD/YYYY, HH:MM:SS AM/PM")
  - Post category badge (NEWS, GUIDES, DISCUSSIONS)
  - Like/Comment/Share buttons
  - Character counter for composition
- **Pull-to-refresh** functionality
- **Pagination/Infinite scroll** for feed loading

### 1.3 Walkthroughs Section
- **List view** of available mission guides
- **Search functionality** within guides
- **Guide detail view** showing:
  - Mission name & description
  - Step-by-step walkthrough
  - Tips and tricks
  - Screenshots/media (if available)
  - Collectibles locations
- **Filter by difficulty** (Easy, Medium, Hard)
- **Save/Bookmark** guides (requires auth)

### 1.4 Trophies/Achievements
- **Requires authentication**
- **Platform selection:** Steam, PSN, Xbox
- **Trophy/Achievement list** for each platform
- **Progress tracking** (earned vs total)
- **Trophy rarity** display
- **Unlock date** for earned trophies
- **Grid or list view** toggle

### 1.5 Forum/Discussions
- **Thread list view** with categories
- **Create new thread** (requires auth)
- **Thread detail view** showing:
  - Original post
  - Replies in chronological order
  - Author profiles
  - Timestamps
  - Like/reply counts
- **Reply composition** with character limit
- **Sort options:** Recent, Popular, Trending

### 1.6 User Profile
- **Profile page** showing:
  - User avatar
  - Username
  - Join date
  - Post count / Trophy count / Guide contributions
  - Bio/About section
- **Account settings:**
  - Change password
  - Email preferences
  - Notification settings
  - Privacy settings
- **Sign out** button

---

## 2. Data Models

### User
```swift
struct User {
    let id: String
    let username: String
    let email: String
    let avatar: URL?
    let joinDate: Date
    let bio: String?
    let postCount: Int
    let trophyCount: Int
    let contributedGuides: Int
}
```

### Post/FeedItem
```swift
struct Post {
    let id: String
    let author: User
    let content: String
    let category: PostCategory  // enum: news, guide, discussion
    let timestamp: Date
    let likes: Int
    let comments: Int
    let shares: Int
    let liked: Bool  // Current user's interaction
}
```

### Walkthrough
```swift
struct Walkthrough {
    let id: String
    let title: String
    let description: String
    let difficulty: Difficulty  // Easy, Medium, Hard
    let steps: [WalkthroughStep]
    let collectibles: [Collectible]
    let estimatedTime: TimeInterval
    let author: User
    let rating: Double
    let reviews: Int
}
```

### Trophy/Achievement
```swift
struct Trophy {
    let id: String
    let name: String
    let description: String
    let icon: URL
    let rarity: String  // Common, Uncommon, Rare, Epic, Legendary
    let platform: Platform  // Steam, PSN, Xbox
    let earned: Bool
    let unlockedDate: Date?
    let progress: Double?  // For cumulative trophies
}
```

### ForumThread
```swift
struct ForumThread {
    let id: String
    let title: String
    let author: User
    let content: String
    let category: String
    let timestamp: Date
    let replies: Int
    let views: Int
    let replies: [Reply]
    let pinned: Bool
}

struct Reply {
    let id: String
    let author: User
    let content: String
    let timestamp: Date
    let likes: Int
}
```

---

## 3. Network API Mapping

### Base URL
```
https://gta6walkthroughapp.shayveetake2.workers.dev/
```

### Endpoints (Assumed Cloudflare Workers routes)

#### Authentication
- `POST /api/auth/login` - User login
- `POST /api/auth/register` - User registration
- `POST /api/auth/logout` - User logout
- `POST /api/auth/refresh` - Refresh token
- `GET /api/auth/profile` - Get current user profile

#### Feed/Posts
- `GET /api/posts` - Get feed posts (with pagination)
- `GET /api/posts?category=news` - Get posts by category
- `POST /api/posts` - Create new post
- `DELETE /api/posts/{id}` - Delete post
- `POST /api/posts/{id}/like` - Like post
- `POST /api/posts/{id}/comment` - Add comment

#### Walkthroughs
- `GET /api/walkthroughs` - Get all walkthroughs
- `GET /api/walkthroughs/{id}` - Get walkthrough details
- `POST /api/walkthroughs` - Create walkthrough
- `POST /api/walkthroughs/{id}/bookmark` - Bookmark guide

#### Trophies
- `GET /api/trophies/{platform}` - Get trophies for platform
- `GET /api/trophies/{platform}/{userId}` - Get user trophies

#### Forum
- `GET /api/threads` - Get forum threads
- `GET /api/threads/{id}` - Get thread details
- `POST /api/threads` - Create new thread
- `POST /api/threads/{id}/reply` - Add reply

---

## 4. UI/UX Requirements

### Color Scheme
- **Primary:** GTA 6 Vice City Theme (Purple/Teal/Dark)
- **Secondary:** Accent colors for buttons and highlights
- **Background:** Dark mode preferred
- **Text:** High contrast white on dark backgrounds

### Typography
- **App Font:** System font (San Francisco)
- **Heading:** Bold, 18-22pt
- **Body:** Regular, 14-16pt
- **Caption:** Light, 12pt

### Layout Guidelines
- **Safe area padding:** 16pt horizontal, 8pt vertical
- **Component spacing:** 12pt between elements
- **Corner radius:** 8-12pt for rounded elements
- **Shadow depth:** Subtle elevation for cards

### Navigation Flow
```
Launch
  ├─→ Auth State Check
  │   ├─→ Logged In → RootTabView
  │   └─→ Not Logged In → LoginView
  │
  └─→ RootTabView (5 tabs)
      ├─→ Feed (Home)
      ├─→ Walkthroughs (Guides)
      ├─→ Trophies (Sign-in required)
      ├─→ Forum (Discussions)
      └─→ Profile (Account)
```

### Key Screens

#### 1. Login/Register Screen
- Email input field
- Password input field
- Sign In / Register buttons
- "Forgot Password" link
- Social login options (optional)

#### 2. Feed Screen
- Tab navigation (All, News, Guides, Discussions)
- Post list with infinite scroll
- Pull-to-refresh
- Create post button (floating or top bar)

#### 3. Walkthrough List
- Search bar
- Filter options (difficulty)
- Walkthrough cards (title, difficulty, rating)
- Tap to view details

#### 4. Trophy List
- Platform selector (Steam, PSN, Xbox)
- Grid view of trophies
- Earned vs locked visual distinction
- Progress bar for cumulative trophies

#### 5. Forum
- Thread list with search
- Thread preview cards
- Tap to open thread detail with replies

#### 6. User Profile
- User info header
- Stats section (posts, trophies, guides)
- Recent activity
- Settings & Sign Out

---

## 5. Technical Architecture

### State Management
- Use `@Observable` macro (iOS 17+) or `@StateObject` + `@Published` (iOS 16)
- One ViewModel per major screen
- RootViewModel for app-wide state (authentication, theme)

### Networking
- URLSession with async/await
- Custom APIClient wrapper
- Request/response interceptors for auth tokens
- Error handling with custom error types
- Image caching for avatars and content

### Local Storage
- UserDefaults for app preferences
- Keychain for authentication tokens
- Core Data or SwiftData (optional) for offline caching

### Error Handling
- Network error states displayed to user
- Retry mechanisms for failed requests
- User-friendly error messages
- Loading states during API calls

---

## 6. Phase Breakdown for Development

### Phase 1: Foundation
- App entry point & navigation structure
- Authentication screens & logic
- Basic network infrastructure
- Mock data setup

### Phase 2: Core Features
- Feed implementation with CRUD operations
- Walkthrough browsing
- Forum basics

### Phase 3: Advanced Features
- Trophies integration
- User profiles
- Search & filtering
- Bookmarking & favoriting

### Phase 4: Polish
- Error handling refinement
- Loading states & animations
- Performance optimization
- Accessibility improvements

---

## 7. Deployment & Testing

### Testing Requirements
- Unit tests for ViewModels
- Integration tests for API calls
- UI tests for critical flows
- Preview tests for all screens

### Deployment Checklist
- [ ] Code review & lint
- [ ] All features tested
- [ ] Error cases handled
- [ ] Performance optimized
- [ ] Accessibility checked
- [ ] App Store metadata prepared
- [ ] Privacy policy & terms
- [ ] TestFlight build validated

---

## 8. Success Criteria

✅ All website features work identically in iOS app  
✅ MVVM architecture strictly followed  
✅ 100% SwiftUI implementation  
✅ Smooth animations & transitions  
✅ Proper error handling  
✅ Offline support (optional caching)  
✅ iOS 16+ compatibility  
✅ Dark mode by default  
✅ App Store ready

---

**Document Version:** 1.0  
**Last Updated:** 2026-09-01  
**Status:** Ready for Development
