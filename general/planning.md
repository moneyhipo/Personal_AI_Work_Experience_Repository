# Planning and writing docs

## With several planning materials, compare where they disagree first

**Situation**: One project had an idea doc (web MVP, no live translation), an extra idea memo (live screen translation, auto registration), UI mockups (mobile app), and an already-submitted plan PDF. Even inside the PDF, the body said Android app while the architecture diagram, role split and figures were web-based, and the same feature was "long-term extension" in one place and "required" in another. Mid-work the user uploaded another PDF, changing part of the tech stack already chosen.

**Rules**
- Before writing a planning doc, check every material in the folder (including files git does not track, PDFs, images) and compare platform, scope, required features and tech stack per material.
- Do not pick disagreeing items yourself; ask with options and a recommendation.
- If a plan was already submitted, treat it as the baseline. Record changes in the progress doc as a table `item | original plan | now | reason`. It must be explainable as-is in a class or contest presentation.
- When reviewing a submission doc, report contradictions, items the template requires but are missing, guide text to delete before submitting, and typos, separately with page numbers.

## For auto-collection ideas, first check the real fields of the data source

**Situation**: An idea: "detect card payment history and auto-register bought clothes in the closet".

**Cause**: Card payment history only has merchant name, amount and time, no product name, options or photo. The MyData API that brings Korean card history into an app is only for licensed businesses.

**Rules**: For auto-collection features, first check per source which fields you can actually get and the access requirements, and tell the user. Offer other sources that have the needed info (here: order history screenshots, order confirmation pages, receipts).

## Split feature docs into subfolders by kind

**Situation**: 14 feature docs were created in one `docs/features/` folder; the user asked to split them into subfolders by kind.

**Rules**
- Once there are several feature docs, split from the start as `docs/features/<kind>/<feature>.md` (e.g. `wardrobe/`, `translation/`, `release/`).
- Keep a per-folder doc list in `docs/features/README.md`. When moving docs, fix all relative links, then check with a script that no link is broken.

## Encode parentheses in file names inside Markdown links

**Situation**: A link to `메인 화면(베이스).png` broke at the `)`.

**Rules**: In link targets write spaces as `%20` and parentheses as `%28`/`%29`. When a doc is done, check with a script that relative links point at real files.
