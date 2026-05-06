# 🏠😂 Roomie Roast

> **Smart Flatmate & Hostel Life Manager**
> An all-in-one productivity + social coordination app built for students living in **hostels, flats, PGs, or shared rooms**.

Roomie Roast helps roommates manage chores, split expenses, assign duties, resolve conflicts, and stay accountable... with a hilarious twist of roast messages + AI Insights with voice assistant.

Built using **Flutter + Firebase + Provider + Charts + Custom Logic Systems**

---

## 🌟 Project Overview

Living with roommates can be fun... until chaos begins:

- Dirty dishes pile up 🍽️
- Shared expenses become war zones 💸
- Cleaning duties vanish mysteriously 🧹
- Borrowed chargers disappear forever 🔌
- Noise levels become nightclub mode 🔊
- Nobody takes responsibility 😵

### ✅ Solution: Roomie Roast

A smart roommate management app that solves these everyday problems using:

- Real-time shared task boards
- Expense splitter
- Duty rotation
- Fairness scoring
- Social complaint wall
- Analytics dashboard
- Roast notifications
- Premium modern UI
- AI Insights
- Voice Descriptions

---

## 🚀 Core Features

### 👥 1. Room Management

Users can:

- Create a new room
- Join existing room using Room Code
- Share room data in real-time

Each room acts as a private workspace for members.

---

### ✅ 2. Shared Chore Board

Manage daily responsibilities easily:

- Add new chores
- Mark tasks as completed
- Real-time updates for all members
- Pending task tracking

**Examples:**
- Wash dishes
- Clean floor
- Buy groceries
- Throw garbage

---

### 💰 3. Expense Splitter

Track shared room expenses.

Users can add:

- Grocery bills
- Electricity bills
- WiFi recharge
- Food orders
- Household purchases

System automatically calculates:

- Equal split amount
- Who paid
- Who owes whom

**Example:**
Akash paid ₹600
3 members in room
➡ Everyone owes ₹200
➡ Remaining members owe Akash ₹400 total
---

### 📊 4. Smart Dashboard

Beautiful analytics dashboard with charts.

**📌 Chore Progress Chart**
- Total tasks
- Completed tasks

**📌 Expense Pie Chart**
- Total room spending

**📌 Room Mood Meter**

Members can rate room mood:
- 😡 Chaos
- 😐 Normal
- 😎 Chill

**📌 AI Smart Insights**

Examples:
- "High spending week. Snacks are winning."
- "Excellent teamwork this week."
- "Civilization remains intact."

---

### 😂 5. Roast Engine (Signature Feature)

This app's most memorable feature.

The system generates funny accountability messages based on room activity.

**Examples:**
- Akash ignored dishes for 3 days. Plate archaeology underway.
- This room is cleaner than our life choices.
- Dust has begun negotiations.
- Noise level resembles a wedding band.
- Authorities may classify this room as wilderness.

This makes the app fun instead of boring.

---

### 🔥 6. Streak Rewards System

Users earn streaks by completing chores regularly.

**Tracks:**
- Daily consistency
- Task completion streaks

**Rewards:**
- 🔥 Starter Flame
- ⚡ Hustler Mode
- 👑 Responsibility King

---

### 🎭 7. Drama Center

A dedicated social module for roommate issues.

#### 🧾 Complaint Wall

Members can post complaints like:
- Someone stole my Maggi
- Please stop shouting at 2 AM
- Return my charger

#### 📦 Borrow Tracker

Track borrowed items:
- Charger
- Bucket
- Notes
- Speaker

Shows:
- Item name
- Taken by whom

#### 🎡 Punishment Wheel

Spin wheel assigns fun punishments:
- Buy snacks 🍟
- Wash dishes 🍽️
- Make chai ☕
- Silent mode 1 hour 🤐
- Clean bathroom heroically 🚿

---

### ⚖️ 8. Fairness Engine (Custom Logic System)

