# GTA6 Companion iOS - API Documentation

## Base URL
```
https://gta6walkthroughapp.shayveetake2.workers.dev
```

## Authentication

### Login
```
POST /api/auth/login
Content-Type: application/json

Request:
{
  "email": "user@example.com",
  "password": "password123"
}

Response (200):
{
  "token": "eyJhbGc...",
  "user": {
    "id": "user_001",
    "username": "john_doe",
    "email": "user@example.com",
    "avatar": "https://...",
    "joinDate": "2024-01-15T10:00:00Z",
    "bio": "Bio text",
    "postCount": 42,
    "trophyCount": 87,
    "contributedGuides": 5
  }
}
```

### Register
```
POST /api/auth/register
Content-Type: application/json

Request:
{
  "username": "john_doe",
  "email": "user@example.com",
  "password": "password123"
}

Response (200):
{
  "token": "eyJhbGc...",
  "user": { ... }
}
```

### Get Current User
```
GET /api/auth/profile
Authorization: Bearer {token}

Response (200):
{
  "id": "user_001",
  "username": "john_doe",
  "email": "user@example.com",
  "avatar": "https://...",
  "joinDate": "2024-01-15T10:00:00Z",
  "bio": "Bio text",
  "postCount": 42,
  "trophyCount": 87,
  "contributedGuides": 5
}
```

### Logout
```
POST /api/auth/logout
Authorization: Bearer {token}

Response (200):
{
  "message": "Logged out successfully"
}
```

---

## Feed / Posts

### Get Posts
```
GET /api/posts?page=0&category=NEWS
Authorization: Bearer {token}

Response (200):
{
  "posts": [
    {
      "id": "post_001",
      "author": { ... },
      "content": "Post content",
      "category": "NEWS",
      "timestamp": "2026-09-01T11:00:00Z",
      "likes": 24,
      "comments": 5,
      "shares": 2,
      "liked": false
    }
  ],
  "total": 100,
  "page": 0
}
```

### Create Post
```
POST /api/posts
Authorization: Bearer {token}
Content-Type: application/json

Request:
{
  "content": "My new post",
  "category": "NEWS"
}

Response (201):
{
  "id": "post_001",
  "author": { ... },
  "content": "My new post",
  "category": "NEWS",
  "timestamp": "2026-09-01T11:30:00Z",
  "likes": 0,
  "comments": 0,
  "shares": 0,
  "liked": false
}
```

### Like Post
```
POST /api/posts/{id}/like
Authorization: Bearer {token}

Response (200):
{
  "liked": true
}
```

### Delete Post
```
DELETE /api/posts/{id}
Authorization: Bearer {token}

Response (204)
```

---

## Walkthroughs

### Get Walkthroughs
```
GET /api/walkthroughs?page=0
Authorization: Bearer {token}

Response (200):
{
  "walkthroughs": [
    {
      "id": "walk_001",
      "title": "Main Story Walkthrough",
      "description": "...",
      "difficulty": "Medium",
      "steps": [],
      "collectibles": [],
      "estimatedTime": 3600,
      "author": { ... },
      "rating": 4.8,
      "reviews": 234,
      "bookmarked": false
    }
  ],
  "total": 50,
  "page": 0
}
```

### Get Walkthrough Detail
```
GET /api/walkthroughs/{id}
Authorization: Bearer {token}

Response (200):
{
  "id": "walk_001",
  "title": "Main Story Walkthrough",
  "description": "...",
  "difficulty": "Medium",
  "steps": [
    {
      "id": "step_001",
      "stepNumber": 1,
      "title": "Step Title",
      "description": "Step description",
      "tips": ["Tip 1", "Tip 2"]
    }
  ],
  "collectibles": [
    {
      "id": "coll_001",
      "name": "Hidden Package",
      "description": "...",
      "location": "Docks",
      "latitude": 25.7617,
      "longitude": -80.1918,
      "collected": false
    }
  ],
  "estimatedTime": 3600,
  "author": { ... },
  "rating": 4.8,
  "reviews": 234,
  "bookmarked": false
}
```

