# World of Warcraft Addon

A lightweight quality-of-life addon for World of Warcraft.

## Features

### Bug Fixes

- Show the perks tab for Legion's Underlight Angler artifact
- Untrack completed achievements across characters
- Fix Rematch addon crash when opening the pet panel (introduced in 12.1)

### NPC Interactions

- Automatically deposit excess gold when visiting a banker
- Automatically repair when visiting a merchant
- Automatically sell junk items when visiting a merchant

### UI Improvements

- Display item level and enhancements on the character panel
- Hide healing indicators on player and pet frames
- Remove timer and typing restrictions from popups

### Quality of Life

- Simplify cinematic skipping
- Reverse container order
- Cast fishing rods and reel in with a single button

## Backlog

- **Notifications:** Notify of class-specific missing buffs (pets, buffs, perks [healthstones], etc).
- **Profession knowledge:** Show unspent profession skill points in badges.
- **Role highlight:** Show healer icon over players in PVP. Green tint for friendly players, red tint for enemies.
- **Streamer mode:** Show pressed button icons and player stats. Dragable frames.
- **Unit frame indicators:** Hide HP/mana text on frames when above a threshold.

## Development

### Deployment

The project includes bash scripts for development and deployment.

For a new installation, run a full deployment to copy the addon and dependencies to WoW's `Interface` folder:

```bash
bash scripts/deploy.sh full
```

For subsequent deployments, omit `full` if the `Ace3` libraries do not need to be updated:

```bash
bash scripts/deploy.sh
```
