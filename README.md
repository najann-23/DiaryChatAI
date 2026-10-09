# DiaryChatAI — Master Plan

> AI companion giúp người dùng viết nhật ký, ghi nhớ và tái dựng câu chuyện cuộc sống qua hội thoại tự nhiên.

---

## 1. Vision

DiaryChat là một **AI companion có memory dài hạn**, được xây dựng để trò chuyện với người dùng như một người bạn thân — ghi nhớ, kết nối và gợi nhớ những câu chuyện người dùng đã chia sẻ theo thời gian.

**Mục tiêu cốt lõi:**
- Trò chuyện tự nhiên, thân thiện, như người bạn thực sự.
- Ghi nhớ sự kiện, cảm xúc và thông tin người dùng chia sẻ.
- Kết nối quá khứ và hiện tại khi context liên quan.
- Trao quyền kiểm soát memory hoàn toàn cho người dùng.

---

## 2. Key Principles

| Nguyên tắc | Mô tả |
|---|---|
| **User Consent** | Người dùng phải xác nhận trước khi thông tin trở thành memory dài hạn |
| **No Hallucination** | AI không được biến suy luận thành sự thật |
| **Data Immutability** | Conversation gốc không bị AI tự ý sửa |
| **User Control** | Người dùng có quyền xem, sửa và xóa memory bất kỳ lúc nào |
| **Timeline Accuracy** | Timeline phải giữ đúng mức độ chính xác của thời gian được ghi nhận |
| **Retrospective Memory** | Memory có thể được bổ sung vào các sự kiện trong quá khứ |
| **Hybrid Retrieval** | Semantic + keyword + temporal retrieval |
| **AI as Advisor** | AI hỗ trợ và đưa ra gợi ý, không thay người dùng quyết định |

---

## 3. Memory Architecture

DiaryChat sử dụng 4 layer memory phân cấp:

```
CONVERSATION  →  MEMORY OBJECTS  →  CORE MEMORY  →  PLAN & EVENT
(dữ liệu gốc)   (trích xuất)        (kết nối)        (tương lai)
```

### Memory Object Types
- `person` — người được đề cập
- `place` — địa điểm
- `event` — sự kiện đã xảy ra
- `emotion` — cảm xúc đáng chú ý
- `habit` — thói quen, routine
- `preference` — sở thích, ghét
- `goal` — mục tiêu, kế hoạch dài hạn
- `fact` — thông tin sự thật về người dùng

---

## 4. Tech Stack (Confirmed)

| Layer | Công nghệ | Ghi chú |
|---|---|---|
| **Frontend + API Routes** | Next.js 15 (App Router) | Full-stack monorepo |
| **Language** | TypeScript | Strict mode |
| **UI Components** | shadcn/ui + Tailwind CSS | |
| **State Management** | Zustand | Client state |
| **Database** | Supabase (PostgreSQL) | Cloud-hosted |
| **Vector Search** | Supabase pgvector + gte-small | Built-in embedding, miễn phí |
| **ORM** | Prisma | Schema-first, type-safe |
| **Auth** | Supabase Auth | Email + Google OAuth |
| **AI Chat** | OpenRouter API | nvidia/nemotron-3-nano-omni-30b-a3b-reasoning:free |
| **Embeddings** | Supabase `supabase/gte-small` | 384 dimensions |
| **Deployment** | Vercel | |

---

## 5. Database Schema (Draft)

### profiles
```sql
CREATE TABLE profiles (
  id UUID PRIMARY KEY REFERENCES auth.users(id),
  display_name TEXT,
  avatar_url TEXT,
  timezone TEXT DEFAULT 'Asia/Ho_Chi_Minh',
  created_at TIMESTAMPTZ DEFAULT NOW()
);
```

### conversations
```sql
CREATE TABLE conversations (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES auth.users(id),
  title TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);
```

### messages
```sql
CREATE TABLE messages (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  conversation_id UUID NOT NULL REFERENCES conversations(id) ON DELETE CASCADE,
  user_id UUID NOT NULL REFERENCES auth.users(id),
  role TEXT NOT NULL CHECK (role IN ('user', 'assistant')),
  content TEXT NOT NULL,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  embedding VECTOR(384)
);
```

### memory_objects
```sql
CREATE TABLE memory_objects (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES auth.users(id),
  type TEXT NOT NULL,
  title TEXT NOT NULL,
  content TEXT NOT NULL,
  source_message_ids UUID[],
  confirmed BOOLEAN DEFAULT FALSE,
  date_context DATE,
  tags TEXT[],
  embedding VECTOR(384),
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);
```

