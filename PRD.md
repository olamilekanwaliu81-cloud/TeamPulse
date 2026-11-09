# TeamPulse (working name): Product Requirements Document

Status: Draft v0.11 | Date: 2026-11-08 | Owner: Team Leader (Admin) | Target launch: before 1 Jan 2027

---

## 1. Overview

TeamPulse is a team management system for a Neolife International network-marketing team. It sends scheduled check-in questions to each distributor, stores every answer on that person's profile, recognises their rank, and gives the leader (and each QSM, for their own downline) a dashboard of performance, payments and goals.

## 2. Problem statement

- The leader collects performance data one-on-one, over WhatsApp, or on paper. It is not trackable over time.
- The same questions are asked every week and month, which is tiring and inconsistent.
- It is hard to recall who is falling behind, so problems are found late. The leader has already lost track of members' performance.
- Evidence: the leader's own account (12 distributors, no central record).

## 3. Vision, mission, goals

- **Vision:** Empower network-marketing leaders and their teams to grow with clarity and consistency through simple monthly accountability.
- **Mission:** Automatically ask each distributor the right questions at the right time, keep every answer in one place, and show leaders who needs coaching, who is growing and who is ready to step up.
- **North Star Metric:** Monthly check-in completion rate (share of scheduled questions answered by distributors).
- **Hypotheses**
  - H1: Short, timed questions on channels the team already uses (Gmail and WhatsApp) will reach 75-80% completion.
  - H2: A single dashboard lets the leader find who needs coaching sooner than manual follow-up.
  - H3: Comparing the 15th plan with the results reported later in the month improves goal achievement.
  - H4: Distributors who can see their own history stay engaged enough to keep answering.
  - H5: A two-step sign-up flow (claim, leader confirms, then details) keeps the downline tree accurate, so QPV and rank progress can be calculated automatically instead of by hand.
- **OKR (first 3 months after launch)**
  - Objective: Make the leader's weekly and monthly team follow-up consistent and effortless.
  - KR1: 75-80% monthly check-in completion.
  - KR2: Leader opens the dashboard at least once a week for 12 consecutive weeks.
  - KR3: 100% of active distributors have a profile with a correct rank.
  - KR4: Unpaid monthly responsibility is identified for 100% of the team once the 28th question's window closes (the 31st) each month.
- **KPIs:** response rate per question type, time to respond, reminder-to-answer conversion, members with no answer for 2+ months, active users per week.

## 4. Personas

| Persona | Needs |
|---|---|
| **Team Leader (Admin)**, e.g. you | See every member, their rank and trend. Know who to coach, mentor or promote. Stop re-asking the same questions. Be alerted to check in. |
| **Admin (added by an Admin only)** | Same management view as the leader. Only an Admin can create another Admin. |
| **QSM (Qualified Senior Manager)** | See only their own downline's performance. |
| **Distributor / Manager / Executive** | Receive questions, answer quickly, see their own history and progress. |

Current team: 7 Distributors, 2 Managers, 2 QSMs, 1 Executive (12 total). Expected 1-3 step-ups this month.

## 5. Use cases

1. On the 10th, a distributor receives an email and a link and answers, in order: money made this month ($ or "Not yet"), active orders on their account, orders delivered and accepted, the amount that will drop into their account, and the date it drops and can be withdrawn. It takes under 2 minutes.
2. The leader opens the dashboard and sees who has not answered, who made no income, and whose money drops this week, so they can plan the days for each member's PPV order.
3. On the 25th, a distributor reports sign-ups and step-ups, and the system updates their rank history.
4. A QSM logs in and sees only their downline's results.
5. The leader gets a Monday digest: who replied, who is overdue, who needs a call.
6. **Monthly plan and sign-up promise (15th):** a distributor's new-month plan says who they plan to sign up and how much they want to earn (for example a $300 to $1,000 target). This is stored and later compared with the real result.
7. **Sign-up confirmation (25th):** everyone is asked how many people they signed. Those who answer Yes enter a count. The leader reviews and confirms each claim.
8. **Sign-up details and downline growth:** once the leader confirms, the distributor receives a second mail to enter the new sign-up's details, including the PV of their first order. The new person is added to the downline tree under their sponsor, so their PV counts toward their sponsor's and upline's QPV.
9. **PPV, QPV and rank check (14th):** each member reports their monthly PPV (for example 136 PV, 250 PV, 272 PV) and team QPV. The system flags whether they met the 100 PPV activity minimum, compares reported QPV with the QPV calculated from the downline tree, and shows which NeoLife rank thresholds they reached (see Appendix A). The leader reviews and confirms any rank change.
10. **Sign-up reported any day:** a sponsor messages the Admin as soon as they get a sign-up. They do not wait for the 25th question. The Admin adds the new person to the system straight away.
11. **Activation, welcome and celebration:** the new member is added as Pending and the Admin is notified. When they are activated (by the Admin, or by the automatic rule), the system emails them a congratulation and welcome message with next-step advice, and the whole team sees who stepped up and who sponsored them.
12. **My profile:** every member edits their own name, picture and other details. Their NeoLife ID cannot be changed by them: only the Admin can correct it, and every correction is logged. Their TeamPulse ID is generated by the system.
13. **Answer windows:** a check-in is locked until 2 days before its date and closes 3 days after. Each question repeats monthly, so a distributor who skips a month sees it marked Missed and simply answers the next one when it opens.
14. **Landing page:** the leader sends a link to a distributor, who reads how TeamPulse works and signs in. The distributor never registers: the leader adds them, and they get a welcome email with their TeamPulse ID and a link to set their password.

