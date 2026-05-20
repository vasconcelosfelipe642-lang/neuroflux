# NeuroFlux

[![Node.js](https://img.shields.io/badge/Node.js-18+-339933?logo=node.js&logoColor=white)](https://nodejs.org/)
[![Express](https://img.shields.io/badge/Express-5.x-000000?logo=express&logoColor=white)](https://expressjs.com/)
[![Sequelize](https://img.shields.io/badge/Sequelize-6.x-52B0E7?logo=sequelize&logoColor=white)](https://sequelize.org/)
[![MySQL](https://img.shields.io/badge/MySQL-8.x-4479A1?logo=mysql&logoColor=white)](https://www.mysql.com/)
[![Flutter](https://img.shields.io/badge/Flutter-3.x-02569B?logo=flutter&logoColor=white)](https://flutter.dev/)
[![Dart](https://img.shields.io/badge/Dart-3.x-0175C2?logo=dart&logoColor=white)](https://dart.dev/)
[![License](https://img.shields.io/badge/License-Academic-blue)](#license)

[Português](README.md) · **English**

**Small steps, big achievements.**

A productivity app for neurodivergent people — with a focus on **ADHD** — for task organization and reducing **executive overload**. The project breaks goals into smaller steps (tasks and subtasks), shows daily visual progress, and offers an interface designed to lower cognitive friction.

> Academic project built as a full-stack solution: **Flutter** client (cross-platform) and **REST** API on **Node.js**, with a local **MySQL** database.

---

## Table of contents

- [About the project](#about-the-project)
- [Features](#features)
- [Technologies](#technologies)
- [Architecture](#architecture)
- [Repository structure](#repository-structure)
- [Prerequisites](#prerequisites)
- [Environment setup](#environment-setup)
- [Local database (MySQL)](#local-database-mysql)
- [Running the API](#running-the-api)
- [Running the Flutter app](#running-the-flutter-app)
- [API endpoints](#api-endpoints)
- [App usage flow](#app-usage-flow)
- [Admin panel](#admin-panel)
- [Troubleshooting](#troubleshooting)
- [License](#license)

---

## About the project

**NeuroFlux** was created to meet the need for organization tools that respect the cognitive patterns of people with ADHD and other neurodivergences. Instead of generic lists, the app focuses on:

- **Task breakdown** into optional subtasks, making it easier to start activities (“chunking”).
- **Visual progress feedback** (completed vs. pending tasks).
- **A simple flow** for sign-up, login, and daily management.

Communication between the app and the server uses **HTTP/JSON**, with **JWT** authentication (Bearer token) on protected routes.

---

## Features

| Area | Description |
|------|-------------|
| **Splash & onboarding** | Animated launch screen; 3-page tour on first run (`shared_preferences` flag) |
| **Authentication** | Sign-up, login, JWT session, and animated screen transitions |
| **Tasks & subtasks** | Full CRUD; a task can only be completed when all subtasks are done |
| **Focus mode** | One task at a time, immersive background, tappable subtasks, progress bar |
| **Pomodoro timer** | 10, 15, or 25 minutes per task (fully local, no API) |
| **Progress** | Dedicated tab, daily card, motivational quote, and weekly view |
| **Light/dark theme** | Toggle in the header with local persistence |
| **Sensory feedback** | Haptics on key actions; confetti at 100% daily progress; optional completion sound |
| **Dynamic avatar** | Avatar color derived from the user's name |
| **Admin panel** | Overview, users, statistics, promote to admin, and ban (`role: admin`) |
| **Persistent session** | JWT stored locally — login survives app restarts |

---

## Technologies

### Frontend — `flutter_application_1/`

| Technology | Usage |
|------------|-------|
| [Flutter](https://flutter.dev/) (Dart 3+) | Cross-platform UI |
| [Material Design](https://m3.material.io/) | Components and visual theme |
| [http](https://pub.dev/packages/http) | HTTP client for the REST API |
| [flutter_secure_storage](https://pub.dev/packages/flutter_secure_storage) | JWT token (secure storage) |
| [shared_preferences](https://pub.dev/packages/shared_preferences) | Theme, onboarding flag, and local banned-users cache |
| [flutter_animate](https://pub.dev/packages/flutter_animate) | Animations (splash, onboarding, focus mode, tasks) |
| [confetti](https://pub.dev/packages/confetti) | Celebration at 100% daily progress |
| [audioplayers](https://pub.dev/packages/audioplayers) | Optional sound on task completion |
| [lottie](https://pub.dev/packages/lottie) | Asset-based animations |

**Code organization (layers):**

- `lib/core/` — theme (`ThemeProvider`), constants, navigation (`fade_page_route.dart`, `slide_page_route.dart`), exceptions, utilities
- `lib/data/services/` — `ApiClient`, `AuthService`, `TarefaService`, `SubtarefaService`, `AdminService`, `TokenStorageService`
- `lib/domain/models/` — domain models
- `lib/presentation/` — screens (`splash`, `onboarding`, `auth_gate`, `focus`, `home_shell`, etc.) and reusable widgets

**File convention:** each `.dart` file under `lib/` contains **exactly one** public class or enum. `StatefulWidget` state classes and helper widgets live in dedicated files (e.g. `login_screen.dart` + `login_screen_state.dart`).

### Backend — `backend/`

| Technology | Usage |
|------------|-------|
| [Node.js](https://nodejs.org/) | Server runtime |
| [Express](https://expressjs.com/) 5.x | REST API |
| [Sequelize](https://sequelize.org/) | ORM and migrations |
| [MySQL](https://www.mysql.com/) | Local relational database |
| [bcryptjs](https://www.npmjs.com/package/bcryptjs) | Password hashing |
| [jsonwebtoken](https://www.npmjs.com/package/jsonwebtoken) | JWT authentication |
| [dotenv](https://www.npmjs.com/package/dotenv) | Environment variables |
| [cors](https://www.npmjs.com/package/cors) | CORS for the Flutter client |

### Development tools

This project **does not use Android Studio**. Development was done with **Visual Studio Code** (or Visual Studio) and the **Flutter/Dart extension**, running the app mainly on **Windows desktop** (`flutter run -d windows`). **Visual Studio 2022** (*Desktop development with C++* workload) is required to build the Flutter Windows target.

---

## Architecture

```mermaid
flowchart LR
  subgraph Client
    A[Flutter App]
  end
  subgraph Server
    B[Express API :3000]
    C[Sequelize ORM]
  end
  subgraph Data
    D[(Local MySQL)]
  end
  A -->|HTTP JSON + JWT| B
  B --> C
  C --> D
```

**Data model (summary):**

- **Usuarios** — `nome`, `email`, `senha` (hash), `role` (`admin` \| `user`)
- **Tarefas** — linked to user (`usuarioId`)
- **Subtarefas** — linked to task (`tarefaId`)

---

## Repository structure

```
neuroflux/
├── README.md
├── README.en.md
├── backend/                    # REST API
│   ├── server.js               # Server entry point
│   ├── config/                 # Sequelize configuration
│   ├── controllers/
│   ├── middlewares/            # JWT and authorization
│   ├── migrations/
│   ├── models/
│   └── routes/
└── flutter_application_1/      # Flutter app
    └── lib/
        ├── main.dart
        ├── core/
        │   ├── navigation/         # FadePageRoute, SlidePageRoute
        │   ├── theme/              # Light/dark theme
        │   └── utils/              # Onboarding, sound, confetti, etc.
        ├── data/services/
        ├── domain/models/
        └── presentation/
            ├── screens/
            │   ├── splash_screen.dart
            │   ├── onboarding_screen.dart
            │   ├── auth_gate.dart
            │   ├── focus_screen.dart
            │   ├── home_shell.dart
            │   └── admin/
            └── widgets/
                ├── pomodoro_timer.dart
                └── admin/
```

---

## Prerequisites

Install and configure the following before running the project:

| Tool | Suggested version | Notes |
|------|-------------------|-------|
| **Node.js** | 18 LTS or higher | `node -v` |
| **npm** | Bundled with Node | `npm -v` |
| **MySQL Server** | 8.x | Local service (e.g. MySQL Workbench) |
| **Flutter SDK** | 3.x (Dart ≥ 3.0) | [Official install guide](https://docs.flutter.dev/get-started/install) |
| **Git** | Any recent version | Repository clone |
| **Visual Studio 2022** | Community or higher | *Desktop development with C++* workload (Windows build) |
| **Editor** | VS Code recommended | **Flutter** and **Dart** extensions |

Verify your Flutter environment:

```bash
flutter doctor
```

Fix any issues reported (SDK, optional Android licenses, Windows toolchain).

---

## Environment setup

### 1. Clone the repository

```bash
git clone https://github.com/vasconcelosfelipe642-lang/neuroflux.git
cd neuroflux
```

### 2. API environment variables

In the `backend/` folder, create a `.env` file (not versioned — see `.gitignore`):

```env
PORT=3000

DB_HOST=localhost
DB_PORT=3306
DB_USER=root
DB_PASSWORD=your_mysql_password
DB_NAME=neuroflux

JWT_SECRET=a_long_random_secret_key
```

> **Important:** use your own passwords and secrets. Never commit the `.env` file.

If you run **migrations** with Sequelize CLI, also align `backend/config/config.json` (`development` environment) with the same user, password, and database as `.env`.

### 3. Backend dependencies

```bash
cd backend
npm install
```

### 4. Flutter dependencies

```bash
cd ../flutter_application_1
flutter pub get
```

The API base URL is in `lib/data/services/api_client.dart` (default: `http://localhost:3000`). Change `_baseUrl` in that file for a different host or port.

---

## Local database (MySQL)

### Create the database

Connect to MySQL (CLI, Workbench, or another client) and run:

```sql
CREATE DATABASE neuroflux
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;
```

Ensure the user defined in `DB_USER` has permission on this database.

### Create tables

Two approaches work with this project:

#### Option A — Automatic on API startup (recommended for development)

`server.js` calls `sequelize.sync()` on startup. When you run `npm start`, tables are created/updated from the models, as long as MySQL is reachable.

#### Option B — Migrations with Sequelize CLI

```bash
cd backend
npx sequelize-cli db:migrate
```

Available migrations:

- `create-usuario`
- `create-tarefa`
- `create-subtarefa`

To revert the last migration:

```bash
npx sequelize-cli db:migrate:undo
```

---

## Running the API

With MySQL running and `.env` configured:

```bash
cd backend
npm start
```

Expected output:

```text
DB sincronizado e MySQL conectado!
Servidor Neuroflux rodando em http://localhost:3000
```

Quick test in the browser or with curl:

```bash
curl http://localhost:3000
```

Response: `API Neuroflux funcionando`

---

## Running the Flutter app

**Recommended order:** 1) MySQL running → 2) API running → 3) Flutter app.

### From the terminal

```bash
cd flutter_application_1
flutter devices
flutter run -d windows
```

Other targets (if configured):

```bash
flutter run -d chrome    # Web
flutter run -d edge      # Web (Edge)
```

### From Visual Studio Code

1. Open the `flutter_application_1` folder (or the monorepo root).
2. Install the **Flutter** and **Dart** extensions.
3. Select the **Windows** device in the status bar.
4. Press **F5** or use *Run > Start Debugging*.

> **Android Studio is not required.** For this academic project, the main documented flow is **Windows desktop** via Visual Studio 2022 toolchain + Flutter extension in the editor.

---

## API endpoints

Base URL: `http://localhost:3000`

### Public (no token)

| Method | Route | Description |
|--------|-------|-------------|
| `GET` | `/` | API health check |
| `GET` | `/teste-user` | Test route |
| `POST` | `/register` | User registration |
| `POST` | `/login` | Login (returns JWT) |

### Protected (header `Authorization: Bearer <token>`)

| Method | Route | Description |
|--------|-------|-------------|
| `GET` | `/usuarios` | List users |
| `GET` | `/usuarios/:id` | Get user |
| `PUT` | `/usuarios/:id` | Update user |
| `DELETE` | `/usuarios/:id` | Delete user — **admin role only** |
| `POST` | `/tarefas` | Create task |
| `GET` | `/tarefas` | List tasks (user: own only; **admin: all**) |
| `GET` | `/tarefas/:id` | Get task |
| `PUT` | `/tarefas/:id` | Update task |
| `DELETE` | `/tarefas/:id` | Delete task |
| `POST` | `/subtarefas` | Create subtask |
| `GET` | `/subtarefas` | List subtasks |
| `GET` | `/subtarefas/:id` | Get subtask |
| `PUT` | `/subtarefas/:id` | Update subtask |
| `DELETE` | `/subtarefas/:id` | Delete subtask |

**Login example:**

```bash
curl -X POST http://localhost:3000/login \
  -H "Content-Type: application/json" \
  -d "{\"email\":\"you@email.com\",\"senha\":\"your_password\"}"
```

---

## App usage flow

### First launch and return visits

```text
Splash (animated logo) → Onboarding (3 screens, first time only) → Login or Sign up → Home
```

On later launches, onboarding is skipped automatically.

### Regular user (`role: user`)

1. **Sign up** or **log in** with email and password.
2. On the **Tasks** tab, create tasks with optional subtasks.
3. Complete subtasks first, then the task (tasks with subtasks require all subtasks done).
4. Use **Focus mode** (header icon when tasks are pending) to work on one task at a time.
5. Tap the **timer** on a card to open the **Pomodoro** (10 / 15 / 25 min).
6. Track the day on the top card and **Progress** tab (daily quote and weekly view).
7. Toggle **light/dark theme** in the header; tap **avatar** to **log out**.

> The session stays active after closing the app: the token is restored on the next launch.

### Administrator (`role: admin`)

After login, the app opens the **admin panel** instead of the task tabs. See [Admin panel](#admin-panel).

---

## Admin panel

The panel opens automatically when the user's JWT contains `role: admin`. Users with `role: user` follow the normal tasks and progress flow.

### What admins can do

| Screen | Features |
|--------|----------|
| **Dashboard** | Overview (registered users, tasks created/completed, banned), recent users list |
| **Manage users** | Search, active and banned lists, user detail |
| **User detail** | Email, tasks created/completed, completion rate, recent activity |
| **Ban user** | Confirmation modal → `DELETE /usuarios/:id` |

Logout works like regular users: tap **avatar** → **Log out**.

### Promoting a user to admin

**In the app (recommended):** in the admin panel, open user details and tap **Promote to administrator** (`PUT /usuarios/:id` with `role: admin`).

**Via MySQL (local alternative):**

```sql
UPDATE usuarios SET role = 'admin' WHERE email = 'you@email.com';
SELECT id, nome, email, role FROM usuarios WHERE email = 'you@email.com';
```

> **Important:** the JWT is issued at login and embeds `role`. After promoting, **log out and log in again** so the app picks up the admin profile.

### Step-by-step to test the panel

1. Start the API (`npm start` in `backend/`) and MySQL.
2. Register a user in the app or via `POST /register`.
3. Run the `UPDATE` above to set `role = 'admin'`.
4. Log out (avatar → Log out) and log in again with that user.
5. The **admin panel** should open automatically.
6. Use **See all →** to manage users, or tap a user for details and stats.
7. Use **Ban** to remove a user (requires an admin token).

### About banning

- On the backend, banning means **`DELETE /usuarios/:id`** (permanent deletion).
- Deleted users no longer appear in API lists; the app keeps a **local cache** for the “Banned users” section and dashboard counter.
- There is no “unban” endpoint — simplified academic flow.

### Admin task permissions

With `role: admin`, `GET /tarefas` returns **all tasks**, enabling per-user statistics in the panel. Regular users still see only their own tasks.

---

## Troubleshooting

| Issue | Possible cause | What to do |
|-------|----------------|------------|
| `Erro ao iniciar o servidor` / connection failure | MySQL stopped or wrong credentials | Start MySQL; check `.env` |
| `Access denied for user` | MySQL user/password | Update `DB_USER` and `DB_PASSWORD` |
| App does not load tasks | API offline or wrong URL | Confirm `npm start` and `_baseUrl` in `api_client.dart` |
| `flutter run -d windows` fails | Missing C++ toolchain | Install VS 2022 with *Desktop development with C++*; run `flutter doctor` |
| Network error on Android emulator | `localhost` on emulator | Use `10.0.2.2:3000` instead of `localhost` (if testing on Android) |
| Invalid token after 1 h | JWT expiration | Log in again (`expiresIn: '1h'`) |
| Admin panel does not show | Stale JWT without updated `role` | Log out and log in after MySQL `UPDATE` |
| `403` when banning | Logged-in user is not admin | Confirm `role = 'admin'` in DB and re-login |
| Login required every launch | Token not persisted | Run `flutter pub get`; confirm `flutter_secure_storage` dependency |

---

## Academic context

This repository documents an **academic software development project**. The goal is to demonstrate integration between mobile/desktop (Flutter), REST API (Node.js/Express), and a relational database (MySQL), applied to real cognitive accessibility needs for people with ADHD.

---

## License

Academic project — contact the course authors or institution for terms of use and distribution.

---

## Quick reference

| Command | Location |
|---------|----------|
| `npm install` | `backend/` |
| `npm start` | `backend/` — starts API on port 3000 |
| `npx sequelize-cli db:migrate` | `backend/` — manual migrations |
| `flutter pub get` | `flutter_application_1/` |
| `flutter run -d windows` | `flutter_application_1/` — desktop app |