Tracks contribution of each roommate.

**Scoring based on:**
- Chores completed
- Participation
- Streak consistency
- Responsibility level

**Ranks users as:**

| Title | Meaning |
|-------|---------|
| 👑 House Hero | Most responsible |
| 😎 Reliable Human | Good contributor |
| 🛋️ Sofa Goblin | Lazy but alive |
| 👻 Laundry Phantom | Rarely seen |

---

### 🔄 9. Duty Rotation System

Automatically rotates weekly responsibilities:

**Week 1:**
- Akash → Bathroom
- Arpit → Kitchen
- Virat → Trash

**Week 2:** Automatically rotated fairly.

No arguments. No excuses.

---

### 🎨 10. Premium UI / UX

Custom polished design with:

- Multiple themes
- Dark mode
- Modern cards
- Smooth layout
- Neon hostel vibe
- Beautiful charts
- Responsive screens

Not template style.

---

## 🧰 Tech Stack

| Layer | Technology |
|-------|-----------|
| Frontend | Flutter, Dart |
| Backend / Database | Firebase Authentication, Cloud Firestore |
| State Management | Provider |
| UI Libraries | fl_chart, Material 3 |
| Notifications | Local notifications |

---

## 🧠 Architecture Flow
```text
User Authentication
      ↓
Create Room / Join Existing Room
      ↓
Room Code Maps Users to Shared Space
      ↓
Firebase Firestore Real-time Database
      ↓
Tasks | Expenses | Complaints | Scores | Duties
      ↓
Provider State Management Layer
      ↓
Instant UI Sync Across All Members
      ↓
Analytics Dashboard + Charts + Roast Engine

```
## 📂 Project Structure
```text
lib/
│
├── app.dart                 # Main app entry + theme config
├── routes.dart              # Named route navigation
│
├── providers/
│   ├── auth_provider.dart
│   ├── room_provider.dart
│   ├── task_provider.dart
│   ├── expense_provider.dart
│   ├── analytics_provider.dart
│   ├── streak_provider.dart
│   ├── fairness_provider.dart
│   ├── social_provider.dart
│   ├── duty_provider.dart
│   └── theme_provider.dart
│
├── screens/
│   ├── auth/
│   ├── room/
│   └── home/
│
├── services/
│   ├── roast_engine.dart
│   └── notification_service.dart
│
├── widgets/
└── theme/
```

## 🔥 Firebase Collections
users/
rooms/
tasks/
expenses/
complaints/
borrowed/
scores/
---

## 📸 Screenshots

**Authentication**

<img width="1364" height="631" alt="Screenshot 2026-05-03 235202" src="https://github.com/user-attachments/assets/78ed1942-e2fc-4890-a6f6-79afc32a5c80" />

**Signup Screen**

<img width="1365" height="626" alt="Screenshot 2026-05-04 000036" src="https://github.com/user-attachments/assets/86c1c79a-d8bb-4590-bfd6-c9585043b9c3" />

**Home**

<img width="1365" height="632" alt="Screenshot 2026-05-03 235307" src="https://github.com/user-attachments/assets/f11f1cae-ab90-4f36-b9e7-c31eeb8df2fa" />

**Dashboard**

<img width="1365" height="631" alt="Screenshot 2026-05-03 235359" src="https://github.com/user-attachments/assets/50c21263-1dce-4580-85ce-ac5e1aa84375" />

**Roast Banner**

<img width="1365" height="283" alt="image" src="https://github.com/user-attachments/assets/9bcfffe3-efde-4a66-b5ba-a5ea423d8717" />

**Charts**

<img width="1365" height="420" alt="Screenshot 2026-05-03 235915" src="https://github.com/user-attachments/assets/94bc9520-b93e-4e1e-9ee8-4c46e1372ffb" />

<img width="1365" height="623" alt="Screenshot 2026-05-04 000007" src="https://github.com/user-attachments/assets/b4a73068-02b0-41aa-9b5e-471bf4a5f2a2" />