## 6. Requirements (summary)

**Epic A: Users, roles and ranks**
- A1 Admin creates and invites members (name, email, phone, sponsor/upline, join date).
- A2 Roles: Admin, QSM, Member. Only an Admin can add an Admin.
- A3 Rank engine: each member has a NeoLife **title** (Distributor, Manager, Senior Manager, Executive Manager, Director and above) and a **monthly qualified status** (for example Qualified Senior Manager). Titles are stored in a **configurable rank table** (name, QPV minimum, PPV minimum, order, special rules). The title is set by the leader and logged in a rank history. See Appendix A.
- A4 Downline tree (sponsor links) so a QSM sees only their downline.
- A5 **Calendar months:** all reporting, PPV and QPV, and rank qualification use the **normal calendar month** (1st to the last day), which is how NeoLife counts PV. Every answer is stored against the calendar month it was asked in. The 15th plan is stored in the month it is asked and labelled as the plan for the **next** month.
- A5b **Team urgency calendar (label only):** the team treats the 15th as day one of the next month, to keep a sense of urgency toward the monthly target. The system shows a countdown (for example "Your team's November ends in 3 days. Team December starts on 15 Nov.") but never uses these dates for numbers, ranks or reports.
- A6 **PPV and activity:** PPV is stored as a raw number each month. A member with at least 100 PPV is marked Active. Below 100 PPV they are flagged, because the plan requires 100 PPV to earn bonuses and to qualify for a title.
- A7 **QPV calculation and rank check:** the system adds a member's PPV to the PPV of everyone below them in the in-system downline (down to the next Qualified Director), and compares that with the QPV the member reports. When QPV and PPV meet a rank's thresholds, the system shows a **rank-up recommendation** with the reason. The Admin confirms or dismisses it, and every change is logged (old rank, new rank, date, reason).
- A8 **Member profile:** every member can edit their display name, profile picture, phone, location and other personal details. Admins can edit any member's non-locked details.
- A9 **NeoLife ID (official):** each member has a NeoLife ID in the format `063-9262173` (3 digits, a hyphen, 7 digits). It must be unique. Once saved it is **read-only for the member**. Only the Admin can correct it (for example after a typo), and each correction is logged with the old value, new value and date.
- A10 **TeamPulse ID (system-generated):** every added member automatically receives a TeamPulse ID built like NeoLife's own: `0` plus the last digit of the joining year, then `OW`, then 3 random digits. It is **7 characters at most, with no slashes, hyphens or spaces**. Example: `06OW674` for someone who joined in 2026, and `07OW674` in 2027. Nobody types it in, and it never changes. The system checks it is unique and generates a new number if there is a clash.
- A11 **Account status and activation:** a new member starts as **Pending** and cannot log in. They become **Active** when the Admin activates them from a notification (one click), or automatically 24 hours after the Admin was notified, if the record is valid. Activation is logged.
- A12 **Registration and sign-in:** only a **team leader registers directly** (name, email, NeoLife ID and a password). Everyone else is **added by their leader** and never registers themselves. Every member signs in with their **TeamPulse ID and their own password**. The TeamPulse ID is the only login name. Email is used for password resets and notifications. A Pending member sees "waiting for activation" instead.
- A13 **Setting the first password:** TeamPulse IDs are short and not secret, so an ID alone must never let anyone set a password. The welcome email carries a one-time "Set your password" link that expires after 7 days. A password needs at least 8 characters, with a letter and a number. Passwords are stored hashed, never in plain text.
- A14 **Sign-in protection:** an account locks after 5 wrong tries. An unknown ID and a wrong password show the same message. "Forgot your password?" emails a reset link (7 days) to the email on file. The Admin can reset any member's password at any time.
- A15 **Teams:** every record belongs to one team, the leader's. In the first release only the owner's team exists, and registration for other team leaders opens later without rebuilding.

