# 运动 Challenge 💪

*Yùn Dòng Challenge — "运动" is Mandarin for "workout / exercise."*

A friendly, mobile-first workout app for the whole family to stay accountable together. Bodyweight + minimal-gear routines that auto-adjust to each person's age group, with set-by-set tracking, rest timers, and gamification (XP, levels, streaks, badges, weekly challenges, and a shared squad leaderboard).

## Files

- **index.html** — the entire app (single file, works offline)
- **supabase_setup.sql** — database schema for cloud sync
- **README.md** — this file

## Run it

Just open `index.html` in any modern browser (or host it on GitHub Pages, Netlify, etc. and share the link). It automatically connects to the shared Supabase cloud project that's already built in — every profile created and every workout logged syncs across devices with no setup for users. Everyone who opens the app shares the same squad and leaderboard.

## One-time owner setup

The app's Supabase URL and key are already embedded. The only thing the project owner must do once is create the database tables:

1. Open your Supabase project → **SQL Editor → New query**.
2. Paste the contents of `supabase_setup.sql` and click **Run**.

That's it — from then on profiles and progress save to the cloud automatically.

> Note: This is set up for a trusted friends/family group — everyone can see and update everyone's progress with the public anon key. If you want stricter access, add Supabase Auth and tighten the policies in `supabase_setup.sql`. To point at a different project, edit `DEFAULT_CFG` near the top of the script in `index.html`.

## How it works

**Profiles & age groups.** Each person picks an avatar, color, and one of six age groups — Youth, Teenager, Young Adult, Adult, Parent, Grandparent. The age group sets the number of sets, rep targets, rest times, and filters out high-impact moves for the gentler groups. You can change it anytime in Profile.

**Workouts.** Six ready-made routines (Full Body, Upper Body, Legs & Glutes, Core, Cardio, Mobility) plus a custom builder where you pick exactly the exercises and body parts you want. Everything auto-scales to your age group and every workout is capped under 60 minutes (current range ~8–41 min).

**Running a workout.** Each exercise shows its sets, rep/time target, and rest. Check off a set when done — or edit the rep count if you came up short. A full-screen rest timer (with skip and ±15s) runs between sets and exercises automatically.

**Gamification.** Earn XP per set + completion and perfect-workout bonuses, level up, build daily streaks, unlock 10 badges, and chase a weekly challenge. The **Squad** tab ranks everyone by all-time XP, current streak, or workouts this week.

## Customizing

- **Add exercises:** add an entry to the `EXERCISES` array in `index.html`.
- **Add routines:** add to the `TEMPLATES` array (list exercise ids for warm/main/cool).
- **Tune intensity:** edit `AGE_GROUPS` (sets, rep multiplier, rest seconds, impact).
- **Badges & challenge:** edit the `BADGES` array and `weeklyChallenge()`.
