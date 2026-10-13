# The Invisible Distance for BNBU

A small interactive campus-route prototype focused on a simple but often overlooked question:

> When a route is shorter in distance but full of stairs, is it truly the better route?

This project is a competition-oriented prototype for exploring the idea of the "invisible distance" caused by stairs and elevation burden on campus walking routes.

## Project Overview

This repository contains a lightweight static webpage that compares two routes:

- A shorter route with more stairs
- A longer route with fewer stairs

Users can switch scenarios such as:

- light load / normal walking
- carrying heavy items

The page simulates how step burden changes the perceived cost of a route and helps illustrate why a route with more stairs may not be the better choice in practice.

## Main Files

- `index.html` — main interactive demo page
- `indox.html` — alternate/experimental version of the page
- `download_bnbu_map.ps1` — PowerShell script for attempting to fetch a BNBU campus map image into the `assets` folder
- `assets/` — local asset directory for map images and supporting files

## What the Demo Shows

The prototype includes:

- a stylized campus map section
- two candidate routes labeled A and B
- simplified travel-time and stair-count statistics
- scenario-based cost calculation
- a recommendation mechanism based on stair burden

This is not a real navigation system and should not be used for actual pathfinding or campus guidance.

## How to Run

Because this is a static HTML project, you can view it by opening the file directly in a browser:

1. Open `index.html` in a browser
2. Interact with the route comparison and scenario controls
3. If needed, run the PowerShell helper to fetch map assets

### Optional: Download campus map asset

On Windows PowerShell:

```powershell
./download_bnbu_map.ps1
```

This script attempts to download a campus map image into the `assets` directory. It may require a valid network connection and the target image may change over time.

## Notes

- The project is intended as a prototype and demonstration for a competition
- Real-world route data may not be fully verified
- The cost formulas are simplified for demonstration purposes
- The project is not a complete production app or navigation system

## License

This repository does not appear to include an explicit license file. If you plan to redistribute or reuse this project, please check with the repository owner before publishing or commercializing it.

## Repository Context

This repo is a compact prototype built around a specific idea: the "distance" of a route is not only physical length, but also the hidden burden of stairs and effort. The project is a conceptual illustration rather than a full campus routing solution.

## Suggested Future Improvements

- replace mock route data with real measured walking data
- collect actual stair counts for specific campus paths
- add accessibility considerations for wheelchair and mobility users
- support responsive mobile layout
- integrate map tiles or real campus GIS data

---

Project name: The Invisible Distance

Repository description: "参赛专用，但是做不完了，对不起组委会"

This README was prepared to explain the purpose and usage of the repository while keeping the project context transparent.