**Epic B: Scheduled check-ins**
- B1 Question library and templates, editable by an Admin.
- B2 Schedule per question: a date in the calendar month plus an answer window. Default window: opens 2 days before the date and closes 3 days after (configurable per question). Dates are fixed, not random.
- B3 Answer types: number, money, Yes/No, date picker, multi-count, long text, "Not yet" option.
- B4 Static prefix "I will" / "I must" on goal answers (not deletable).
- B5 Delivery by email (Gmail-friendly) with a secure link. WhatsApp click-to-chat nudge. See open question on WhatsApp API.
- B6 Automatic reminders for non-responders, and an Admin alert after N days.
- B7 **Answer windows:** each check-in opens 2 days before its date and closes 3 days after. Before it opens it is locked and shows when it opens. While it is open it can be answered. After it closes it can no longer be answered and is marked **Missed**.
- B8 **An answer belongs to the question it was asked for.** An answer sent late but inside the window counts for that question's own date, not the day it was sent. Example: the 28th question answered on 1 December still counts for November.
- B9 **Monthly repeat:** every check-in repeats each month. A missed month stays Missed and does not block the next month's question. Members never answer several months at once.
- B10 **Emails and reminders (draft):** the email goes out when the window opens, with a reminder on the question date if it is unanswered and a final reminder 1 day before the window closes.

**Epic C: Answer storage and history**
- C1 Every answer is saved to the member's profile with date, period (week/month) and question.
- C2 Edit window for corrections, with an audit trail.

**Epic D: Leader dashboard**
- D1 Team table: rank, income, PPV, QPV, paid status, response status, filterable by month.
- D2 Yearly view: income per member per month and year total.
- D3 Lists: not replied, unpaid monthly responsibility, no income yet, and **money dropping soon** (amount and date for each member, sorted by date, with a total).
- D4 Plan versus result (15th plan versus the sign-ups reported on the 25th and the income reported on the 10th).
- D5 Monday digest and in-app alerts for the Admin.

**Epic E: Member portal**
- E1 Login (TeamPulse ID and password) and own profile/history view.
- E2 Pending questions list.
- (Later) CashBook and chat box.

**Epic F: Export and admin tools** (Later: CSV/PDF export, audit log.)

**Epic G: Plan, sign-up confirmation and rank progression**
- G1 15th plan form: goals prefixed with "I will" / "I must", planned sign-ups (names or a count), income target (a number or a range such as $300 to $1,000), planned PPV and QPV.
- G2 25th sign-up question: "Did you sign anyone this month?" Yes / No. Yes asks for a count.
- G3 **Admin confirmation queue:** the leader sees every "Yes" claim with the member's plan beside it, and can Confirm, Reject or Ask for clarification.
- G4 **Second mail on confirmation:** the member receives a mail with a form for the new sign-up details (name, email or phone, sign-up date, sponsor, first-order PV). Submitting it creates a pending member under that sponsor, which the Admin approves.
- G5 Rank-up notification: when the 14th data meets a rank's thresholds, the Admin gets a recommendation. After confirmation the member and the Admin both see the new rank, and it appears in rank history.
- G6 Plan versus result: planned sign-ups and income target are shown next to confirmed sign-ups and reported income at the end of the month.
- G7 **Add a sign-up any day:** the Admin can add a new member at any time, after a sponsor tells them (by message or the in-app "Report a sign-up" form). The 25th question stays as a monthly count check against the sign-ups already added, so nothing is missed.
- G8 **Welcome and congratulation mail:** when a new member is **activated**, the system sends them a welcome email (editable template, see Appendix B). Because they have already placed their first order, it congratulates them, names their sponsor, and encourages them to build actively: call people, recruit, train their team and help them place their first order. It also gives their TeamPulse ID and a one-time "Set your password" link (valid for 7 days), then explains that they sign in with their TeamPulse ID and password.
- G9 **Team celebration:** when a new member is activated, the **whole team** sees a celebration in the team feed naming the new member and their sponsor. The sponsor also gets a congratulation mail. The Admin can switch the feed off or hide an item.
- G10 **Sign-up history:** each member's profile shows who they sponsored and when.
- G11 **First order is recorded at sign-up:** a new sign-up is already a Distributor, because they placed their first order before they were added. When a new member is added, the first-order PV is required (for example 100, 136, 250 or 272). It is saved as their PPV for the month, and once they are active it counts toward their sponsor's and upline's QPV.