### Bookmark Walkthrough
```
POST /api/walkthroughs/{id}/bookmark
Authorization: Bearer {token}

Response (200):
{
  "bookmarked": true
}
```

---

## Trophies

### Get Trophies by Platform
```
GET /api/trophies/{platform}?page=0
Authorization: Bearer {token}

Platforms: Steam, PlayStation, Xbox

Response (200):
{
  "trophies": [
    {
      "id": "trophy_001",
      "name": "Welcome to Vice City",
      "description": "Complete the first mission",
      "icon": "https://...",
      "rarity": "Common",
      "platform": "PlayStation",
      "earned": true,
      "unlockedDate": "2026-08-25T10:00:00Z",
      "progress": null
    }
  ],
  "total": 40,
  "earned": 12
}
```

---

## Forum

### Get Forum Threads
```
GET /api/threads?page=0&category=Gameplay
Authorization: Bearer {token}

Response (200):
{
  "threads": [
    {
      "id": "thread_001",
      "title": "Thread Title",
      "author": { ... },
      "content": "Thread content",
      "category": "Gameplay",
      "timestamp": "2026-09-01T00:00:00Z",
      "replies": [],
      "views": 123,
      "pinned": false
    }
  ],
  "total": 250,
  "page": 0
}
```

### Get Thread Detail
```
GET /api/threads/{id}
Authorization: Bearer {token}

Response (200):
{
  "id": "thread_001",
  "title": "Thread Title",
  "author": { ... },
  "content": "Thread content",
  "category": "Gameplay",
  "timestamp": "2026-09-01T00:00:00Z",
  "replies": [
    {
      "id": "reply_001",
      "author": { ... },
      "content": "Reply content",
      "timestamp": "2026-09-01T01:00:00Z",
      "likes": 5,
      "liked": false
    }
  ],
  "views": 150,
  "pinned": false
}
```

### Create Thread
```
POST /api/threads
Authorization: Bearer {token}
Content-Type: application/json

Request:
{
  "title": "Thread Title",
  "content": "Thread content",
  "category": "Gameplay"
}

Response (201):
{
  "id": "thread_001",
  "title": "Thread Title",
  "author": { ... },
  "content": "Thread content",
  "category": "Gameplay",
  "timestamp": "2026-09-01T00:00:00Z",
  "replies": [],
  "views": 0,
  "pinned": false
}
```

### Reply to Thread
```
POST /api/threads/{id}/reply
Authorization: Bearer {token}
Content-Type: application/json

Request:
{
  "content": "Reply content"
}

Response (201):
{
  "id": "reply_001",
  "author": { ... },
  "content": "Reply content",
  "timestamp": "2026-09-01T01:00:00Z",
  "likes": 0,
  "liked": false
}
```

---

## Error Responses

### 401 Unauthorized
```
{
  "error": "Unauthorized",
  "message": "Invalid or missing token"
}
```

### 404 Not Found
```
{
  "error": "Not Found",
  "message": "Resource not found"
}
```

### 500 Internal Server Error
```
{
  "error": "Internal Server Error",
  "message": "An unexpected error occurred"
}
```

---

## Rate Limiting

- Limit: 100 requests per minute per IP
- Headers: `X-RateLimit-Limit`, `X-RateLimit-Remaining`, `X-RateLimit-Reset`

---

## Postman Collection

Import the following JSON into Postman:

```json
{
  "info": {
    "name": "GTA6 Companion API",
    "schema": "https://schema.getpostman.com/json/collection/v2.1.0/collection.json"
  },
  "item": [
    {
      "name": "Auth",
      "item": [
        {
          "name": "Login",
          "request": {
            "method": "POST",
            "url": "https://gta6walkthroughapp.shayveetake2.workers.dev/api/auth/login",
            "body": {
              "mode": "raw",
              "raw": "{\"email\": \"test@example.com\", \"password\": \"password\"}"
            }
          }
        }
      ]
    }
  ]
}
```

---

## Testing

Use the following credentials for testing:
- **Email:** test@example.com
- **Password:** password123
- **Username:** testuser

---

**Last Updated:** 2026-09-01
**API Version:** 1.0
