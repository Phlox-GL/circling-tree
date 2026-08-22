# 2026-08-22 14:24 — Phlox main follow-up

- Repointed `deps.cirru` from the temporary Phlox migration branch to merged `Phlox-GL/phlox` `main`.
- Kept the migrated `Triadica/touch-control` branch pinned until that dependency is merged.
- Updated the upload workflow to use the current `calcit calcit.cirru js` command.
- Added the direct `hsluv` runtime dependency required by the current Phlox-generated JS output.
- Re-generated JS with Calcit 0.13.29 and verified `calcit --check-only calcit.cirru` plus the Vite production build.