**Epic H: Landing page and sign-in**
- H1 **Landing page:** a public page that explains TeamPulse in plain words: the monthly calendar with each question's window, the features, how it works, the NeoLife rank levels it checks, and an FAQ. It states that TeamPulse is an independent team tool, not affiliated with or endorsed by NeoLife International.
- H2 **Sign-in card:** TeamPulse ID and password, with "Forgot your password?" and a note that first-time members use the link in their welcome email. There is **no request-access form**: members are added by their leader.
- H2b **For team leaders:** a section that explains the three steps (register, add members, members set their password). Registration for new team leaders opens with the first release.
- H3 **Entry points:** the page links to the prototype now, and to sign-in in the real app.
- H4 **No invented proof:** testimonials, client counts and ratings appear only once they are real.

## 7. Check-in calendar (initial configuration)

**Months:** all dates and numbers use the normal calendar month. The team also treats the 15th as day one of the next month, for urgency, so the plan sent on 15 November is the plan for December. That is a label only (see A5b).

**Answer windows:** every check-in below opens **2 days before** its date and closes **3 days after**. Windows for the 14th and 15th overlap on purpose (13th to 17th), and so do the 25th and 28th (26th to 28th). A late answer inside the window counts for the question's own date.

| When | Questions |
|---|---|
| Weekly | Sales this week; active orders |
| 10th | In this order: (1) money made this month, or "Not yet"; (2) active orders on their account; (3) orders delivered and accepted; (4) amount that will drop into their account; (5) date it drops and can be withdrawn, so the leader can plan PPV order days |
| 14th | Affirmation plan: PPV this month; team QPV (or "none yet"). System checks the 100 PPV minimum and rank thresholds |
| 15th | **Day one of the team's next month.** New-month (belief) plan for the next calendar month: goals ("I will / I must ..."), planned sign-ups, PPV, QPV, income target (for example $300 to $1,000) |
| 25th | Step 1: "Did you sign anyone?" Yes / No (count if Yes). Also step-ups by rank and tools bought this month |
| 28th | Paid monthly responsibility? Yes / No |
| Any day | Sponsor tells the Admin about a new sign-up. Admin adds them, and the welcome mail and celebration go out immediately |
| After the Admin confirms | Step 2: second mail with the sign-up details form. Submitting adds the new person to the downline for the next QPV calculation |

**Answer windows by date:**

| Question date | Window opens | Window closes |
|---|---|---|
| 10th | 8th | 13th |
| 14th | 12th | 17th |
| 15th | 13th | 18th |
| 25th | 23rd | 28th |
| 28th | 26th | 31st (or the 1st to 3rd of the next month in shorter months) |

(Confirm exact questions in the next round.)

## 8. User stories and acceptance criteria (samples, INVEST-style)

**US-1** As an Admin, I want to add a member with their rank and sponsor so that the system knows their level and downline.
- Given I am an Admin, when I submit name, email, rank and sponsor, then a profile is created and an invite is sent.
- Rank change is saved with date and previous rank.

**US-2** As a member, I want to answer my 10th-of-month questions from one link so that I can report quickly.
- Link opens without a separate sign-up step if I am invited, or after login.
- Earnings accepts a number or "Not yet", and rejects empty or text input.
- Submitted answers appear on my profile immediately.

**US-3** As an Admin, I want to see who has not replied so that I can follow up.
- List shows members with pending questions and days overdue.
- Reminder is sent automatically after the configured delay.

**US-4** As an Admin, I want to be alerted when a check-in window needs my attention so that I stay consistent.
- Alert when a window opens, on day N with outstanding answers, and in the Monday digest.

**US-5** As a QSM, I want to see only my downline so that I can coach them.
- QSM cannot view members outside their downline (verified by direct URL test).

**US-6** As an Admin, I want "I will"/"I must" prefilled on goal fields so that plans are phrased as commitments.
- Prefix is fixed text; the member types only the rest.

**US-7** As a member, I want to see my past income and plans so that I can track my own progress.

**US-8** As a member, I want to say on the 25th whether I signed anyone so that my effort is recognised.
- Choosing No finishes the question. Choosing Yes requires a whole-number count of at least 1.
- The claim goes to the Admin queue and shows "Awaiting confirmation" on my profile.

**US-9** As an Admin, I want to confirm or reject sign-up claims so that the downline only contains real sign-ups.
- The queue shows the member, the count claimed and their 15th plan for that month.
- Confirm triggers the second mail. Reject notifies the member with a reason. No one is added to the downline before confirmation.

**US-10** As a member, after my claim is confirmed, I want to enter my new sign-up's details so that they appear in my team.
- The form link works once per confirmed sign-up and expires after a set time.
- On submit, the new person is added under me as "pending", and the Admin is notified to approve.

