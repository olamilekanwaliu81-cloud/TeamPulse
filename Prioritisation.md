# TeamPulse: Prioritisation

Status: Draft v0.1 | Date: 2026-11-08 | Based on PRD v0.3 | Goal: launch before 1 Jan 2027

## Method

Each feature gets a **Value** score (1-5: how much it helps the leader and the team toward the North Star, monthly check-in completion) and an **Effort** score (1-5: relative build size). **Score = Value / Effort**, then adjusted for dependencies (you can't send questions before members and scheduling exist). The result is grouped with MoSCoW (Must, Should, Could, Later).

## Scored features

| # | Feature | Value | Effort | Score | Priority |
|---|---|---|---|---|---|
| 1 | Calendar-month reporting with the team's 15th countdown label | 5 | 1 | 5.0 | **Must** |
| 2 | Answer forms (number, money, Yes/No, date, text, "Not yet", fixed "I will / I must") | 5 | 2 | 2.5 | **Must** |
| 3 | Editable rank table and rank history | 4 | 2 | 2.0 | **Must** |
| 4 | Answer storage and member history view | 4 | 2 | 2.0 | **Must** |
| 5 | Admin alerts and Monday digest | 4 | 2 | 2.0 | **Must** |
| 6 | Login and roles (Admin, QSM, Member) | 5 | 3 | 1.7 | **Must** |
| 7 | Members, profiles and sponsor/downline tree | 5 | 3 | 1.7 | **Must** |
| 8 | Question library and date scheduler | 5 | 3 | 1.7 | **Must** |
| 9 | Email delivery with secure link, plus reminders | 5 | 3 | 1.7 | **Must** |
| 10 | Leader dashboard (team table, not-replied, unpaid, no income) | 5 | 3 | 1.7 | **Must** |
| 11 | 25th sign-up claim, confirmation queue, second mail | 4 | 3 | 1.3 | **Must** (Release 2) |
| 12 | 100 PPV check, QPV calculation, rank-up recommendations | 4 | 3 | 1.3 | **Must** (Release 2) |
| 13 | Plan versus result (15th plan against the results reported later in the month) | 3 | 2 | 1.5 | Should |
| 14 | Yearly income view per member | 3 | 2 | 1.5 | Should |
| 15 | Audit trail of edits | 2 | 2 | 1.0 | Should |
| 16 | WhatsApp click-to-chat nudge | 3 | 1 | 3.0 | Could (cheap, add if time allows) |
| 17 | CSV export | 2 | 1 | 2.0 | Could |
| 18 | Leaderboard and celebrations | 2 | 2 | 1.0 | Could |
| 19 | New-member onboarding checklist | 2 | 2 | 1.0 | Later |
| 20 | Sales Volume Bonus income estimates | 3 | 3 | 1.0 | Later |
| 21 | Emerald to Diamond ranks | 2 | 3 | 0.7 | Later |
| 22 | WhatsApp Business API automation | 3 | 4 | 0.75 | Later |
| 23 | CashBook | 3 | 4 | 0.75 | Later |
| 24 | Chat box | 3 | 5 | 0.6 | Later |
| 25 | Multi-team (offer to other leaders) | 4 | 5 | 0.8 | Later |
| 26 | Member profile (name, picture, personal details) | 4 | 2 | 2.0 | **Must** |
| 27 | Unique, validated NeoLife ID, read-only for members, Admin-only logged correction | 4 | 2 | 2.0 | **Must** |
| 28 | Add a sign-up any day by Admin, with welcome and congratulation mail | 5 | 2 | 2.5 | **Must** |
| 29 | Team celebration feed (new member and sponsor) | 3 | 2 | 1.5 | **Should** (build with 28) |
| 30 | Sponsor "Report a sign-up" in-app form | 3 | 2 | 1.5 | Should (Release 2, together with 11) |
| 31 | Automatic TeamPulse ID (for example `06OW674`) | 4 | 1 | 4.0 | **Must** |
| 32 | Pending/Active accounts, Admin activation notification and automatic activation rule | 4 | 2 | 2.0 | **Must** |
| 33 | Sign in with TeamPulse ID and password, first-password link, reset by email and lock after 5 wrong tries | 5 | 3 | 1.7 | **Must** |
| 34 | First-order PV recorded at sign-up as the new member's PPV | 4 | 1 | 4.0 | **Must** |
| 35 | Payout questions on the 10th (delivered orders, amount that will drop, date) and the "Money dropping soon" list | 4 | 1 | 4.0 | **Must** |
| 36 | Answer windows: opens 2 days before, closes 3 days after, locked and Missed states, late answers counted for the right month | 5 | 2 | 2.5 | **Must** |
| 37 | Landing page with sign-in and a section for team leaders | 4 | 2 | 2.0 | **Must** |
| 38 | Team leader registration (own account, own team space) | 4 | 2 | 2.0 | **Must** |
| 39 | Admin resets a member's password | 3 | 1 | 3.0 | **Must** |

## Why the order differs from the raw scores

- **Dependencies come first.** Login, members, the tree and the scheduler must exist before any question can be sent, even though their ratio is lower than small items.
- **Release 2 features (11 and 12)** have high value but sit on top of the core: the downline tree, stored PPV and the rank table. Building them second keeps the first launch small and safe.
- **WhatsApp click-to-chat (16)** scores high because it is one link per message. It is a "Could" because email already reaches the team, but it is the first thing to add if time allows.
- **CashBook, chat and multi-team** are your own stated future plans. They are deliberately outside this launch, but the data model leaves room for them.

## Release plan against the deadline

Dates are targets assuming steady work. Effort scores are relative, not hours.

| Release | Contents | Target |
|---|---|---|
| **Prototype** | Clickable screens for the Must-have flows, tested with you and 2 to 3 team members | Week of 9 Nov to 20 Nov |
| **Release 1: Core check-ins** | Features 1 to 10, plus profiles, IDs, activation, and adding a sign-up any day with its welcome mail and team celebration (26 to 29 and 31 to 39) | Go-live by **12 Dec 2026**, so the 14th question (opens 12 Dec) and the 15th plan (opens 13 Dec) run through the system |
| **Release 2: Sign-ups and ranks** | Features 11 and 12 | By **23 Dec 2026**, before the first real sign-up question opens (question date 25 Dec, window 23 to 28 Dec) |
| **After launch** | Should and Could items, based on what the team actually uses | January 2027 |

Why 12 December: with the answer windows, the 14th question opens on 12 December and the 15th plan on 13 December, so going live by the 12th makes them the first live check-ins, and it leaves almost three weeks of buffer before 1 January. If Release 1 slips, the fallback is to run the 15th plan form first and add the 10th and weekly questions afterward.

## Risks to the schedule

| Risk | Response |
|---|---|
| Email delivery needs a verified sender domain, which can take days | Start the domain and email setup in week 1 |
| Rank rules or sign-up details change after the build starts | They are editable data and form fields, not fixed code |
| Team members don't answer in the first month | Use the reminders, plus a personal WhatsApp nudge from you for the first month |
| Scope grows | Anything not in features 1 to 12 waits until after launch unless it replaces something of equal size |

## Decisions needed from you

1. Do you agree that **Release 1 (14 Dec) and Release 2 (28 Dec)** is the right split?
2. Should the **WhatsApp click-to-chat nudge** go in Release 1 if time allows?
3. Do you want me to start on the **clickable prototype** now?
