# 🏠😂 Roomie Roast

> **Smart Flatmate & Hostel Life Manager**  
An all-in-one productivity + social coordination app built for students living in **hostels, flats, PGs, or shared rooms**.

Roomie Roast helps roommates manage chores, split expenses, assign duties, resolve conflicts, and stay accountable... with a hilarious twist of roast messages.

Built using **Flutter + Firebase + Provider + Charts + Custom Logic Systems**

---

# 🌟 Project Overview

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

---

# 🚀 Core Features

# 👥 1. Room Management

Users can:

- Create a new room
- Join existing room using Room Code
- Share room data in real-time

Each room acts as a private workspace for members.

---

# ✅ 2. Shared Chore Board

Manage daily responsibilities easily:

- Add new chores
- Mark tasks as completed
- Real-time updates for all members
- Pending task tracking

Examples:

- Wash dishes
- Clean floor
- Buy groceries
- Throw garbage

---

# 💰 3. Expense Splitter

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

Example:

Akash paid ₹600  
3 members in room  

➡ Everyone owes ₹200  
➡ Remaining members owe Akash ₹400 total

---

# 📊 4. Smart Dashboard

Beautiful analytics dashboard with charts.

Includes:

### 📌 Chore Progress Chart
- Total tasks
- Completed tasks

### 📌 Expense Pie Chart
- Total room spending

### 📌 Room Mood Meter
Members can rate room mood:

- 😡 Chaos
- 😐 Normal
- 😎 Chill

### 📌 Smart Insights

Examples:

- “High spending week. Snacks are winning.”
- “Excellent teamwork this week.”
- “Civilization remains intact.”

---

# 😂 5. Roast Engine (Signature Feature)

This app’s most memorable feature.

The system generates funny accountability messages based on room activity.

Examples:

- Akash ignored dishes for 3 days. Plate archaeology underway.
- This room is cleaner than our life choices.
- Dust has begun negotiations.
- Noise level resembles a wedding band.
- Authorities may classify this room as wilderness.

This makes the app fun instead of boring.

---

# 🔥 6. Streak Rewards System

Users earn streaks by completing chores regularly.

Tracks:

- Daily consistency
- Task completion streaks

Rewards:

- 🔥 Starter Flame
- ⚡ Hustler Mode
- 👑 Responsibility King

---

# 🎭 7. Drama Center

A dedicated social module for roommate issues.

---

## 🧾 Complaint Wall

Members can post complaints like:

- Someone stole my Maggi
- Please stop shouting at 2 AM
- Return my charger

---

## 📦 Borrow Tracker

Track borrowed items:

- Charger
- Bucket
- Notes
- Speaker

Shows:

- Item name
- Taken by whom

---

## 🎡 Punishment Wheel

Spin wheel assigns fun punishments:

- Buy snacks 🍟
- Wash dishes 🍽️
- Make chai ☕
- Silent mode 1 hour 🤐
- Clean bathroom heroically 🚿

---

# ⚖️ 8. Fairness Engine (Custom Logic System)

Tracks contribution of each roommate.

Scoring based on:

- Chores completed
- Participation
- Streak consistency
- Responsibility level

Ranks users as:

| Title | Meaning |
|------|---------|
| 👑 House Hero | Most responsible |
| 😎 Reliable Human | Good contributor |
| 🛋️ Sofa Goblin | Lazy but alive |
| 👻 Laundry Phantom | Rarely seen |

---

# 🔄 9. Duty Rotation System

Automatically rotates weekly responsibilities:

Week 1:

- Akash → Bathroom
- Arpit → Kitchen
- Virat → Trash

Week 2:

Automatically rotated fairly.

No arguments. No excuses.

---

# 🎨 10. Premium UI / UX

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

# 🧰 Tech Stack

# Frontend

- Flutter
- Dart

# Backend / Database

- Firebase Authentication
- Cloud Firestore

# State Management

- Provider

# UI Libraries

- fl_chart
- Material 3

# Notifications

- Local notifications

---

# 🧠 Architecture Flow

```text
User Login
   ↓
Join / Create Room
   ↓
Shared Firestore Collections
   ↓
Tasks / Expenses / Complaints / Scores
   ↓
Provider State Management
   ↓
Real-time UI Updates
   ↓
Charts + Roast Messages + Rankings
📂 Project Structure
lib/
│
├── app.dart
├── routes.dart
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
🔥 Firebase Collections
users/
rooms/
tasks/
expenses/
complaints/
borrowed/
scores/
📸 Screenshots
Authentication
Login Screen
Signup Screen
Home
Chore Board
Roast Banner
Streak Rewards
Dashboard
Charts
Mood Meter
Expense Splitter
Bills
Due Summary
Drama Center
Complaints
Borrow Tracker
Punishment Wheel
Fairness Engine
Rankings
Weekly Duties

(Add screenshots in assets folder)

⚙️ Installation Guide
1️⃣ Clone Repository
git clone https://github.com/Akash17112004/roomie-roast.git
cd roomie-roast
2️⃣ Install Dependencies
flutter pub get
3️⃣ Setup Firebase

Add:

google-services.json (Android)
GoogleService-Info.plist (iOS)
4️⃣ Run App
flutter run
🧪 Testing Completed

✅ Login / Signup
✅ Room Join/Create
✅ Firestore Sync
✅ Task CRUD
✅ Expense Split Logic
✅ Dashboard Charts
✅ Theme Switching
✅ Notifications
✅ Empty States
✅ Error Handling

🎯 Why This Project Stands Out

Unlike basic student CRUD apps, Roomie Roast combines:

Functional Value
Solves real roommate problems
Technical Value
Firebase
Provider
Charts
State management
Product Value
Humor
Gamification
Social interactions
Design Value
Premium UI
🚀 Future Improvements
AI Chatbot mediator 🤖
Voice complaints 🎤
OCR bill scanner 📷
Push notifications
Leaderboard history
Monthly reports
Multi-language support
👨‍💻 Developer
Akash Tomar

B.Tech CSE (Full Stack Development)
The NorthCap University

GitHub: https://github.com/Akash17112004

⭐ Support

If you liked this project:

Give it a ⭐ star on GitHub

And save future roommates from chaos.

😂 Final Roast

If your room still smells after installing this app... technology has limits.