**US-11** As an Admin, I want the system to recommend a rank-up when someone meets the thresholds so that I don't check each person by hand.
- Example: a member with 100 PPV and 1,000 QPV in the month is recommended for Senior Manager.
- The recommendation shows PPV, QPV and the rule it met. Confirming writes a rank-history entry (old rank, new rank, date, reason). Dismissing is also logged.

**US-12** As an Admin, I want each member's PPV checked against the 100 PPV minimum so that I can see who is not active.
- A PPV below 100 shows a warning on the dashboard and in the member's profile.
- The raw PPV (for example 136, 250 or 272) is stored per calendar month.

**US-13** As an Admin, I want reported QPV compared with QPV calculated from the downline so that I can spot wrong numbers.
- Calculated QPV equals the member's PPV plus the PPV of all in-system downline members down to the next Qualified Director.
- A difference is shown with the note that customers or people outside the system can explain the gap.

**US-14** As a sponsor, I want to tell the Admin about a new sign-up straight away so that I don't have to wait for the 25th.
- I can report a sign-up any day through the in-app form (or by message, and the Admin adds it).
- The report shows as "Awaiting Admin" until the Admin adds the person.

**US-15** As a new member, I want a welcome message with clear next steps so that I know how to move my NeoLife business forward.
- The email is sent within minutes of my account being activated.
- It congratulates me by name, says my sponsor is proud of me for stepping up, and encourages me to build actively (call people, recruit, train my team, help them place their first order).
- It does not ask me to place a first order, because I already did.

**US-16** As a sponsor, I want my new sign-up celebrated so that I feel recognised.
- When my sign-up is activated, I receive a congratulation mail.
- The whole team sees a post naming my sign-up and me as their sponsor.

**US-17** As a member, I want to manage my own profile so that my details and picture are right.
- I can edit my name, picture, phone and other personal fields, and changes show immediately.
- Pictures accept common image types and are limited in size.

**US-18** As an Admin, I want each NeoLife ID to be unique, validated and changeable only by me so that members can't be duplicated or switched.
- Only the format `###-#######` is accepted. An ID that already exists is rejected with a clear message.
- Members cannot edit their NeoLife ID after it is saved. I can correct it from the member's profile, and each correction is logged with the old value, new value and date.

**US-19** As an Admin, I want the system to give every new member a TeamPulse ID so that IDs are consistent.
- The ID is `0` plus the last digit of the year, `OW`, and 3 random digits, 7 characters with no separators (for example `06OW674`), and is created automatically when the member is added.
- It is unique, cannot be edited by anyone, and is shown on the member's profile.

**US-20** As an Admin, I want new members to be inactive until activated so that only approved people get in.
- A new member is Pending and cannot log in. I receive a notification with an Activate button.
- When activated (by me or the automatic rule), the welcome mail is sent, the login becomes available, and the team celebration is posted.

**US-21** As a member, I want to sign in with my TeamPulse ID and my own password so that sign-in is simple and only I can get into my account.
- I type my TeamPulse ID and password. An unknown ID and a wrong password show the same message.
- After 5 wrong tries the account locks. I can unlock it with "Forgot your password?", or my leader can reset it.
- A Pending member is told the account is waiting for activation.

**US-22** As an Admin, I want a new sign-up's first order recorded when I add them so that their PPV and their sponsor's QPV are right from day one.
- First-order PV is required, and the form suggests common values (100, 136, 250, 272).
- After activation the PV counts as their PPV and adds to their sponsor's and upline's calculated QPV.

**US-23** As a member, I want to report my earnings, orders and when my money drops so that my leader can plan around it.
- The 10th check-in asks, in order: money made this month, active orders on my account, orders delivered and accepted this month, the amount that will drop into my account, and the date it drops and can be withdrawn.
- If I enter an amount to drop, the date is required.
- The answers are saved to my profile for that month and shown to my leader.

**US-24** As an Admin, I want a "Money dropping soon" list so that I can plan the days each member can place their PPV order.
- The list shows each member's amount and date, sorted by date, with a total.
- A QSM sees the list for their own downline only.

**US-25** As a member, I want each check-in to open only close to its date so that I answer the right question at the right time.
- A check-in is locked until 2 days before its date and shows "Opens {date}".
- It stays open until 3 days after its date. After that it shows "Missed" and cannot be answered.
- I cannot answer a future month early. The next month's question opens on its own.

**US-26** As an Admin, I want late answers counted for the right month so that my monthly numbers are correct.
- An answer sent inside the window counts for the question's own date. For example, the 28th question answered on 1 December still counts for November.
- Dashboard completion counts only the check-ins that have opened this month. Missed ones are shown as Missed.

