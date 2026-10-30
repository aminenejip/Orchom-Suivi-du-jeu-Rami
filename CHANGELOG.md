# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Planned

- Export / share game results as an image
- Statistics across game history
- Sound library overhaul & mute toggle per button

## [1.0.0] — 2026-10-30

### Added

- Game setup for **2 or 4 players** with named players and optional photo avatars (camera or gallery, auto-compressed to JPEG).
- Configurable **target score** with automatic end-of-game detection and a results screen (winner & loser ranking).
- Configurable **Ghalta penalty** scoring.
- **Quick score buttons** with customizable labels/values and optional playback of bundled sound effects.
- **Starter modes**: rotation, random, and manual — with proper reverse rotation on undo.
- Round-by-round tracking with full **undo of the last round**.
- **Game history** persisted in a local SQLite database.
- Light, dark, and system **theme modes** with a custom design system (colors, spacing, text styles, shadows, animations).
- Full **English and Arabic localization**.
- Loading screen while the database initializes.