### core_memory_links
```sql
CREATE TABLE core_memory_links (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES auth.users(id),
  memory_a_id UUID NOT NULL REFERENCES memory_objects(id),
  memory_b_id UUID NOT NULL REFERENCES memory_objects(id),
  link_type TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW()
);
```

### plans_events
```sql
CREATE TABLE plans_events (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES auth.users(id),
  title TEXT NOT NULL,
  description TEXT,
  type TEXT NOT NULL CHECK (type IN ('plan', 'event')),
  status TEXT DEFAULT 'pending',
  scheduled_at TIMESTAMPTZ,
  created_at TIMESTAMPTZ DEFAULT NOW()
);
```

---

## 6. Project Structure (Target)

```
diarychat/
├── app/
│   ├── (auth)/
│   │   ├── login/page.tsx
│   │   └── register/page.tsx
│   ├── (app)/
│   │   ├── chat/
│   │   │   ├── page.tsx
│   │   │   └── [id]/page.tsx
│   │   ├── memory/page.tsx
│   │   └── layout.tsx
│   ├── api/
│   │   ├── chat/route.ts
│   │   ├── memory/route.ts
│   │   └── conversations/route.ts
│   └── layout.tsx
├── components/
│   ├── chat/
│   │   ├── ChatWindow.tsx
│   │   ├── MessageBubble.tsx
│   │   ├── ChatInput.tsx
│   │   └── MemorySuggestion.tsx
│   ├── memory/
│   │   ├── MemoryList.tsx
│   │   └── MemoryCard.tsx
│   └── ui/
├── lib/
│   ├── supabase/
│   │   ├── client.ts
│   │   └── server.ts
│   ├── openrouter/
│   │   └── client.ts
│   ├── memory/
│   │   ├── extract.ts
│   │   ├── retrieve.ts
│   │   └── embed.ts
│   └── prompts/
│       ├── system.ts
│       └── extraction.ts
├── hooks/
│   ├── useChat.ts
│   └── useMemory.ts
├── store/
│   └── chatStore.ts
├── types/
│   └── index.ts
├── supabase/
│   └── migrations/
├── .env.local.example
└── README.md
```

---

## 7. MVP Roadmap

### Phase 0 — Setup
- [x] Define vision & principles
- [x] Finalize tech stack
- [ ] Initialize Next.js 15 project
- [ ] Setup Supabase project + run migrations
- [ ] Configure auth flow (Supabase Auth)
- [ ] Setup OpenRouter client

### Phase 1 — Basic Chat
- [ ] Auth pages (login/register)
- [ ] Chat UI (send message, display streaming response)
- [ ] Save conversation to Supabase
- [ ] Conversation list sidebar

### Phase 2 — Memory Extraction (Core)
- [ ] AI extracts memory objects from conversation
- [ ] Memory suggestion UI (user confirms/rejects)
- [ ] Save confirmed memories + embed with Supabase

### Phase 3 — Memory Retrieval
- [ ] Hybrid retrieval: semantic + keyword + recency
- [ ] Inject relevant memories into AI context
- [ ] AI references past memories in responses

### Phase 4 — Memory Management UI
- [ ] View / edit / delete memory objects
- [ ] Memory timeline view
- [ ] Core memory links

### Phase 5 — Plans & Events
- [ ] Detect and save plans/events from conversation
- [ ] Calendar-like view

---

## 8. AI Behavior Design

### Memory Extraction Flow
```
User message
     ↓
AI responds (streaming)
     ↓
[Background] Extraction call → identify memory candidates
     ↓
Show memory suggestion chip to user (non-blocking)
     ↓
User confirms → embed + save | User rejects → discard
```

### Retrieval Flow
```
User sends message → embed message
     ↓
Vector similarity search on memory_objects
     ↓
Keyword match on recent memories
     ↓
Merge + rank → top 5-10 memories
     ↓
Inject into system prompt context
```

---

## 9. Environment Variables

```env
# Supabase
NEXT_PUBLIC_SUPABASE_URL=
NEXT_PUBLIC_SUPABASE_ANON_KEY=
SUPABASE_SERVICE_ROLE_KEY=

# OpenRouter
OPENROUTER_API_KEY=

# App
NEXT_PUBLIC_APP_URL=http://localhost:3000
```

---

## 10. Open Questions

| # | Câu hỏi | Ưu tiên |
|---|---|---|
| 1 | Model backup nếu nemotron không đủ context? | High |
| 2 | Số messages tối đa trong 1 context window? | High |
| 3 | Memory extraction: gọi API riêng hay cùng 1 call? | Medium |
| 4 | UI language: tiếng Việt hay English? | Medium |
| 5 | AI persona: có tên không, hay neutral? | Low |

---

*Last updated: 2025-10 | Status: Phase 0 — Setup in progress*
