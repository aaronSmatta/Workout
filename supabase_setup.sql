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
  rest_set      integer,                  -- optional custom rest between sets (sec)
  rest_ex       integer,                  -- optional custom rest between exercises (sec)
  created_at    timestamptz not null default now()
);

-- Safe to re-run on an existing database to add the rest-preference columns:
alter table public.profiles add column if not exists rest_set integer;
alter table public.profiles add column if not exists rest_ex  integer;
-- Saved custom workouts + home-page layout (order / hidden):
alter table public.profiles add column if not exists custom_workouts jsonb;
alter table public.profiles add column if not exists home_prefs      jsonb;
-- Avatar coins economy + owned items + equipped avatar config:
alter table public.profiles add column if not exists coins      integer not null default 0;
alter table public.profiles add column if not exists owned      jsonb;
alter table public.profiles add column if not exists avatar_cfg jsonb;

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

-- ---------- SHARED COMMUNITY EXERCISE LIBRARY ----------------------
create table if not exists public.custom_exercises (
  id          text primary key,
  name        text not null,
  part        text not null,
  emoji       text default '💪',
  base        integer not null default 10,
  unit        text not null default 'reps',   -- reps | sec
  impact      integer not null default 2,
  tip         text,
  created_by  text,
  created_at  timestamptz not null default now()
);

-- ---------- SHARED COMMUNITY WORKOUT PLANS ------------------------
create table if not exists public.shared_workouts (
  id          text primary key,
  name        text not null,
  emoji       text default '🛠️',
  color       text default '#4d7cff',
  descr       text,
  warm        jsonb,
  main        jsonb,
  cool        jsonb,
  created_by  text,
  created_at  timestamptz not null default now()
);

-- ---------- ROW LEVEL SECURITY --------------------------------------
-- This is a friends/family community app: everyone can see everyone for
-- accountability, and write with the public anon key. If you later add
-- Supabase Auth, tighten these policies.
alter table public.profiles enable row level security;
alter table public.workout_logs enable row level security;
alter table public.custom_exercises enable row level security;
alter table public.shared_workouts enable row level security;

drop policy if exists "open read profiles"  on public.profiles;
drop policy if exists "open write profiles" on public.profiles;
drop policy if exists "open read logs"       on public.workout_logs;
drop policy if exists "open write logs"      on public.workout_logs;
drop policy if exists "open read cex"        on public.custom_exercises;
drop policy if exists "open write cex"       on public.custom_exercises;
drop policy if exists "open read sw"         on public.shared_workouts;
drop policy if exists "open write sw"        on public.shared_workouts;

create policy "open read profiles"  on public.profiles      for select using (true);
create policy "open write profiles" on public.profiles      for all    using (true) with check (true);
create policy "open read logs"      on public.workout_logs  for select using (true);
create policy "open write logs"     on public.workout_logs  for all    using (true) with check (true);
create policy "open read cex"       on public.custom_exercises for select using (true);
create policy "open write cex"      on public.custom_exercises for all    using (true) with check (true);
create policy "open read sw"        on public.shared_workouts  for select using (true);
create policy "open write sw"       on public.shared_workouts  for all    using (true) with check (true);

-- Done. Copy your Project URL and anon public key from
-- Project Settings > API. The app (运动 Challenge) connects automatically.
