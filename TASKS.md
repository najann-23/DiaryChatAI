# DiaryChat — Task Tracker

## Phase 0 — Setup

- [x] README / Master Plan hoàn chỉnh
- [x] Database schema draft (migration SQL)
- [x] .env.local.example
- [x] .gitignore
- [ ] **[NEXT]** Initialize Next.js 15 project với TypeScript
- [ ] Cài đặt dependencies: shadcn/ui, Tailwind, Zustand, Prisma, Supabase client
- [ ] Setup Supabase project trên supabase.com và chạy migration
- [ ] Configure Supabase Auth (Email + Google)
- [ ] Tạo OpenRouter client

## Phase 1 — Basic Chat

- [ ] Auth pages (login / register)
- [ ] Protected route layout
- [ ] Chat UI cơ bản
- [ ] Streaming response từ OpenRouter
- [ ] Lưu conversation vào Supabase
- [ ] Conversation list sidebar

## Phase 2 — Memory Extraction

- [ ] Extraction prompt design
- [ ] Background extraction call sau mỗi tương tác
- [ ] Memory suggestion UI
- [ ] User confirm / reject flow
- [ ] Embed + save vào memory_objects

## Phase 3 — Memory Retrieval

- [ ] Hybrid retrieval function
- [ ] Inject memory vào system prompt
- [ ] AI reference past memories

## Phase 4 — Memory UI

- [ ] Memory list page
- [ ] Edit / delete memory
- [ ] Timeline view

## Phase 5 — Plans & Events

- [ ] Plan/event detection
- [ ] Calendar view
