-- ═══════════════════════════════════════════════════════════
-- نظام الجداول المدرسية — إعداد قاعدة البيانات (Supabase)
-- شغّل هذا الكود في SQL Editor في لوحة تحكم Supabase
-- ═══════════════════════════════════════════════════════════

-- جدول المدارس
create table public.schools (
  id uuid default gen_random_uuid() primary key,
  school_code text unique not null,
  school_name text not null,
  admin_hash text not null,
  created_at timestamptz default now()
);

-- جدول الجداول الدراسية
create table public.schedules (
  id uuid default gen_random_uuid() primary key,
  school_id uuid references public.schools(id) on delete cascade unique,
  schedule_data jsonb not null,
  version int default 1,
  note text default '',
  file_name text default '',
  updated_by text default 'المشرف',
  updated_at timestamptz default now()
);

-- سجل التحديثات
create table public.schedule_history (
  id uuid default gen_random_uuid() primary key,
  school_id uuid references public.schools(id) on delete cascade,
  version int,
  note text,
  file_name text,
  updated_at timestamptz default now()
);

-- تفعيل RLS
alter table public.schools enable row level security;
alter table public.schedules enable row level security;
alter table public.schedule_history enable row level security;

-- سياسات الوصول — المدارس
create policy "select_schools" on public.schools for select using (true);
create policy "insert_schools" on public.schools for insert with check (true);
create policy "update_schools" on public.schools for update using (true);

-- سياسات الوصول — الجداول
create policy "select_schedules" on public.schedules for select using (true);
create policy "insert_schedules" on public.schedules for insert with check (true);
create policy "update_schedules" on public.schedules for update using (true);

-- سياسات الوصول — السجل
create policy "select_history" on public.schedule_history for select using (true);
create policy "insert_history" on public.schedule_history for insert with check (true);