**Mood Meter**

<img width="1363" height="189" alt="Screenshot 2026-05-03 235559" src="https://github.com/user-attachments/assets/1f75cd7f-5ca7-481f-88d5-c06f1124be16" />

**Expense Splitter**

<img width="1365" height="631" alt="image" src="https://github.com/user-attachments/assets/0254d5e0-a7de-45cd-8dba-792030bd6614" />

**Drama Center**

<img width="1365" height="630" alt="Screenshot 2026-05-03 235719" src="https://github.com/user-attachments/assets/e5b955b0-09d1-4f9f-a554-384d5051dbd7" />

**Complaints**

<img width="1365" height="336" alt="Screenshot 2026-05-04 000242" src="https://github.com/user-attachments/assets/db28b4fb-82f8-480b-a983-16d86dd15688" />

**Borrow Tracker**

<img width="1365" height="604" alt="Screenshot 2026-05-04 000258" src="https://github.com/user-attachments/assets/764da34d-6360-49e1-80e6-229684ae0a66" />

**Punishment Wheel**

<img width="1365" height="274" alt="Screenshot 2026-05-04 000232" src="https://github.com/user-attachments/assets/2ba11020-cace-4ca0-8479-5fcbb4147cfb" />

**Fairness Engine**

<img width="1365" height="638" alt="Screenshot 2026-05-03 235834" src="https://github.com/user-attachments/assets/1213d3d8-72c1-42b3-b909-464d86807514" />

**Rankings**

<img width="1365" height="631" alt="Screenshot 2026-05-03 235647" src="https://github.com/user-attachments/assets/bb8c3a80-704a-46ad-bacb-0a67db95689f" />

**Dark Theme Toggle**
<img width="1365" height="627" alt="image" src="https://github.com/user-attachments/assets/c379b0ea-61ed-4e3b-a7b6-82927a5fbb4f" />

**AI Insights with Voice Feature**
<img width="1365" height="622" alt="Screenshot 2026-05-07 011135" src="https://github.com/user-attachments/assets/33d123cd-d820-4592-9a4d-a91ad01784fc" />


---

## ⚙️ Installation Guide

**1️⃣ Clone Repository**

```bash
git clone https://github.com/Akash17112004/roomie-roast.git
cd roomie-roast
```

**2️⃣ Install Dependencies**

```bash
flutter pub get
```

**3️⃣ Setup Firebase**

Add:
- `google-services.json` (Android)
- `GoogleService-Info.plist` (iOS)

**4️⃣ Run App**

```bash
flutter run
```

---

## 🧪 Testing Completed

- ✅ Login / Signup
- ✅ Room Join/Create
- ✅ Firestore Sync
- ✅ Task CRUD
- ✅ Expense Split Logic
- ✅ Dashboard Charts
- ✅ Theme Switching
- ✅ Notifications
- ✅ Empty States
- ✅ Error Handling

---

## 🎯 Why This Project Stands Out

Unlike basic student CRUD apps, Roomie Roast combines:

| Dimension | Value |
|-----------|-------|
| Functional Value | Solves real roommate problems |
| Technical Value | Firebase, Provider, Charts, State management |
| Product Value | Humor, Gamification, Social interactions |
| Design Value | Premium UI |

---

## 🚀 Future Improvements

- AI Chatbot mediator 🤖
- Voice complaints 🎤
- OCR bill scanner 📷
- Push notifications
- Leaderboard history
- Monthly reports
- Multi-language support

---

## 👨‍💻 Developer

**Akash Tomar**

B.Tech CSE (Full Stack Development)
The NorthCap University

GitHub: [https://github.com/Akash17112004](https://github.com/Akash17112004)

---

## ⭐ Support

If you liked this project, give it a ⭐ star on GitHub and save future roommates from chaos.

---

## 😂 Final Roast

> If your room still smells after installing this app... technology has limits.
