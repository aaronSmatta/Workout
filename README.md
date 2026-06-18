# 运动 Challenge 💪

*Yùn Dòng Challenge — "运动" is Mandarin for "workout / exercise."*

A friendly, mobile-first workout app for the whole family to stay accountable together. Bodyweight + minimal-gear routines that auto-adjust to each person's age group, with set-by-set tracking, rest timers, and gamification (XP, levels, streaks, badges, weekly challenges, and a shared squad leaderboard).

## Files

- **index.html** — the entire app (single file, works offline)
- **supabase_setup.sql** — database schema for cloud sync
- **README.md** — this file

## Run it

Just open `index.html` in any modern browser (or host it on GitHub Pages, Netlify, etc. and share the link). It automatically connects to the shared Supabase cloud project that's already built in — every profile created and every workout logged syncs across devices with no setup for users. Everyone who opens the app shares the same squad and leaderboard.

## Install on your iPhone (Home Screen app)

Open the hosted link in Safari, tap **Share → Add to Home Screen**, then launch it from the icon. It runs full-screen with no browser chrome (a real app feel), uses the app icon and dark theme, and respects the notch / home-indicator safe areas. Files `manifest.webmanifest` and `icon-180/192/512.png` power this — keep them next to `index.html` when hosting. (On Android/Chrome you'll get an "Install app" prompt from the same manifest.)

**Screen stays awake during workouts.** When a workout is running, the app holds a screen Wake Lock so the display won't dim or sleep between sets; it's released automatically when you finish or quit, and re-acquired if you switch away and come back. Uses the standard Wake Lock API (iOS Safari 16.4+, Chrome, Edge); on browsers without it, the app just behaves normally.

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

**Baby mode.** Toggle "👶 Baby mode" on the home screen to work out while holding your little one. Workouts are filtered to standing, stable moves that are safe with a baby in arms (squats, reverse lunges, calf raises, wall sits, a "baby press," gentle marching and mobility) — no jumping or hands-on-the-floor moves. Because holding a baby adds load, reps scale down slightly and every set counts as one impact level harder, so you earn bonus XP and coins for the added challenge. The instructions adapt too (e.g. "hold your baby close to your chest").

**Gamification.** Earn XP per set + completion and perfect-workout bonuses, level up, build daily streaks, unlock 10 badges, and chase a weekly challenge. The **Squad** tab ranks everyone by all-time XP, current streak, or workouts this week.

**Avatar & coins.** Every person gets a cute, calm drawn character (a single layered SVG buddy — not an emoji). Pick a gender (Neutral, Female, or Male) — it gently shapes the character's build, and a companion pet sits in front of your buddy where you can actually see it. Workouts pay **coins** (harder sessions pay more) and every achievement you unlock pays a one-time coin **lump sum** on top. Spend coins in the **Avatar Studio** to dress your buddy up: skin tone and hair/outfit colors are always free (so anyone can make it look like them), while hairstyles, glasses, clothes, hats, extras (headphones, backpack, coffee, scarf, earbuds), companion pets, and background scenes are bought with coins and **unlock as you level up**. Everyone starts with a minimal basic look and builds from there.

## Customizing

- **Add exercises:** add an entry to the `EXERCISES` array in `index.html`.
- **Add routines:** add to the `TEMPLATES` array (list exercise ids for warm/main/cool).
- **Tune intensity:** edit `AGE_GROUPS` (sets, rep multiplier, rest seconds, impact).
- **Badges & rewards:** edit the `BADGES` array — each badge's `coins` field is its one-time achievement payout. Tune `weeklyChallenge()` for the weekly goal.
- **Avatar items:** add to the `SHOP` array (`slot`, `opt` style key, `cost`, `level`). Each `slot` (`hair`, `glasses`, `outfit`, `hat`, `accessory`, `pet`, `bg`) is drawn by the matching `part…()` / `outfitDetail()` / `bgScene()` function in the avatar section — add a `case` there for any new `opt`. Free color palettes live in `SKIN_TONES`, `HAIR_COLORS`, and `OUTFIT_COLORS`.