**US-27** As a distributor, I want a clear landing page so that I understand how TeamPulse works and where to sign in.
- The page explains the monthly calendar and its windows, the features, how I get my account and the rank levels it checks.
- It has a sign-in card, and it checks that the TeamPulse ID looks right (for example 06OW674) before sending.
- It has no registration form for members, because my leader adds me.

**US-28** As a member, I want to set my own password from my welcome email so that only I know it.
- The welcome email has a "Set your password" link that works for 7 days. A password needs at least 8 characters, with a letter and a number.
- Entering a TeamPulse ID alone never lets anyone set or change a password.
- After I save it I am signed in, and from then on I use my TeamPulse ID and password.

**US-29** As an Admin, I want to reset a member's password so that nobody stays locked out.
- "Reset password" on the member's profile clears the password, unlocks the account and sends the member an email to choose a new one.

**US-30** As a team leader, I want to register directly so that I can add my own team.
- Registration asks for my name, email, NeoLife ID and a password, and gives me a TeamPulse ID.
- Only team leaders register. Everyone else is added by me. In the first release only the owner's team exists.

## 9. Scope

**In scope (MVP):** roles and permissions (Admin, QSM, Member), members and rank table, downline tree, scheduled check-ins by email, answer storage, leader dashboard (team table, not-replied, unpaid, yearly income), reminders and Admin alerts, member login and own history, calendar-month reporting with the team's 15th countdown label, the NeoLife rank-rules table (PPV and QPV thresholds up to Director), QPV calculation from the downline tree, rank-up recommendations confirmed by the Admin, the two-step sign-up confirmation flow, sign-ups added any day with a welcome mail and celebration, and editable member profiles with a unique NeoLife ID that only the Admin can correct, and a landing page with sign-in, team-leader registration, TeamPulse ID and password sign-in, a first-password link, password reset and an account lock after 5 wrong tries.

**Out of scope for MVP:** CashBook, chat box, WhatsApp Business API automation, native mobile apps, payments, multi-team or white-label for other leaders, automatic rank calculation from official Neolife systems.

## 10. Dependencies

- Email sending service and a verified sender domain.
- Hosting and database.
- Neolife rank rules and point thresholds (provided by the leader).
- WhatsApp Business API approval (only if chosen).

## 11. Risks and assumptions

| Risk or assumption | Mitigation |
|---|---|
| Self-reported numbers may be wrong | Show trends, allow the leader to flag or correct answers. |
| Sensitive income data | Role-based access, HTTPS, minimum data collected, team told how data is used. |
| Neolife rank rules misunderstood | Configurable rank table filled in by the leader, not guessed. |
| Low response rate | Short forms, reminders, easy link, leader follow-up. |
| Tight timeline (about 7 weeks) | Keep MVP small. Defer WhatsApp API and CashBook/chat. |
| Assumption: all 12 members have email and use Gmail | Validate in the next round. |
| Assumption: leader will use the dashboard weekly | Digest and alerts support this. |
| A wrong or self-reported number would trigger a wrong rank-up | The system only recommends. The Admin confirms, and a full rank history is kept. |
| The system's rank could differ from NeoLife's official rank | Treat the official NeoLife Back Office as the source of truth and show the system rank as a team tracker. |
| Calculated QPV is incomplete because customers and outside members are not in the system | Show reported and calculated QPV side by side. |
| A mistyped NeoLife ID | Format check on entry. Members cannot edit it, so the Admin corrects it from the member's profile, and every correction is logged. |
| The team feed names a new member before they have agreed | Tell new members at sign-up. Show the feed only after activation, and let the Admin hide an item. |
| Random TeamPulse IDs could clash | Check uniqueness and regenerate. With 1,000 numbers a year, clashes are rare at this team size, and the system retries until the ID is unique. |
| Someone guesses a TeamPulse ID and sets that person's password first | An ID never sets a password by itself. The first password is set from a one-time emailed link that expires in 7 days. Accounts lock after 5 wrong tries. |
| Welcome advice could include income claims that break NeoLife policy | Keep the template factual, and have the leader review the wording. |
| The team's 15th-as-day-one calendar could be mixed up with NeoLife's calendar month | Numbers and ranks always use calendar months. The 15th appears only as a countdown label. |
| Members may claim sign-ups they did not make | The confirmation queue shows each claim next to the member's plan before points are added. |

## 12. Open questions

