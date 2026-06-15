-- =====================================================================
-- 运动 Challenge — Supabase setup
-- Run this in your Supabase project: SQL Editor > New query > paste > Run
-- =====================================================================

-- ---------- PROFILES -------------------------------------------------
create table if not exists public.profiles (
  id            uuid primary key default gen_random_uuid(),
  name          text not null,
  age_group     text not null,            -- youth | teenager | young_adult | adult | parent | grandparent
  avatar        text not null default '💪',
  color         text not null default '#ff6b35',
  xp            integer not null default 0,
  streak        integer not null default 0,
  best_streak   integer not null default 0,
  last_workout  date,
  created_at    timestamptz not null default now()
);

-- ---------- WORKOUT LOGS --------------------------------------------
create table if not exists public.workout_logs (
  id            uuid primary key default gen_random_uuid(),
  profile_id    uuid not null references public.profiles(id) on delete cascade,
  workout_name  text not null,
  date          date not null default current_date,
  duration_min  integer not null default 0,
  xp_earned     integer not null default 0,
  total_sets    integer not null default 0,
  done_sets     integer not null default 0,
  details       jsonb,                    -- per-exercise breakdown
  created_at    timestamptz not null default now()
);

create index if not exists workout_logs_profile_idx on public.workout_logs(profile_id);
create index if not exists workout_logs_date_idx on public.workout_logs(date);

-- ---------- ROW LEVEL SECURITY --------------------------------------
-- This is a friends/family community app: everyone can see everyone for
-- accountability, and write with the public anon key. If you later add
-- Supabase Auth, tighten these policies.
alter table public.profiles enable row level security;
alter table public.workout_logs enable row level security;

drop policy if exists "open read profiles"  on public.profiles;
drop policy if exists "open write profiles" on public.profiles;
drop policy if exists "open read logs"       on public.workout_logs;
drop policy if exists "open write logs"      on public.workout_logs;

create policy "open read profiles"  on public.profiles      for select using (true);
create policy "open write profiles" on public.profiles      for all    using (true) with check (true);
create policy "open read logs"      on public.workout_logs  for select using (true);
create policy "open write logs"     on public.workout_logs  for all    using (true) with check (true);

-- Done. Copy your Project URL and anon public key from
-- Project Settings > API. The app (运动 Challenge) connects automatically.
