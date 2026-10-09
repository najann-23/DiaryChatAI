-- Enable pgvector extension
CREATE EXTENSION IF NOT EXISTS vector;

-- Profiles (extends Supabase auth.users)
CREATE TABLE profiles (
  id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
  display_name TEXT,
  avatar_url TEXT,
  timezone TEXT DEFAULT 'Asia/Ho_Chi_Minh',
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Conversations
CREATE TABLE conversations (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  title TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Messages (conversation history - immutable by AI)
CREATE TABLE messages (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  conversation_id UUID NOT NULL REFERENCES conversations(id) ON DELETE CASCADE,
  user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  role TEXT NOT NULL CHECK (role IN ('user', 'assistant')),
  content TEXT NOT NULL,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  embedding VECTOR(384)  -- supabase/gte-small output dim
);

-- Memory objects (extracted, user-confirmed)
CREATE TABLE memory_objects (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  type TEXT NOT NULL CHECK (type IN ('person','place','event','emotion','habit','preference','goal','fact')),
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

-- Core memory links (semantic/temporal connections)
CREATE TABLE core_memory_links (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  memory_a_id UUID NOT NULL REFERENCES memory_objects(id) ON DELETE CASCADE,
  memory_b_id UUID NOT NULL REFERENCES memory_objects(id) ON DELETE CASCADE,
  link_type TEXT CHECK (link_type IN ('related','continuation','contradiction')),
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Plans and Events
CREATE TABLE plans_events (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  title TEXT NOT NULL,
  description TEXT,
  type TEXT NOT NULL CHECK (type IN ('plan','event')),
  status TEXT DEFAULT 'pending' CHECK (status IN ('pending','done','cancelled')),
  scheduled_at TIMESTAMPTZ,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Indexes for vector search
CREATE INDEX messages_embedding_idx ON messages USING ivfflat (embedding vector_cosine_ops);
CREATE INDEX memory_objects_embedding_idx ON memory_objects USING ivfflat (embedding vector_cosine_ops);

-- RLS Policies: users only see their own data
ALTER TABLE profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE conversations ENABLE ROW LEVEL SECURITY;
ALTER TABLE messages ENABLE ROW LEVEL SECURITY;
ALTER TABLE memory_objects ENABLE ROW LEVEL SECURITY;
ALTER TABLE core_memory_links ENABLE ROW LEVEL SECURITY;
ALTER TABLE plans_events ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can manage own profile" ON profiles FOR ALL USING (auth.uid() = id);
CREATE POLICY "Users can manage own conversations" ON conversations FOR ALL USING (auth.uid() = user_id);
CREATE POLICY "Users can manage own messages" ON messages FOR ALL USING (auth.uid() = user_id);
CREATE POLICY "Users can manage own memory_objects" ON memory_objects FOR ALL USING (auth.uid() = user_id);
CREATE POLICY "Users can manage own core_memory_links" ON core_memory_links FOR ALL USING (auth.uid() = user_id);
CREATE POLICY "Users can manage own plans_events" ON plans_events FOR ALL USING (auth.uid() = user_id);

-- Auto-create profile on signup
CREATE OR REPLACE FUNCTION handle_new_user()
RETURNS TRIGGER AS $$
BEGIN
  INSERT INTO profiles (id, display_name)
  VALUES (NEW.id, NEW.raw_user_meta_data->>'full_name');
  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

CREATE TRIGGER on_auth_user_created
  AFTER INSERT ON auth.users
  FOR EACH ROW EXECUTE FUNCTION handle_new_user();