1. **Neolife rank structure:** exact ranks in order, and the requirements for each (PV, QPV, number of legs, and so on)? Please share the plan or a screenshot.
2. Which question is asked on which date, and the final wording? (Section 7 is a draft.)
3. WhatsApp: email plus click-to-chat nudge for launch, with WhatsApp API later? (Recommended.)
4. ~~How should members sign in?~~ **Resolved:** with their TeamPulse ID and their own password, set from a 7-day link in the welcome email.
5. Should QSMs also receive alerts about their own downline's unanswered check-ins?
6. Which numbers are in dollars versus naira, or any other currency?
7. Who owns member data if you offer the product to other leaders later?
8. ~~What do 136, 250 and 272 mean?~~ **Resolved:** they are actual monthly PPV amounts, not tiers. PPV is stored as a raw number and checked against the 100 PPV minimum and the QPV thresholds.
9. ~~Official sales month~~ **Resolved (corrected):** NeoLife's sales month is the normal calendar month. The team treats the 15th as day one of the next month only for urgency, so the system uses calendar months for everything and shows the 15th as a label.
10. Rank changes: the draft only recommends, and you confirm. Is that right?
11. ~~Late answers after the 14th~~ **Resolved:** an answer sent inside its window counts for that question's own date. After the window closes it is Missed.
12. What details do you need for each new sign-up (name, phone, email, sponsor, first-order PV)?
13. Which ranks must the MVP handle? The draft covers Distributor to Director (your team is at Executive Manager and below). Emerald, Sapphire, Ruby and Diamond can be added to the same table later.
14. Is the Africa plan (March 2026) the right one, and should income estimates be in USD?
15. ~~Who sees a celebration?~~ **Resolved:** the whole team sees who stepped up and who sponsored them.
16. ~~Login straight away?~~ **Resolved:** no. New members are Pending until activated by the Admin or an automatic rule.
17. ~~Mistyped NeoLife ID~~ **Resolved:** members cannot edit their NeoLife ID. Only the Admin can correct it, with each correction logged. This replaces the earlier 48-hour edit window.
18. ~~NeoLife ID format~~ **Resolved:** `063-9262173` (3 digits, hyphen, 7 digits). The TeamPulse ID is automatic: for example `06OW674`.
19. Please review the draft welcome email in Appendix B and edit the advice you want new members to get.
20. ~~Automatic activation rule~~ **Resolved:** if the Admin hasn't acted within **24 hours** of the notification, the system activates the member, provided the record is valid (correct NeoLife ID format, unique ID, sponsor exists). An invalid record stays Pending and the Admin is reminded.
21. ~~Fixing a wrong NeoLife ID later~~ **Resolved:** the Admin only, logged.
22. Does the first 3 digits of the NeoLife ID (such as 063) always stay the same, or can they vary?
23. ~~TeamPulse ID format~~ **Resolved:** 7 characters at most, `0` plus the last digit of the year, `OW`, 3 random digits (`06OW674` for 2026, `07OW674` for 2027). Note: 3 random digits give 1,000 IDs per year, which is plenty for this team. Sign-in also accepts a zero typed in place of the letter O.
24. ~~Sign-in method~~ **Resolved:** TeamPulse ID and password. The first password is set from a one-time emailed link, because TeamPulse IDs are short and not secret.
25. Is there a minimum first-order PV for a new sign-up? Draft: any amount above zero is accepted, with a warning under 100.
26. **Payout details:** is "delivered and accepted" a count of orders (as drafted) or an amount? Can a member have more than one payout in a month (several amounts and dates), or just one? Draft: one amount and one date per month. The old "order clearing date" question is replaced by the date the money drops.
27. **2 or 3 days before?** You said 2 days before twice and 3 days before once. Draft: opens 2 days before, closes 3 days after. Please confirm.
28. ~~Monthly responsibility and sign-up dates~~ **Resolved:** the sign-up question is on the 25th (window 23rd to 28th) and monthly responsibility is on the 28th (window 26th to 31st).
29. **Weekly check-in** (sales this week): which weekday, and does it use the same 2-before and 3-after window? It is not in the prototype yet.
30. Can the Admin reopen a closed window for one member (for example after a real problem)? Draft: yes, Admin only, logged (not in the first release).
31. ~~Leader's WhatsApp number~~ **No longer needed:** distributors no longer request access, so the landing page has no WhatsApp button.
32. **Photos:** the landing page has no photos yet. Real photos of you, your team or events will make it look far better. Which can I use?
33. **Sharing:** the landing page and the prototype are private. To let distributors open them, use each page's Share menu. Do you want a public link now, or a custom domain later?
34. **Other team leaders:** drafted as owner-only for the first release, with every record belonging to a team so more leaders can register later. Please confirm.
35. ~~Password rules~~ **Resolved:** at least 8 characters with a letter and a number, set and reset links valid for 7 days, and a lock after 5 wrong tries.
36. Does the team leader also sign in with a TeamPulse ID? Draft: yes, the leader gets one when they register.

---

## Prioritisation preview (to confirm in the next step)

| Priority | Items |
|---|---|
| **Must have (MVP)** | Roles and permissions, members and rank table, calendar-month reporting, NeoLife rank-rules table, QPV calculation and rank-up recommendations, two-step sign-up confirmation, downline tree, scheduled email check-ins, answer storage, team dashboard, not-replied and unpaid lists, reminders and Admin alerts, member login and history |
| **Should have** | Plan versus result view, Monday digest, yearly income view, audit trail |
| **Could have** | WhatsApp click-to-chat links, exports, leaderboard and celebrations |
| **Later** | WhatsApp Business API, CashBook, chat box, multi-team, Sales Volume Bonus income estimates, Emerald to Diamond ranks |

---

## Appendix A: NeoLife rank rules (source: Compensation Plan, Africa, March 2026)

**Key terms**
- **PPV** (Personal PV): your own purchases in the month (plus sponsored Members' accounts). 100 PPV is the minimum monthly activity to participate and earn bonuses.
- **QPV** (Qualified PV): your PPV plus the PV of all Members and Distributors you sponsored and that they sponsored, down to the next Qualified Director.
- **GPV** (Group PV): your QPV plus the QPV of three levels of Qualified Directors (used for Sapphire Director and above).
- **Title versus qualified status:** a title is achieved; "qualified" means you met that title's QPV in a given month and lock in its Sales Volume Bonus (SVB) for that month. If you miss it, you earn by the SVB chart instead.

**Title thresholds (monthly, with at least 100 PPV)**

| Title | QPV needed | SVB | Notes |
|---|---|---|---|
| Distributor | 250 | 3% | 250 QPV starts SVB eligibility |
| Manager | 500 | 5% | Can reach Manager, Senior Manager and Executive Manager in the same month |
| Senior Manager | 1,000 | 10% | |
| Executive Manager | 2,000 | 15% to 20% | 15% at 2,000, 20% at 3,000 QPV |
| Director | 4,000 | 25% | Option 1: be Qualified Executive Manager (2,000+ QPV) one month, then 4,000 QPV the next. Option 2: Qualified Senior Manager with 10,000 QPV over 6 months (100 PPV each month) and 4,000 QPV in the last month |
| Emerald Director | 4,000 | 25% | Qualified Director 3 consecutive months. Maintain with 4,000 QPV at least 1 month in every 3 |
| Sapphire Director and above | 4,000 + legs and GPV | 25% | 1st-level Qualified Director legs and GPV (Sapphire: 1 leg, 10,000 GPV; 1 Ruby: 3 legs, 20,000 GPV; up to 5 Diamond: 18 legs, 500,000 GPV). Needs 3 qualifying months within 6 |

**How SVB on a downline works:** you earn your SVB % minus your downline member's SVB % on their volume (for example 10% minus 3% = 7%). Directors earn Leadership Development Bonus on Qualified Directors instead.

**What the system will do with these rules**
- Store the table above as editable data, not fixed code.
- Check each member's monthly PPV and QPV against it and recommend rank-ups (US-11).
- Support multi-month rules (Director Option 2, Emerald) from stored monthly history, after the core thresholds work.
- Later: estimate SVB for each member from the chart (Africa plan averages about $0.60 BV per PV).

---

## Appendix B: Draft welcome email for a new sign-up (leader to edit)

A new sign-up has already placed their first order, so this email does not ask for one. It is sent when the member is activated.

**Subject:** Welcome to the family, {first name}!

Congratulations, {first name}, and welcome to the family! {sponsor name} is proud of you for stepping up and joining the business. Your first order of {first-order PV} PV makes you a NeoLife Distributor today.

Now the real work starts. Here is what to do:
1. **Build your business actively.** Work it every week, not once in a while.
2. **Start calling people.** Write a list of names today and reach out to them about your business.
3. **Start recruiting.** Invite people to look at what you are doing.
4. **Train your team.** Show them to do what you do, and how to earn with their own skills. Help them place their first order.
5. **Grow through them.** When your team signs people, you sign more people too.
6. **Stay close to {sponsor name}.** Book a call to plan your first 30 days.

**Set your password to get started.** Your TeamPulse ID is {TeamPulse ID}. Use this link to choose your own password: {set-password link}. It works for 7 days. After that, sign in with your TeamPulse ID and your password.

Your monthly check-in questions will arrive by email. They take about two minutes and help us support you.

Welcome to the family,
{leader name}

*Note: keep the advice factual and avoid income promises, in line with NeoLife's policies.*
