# Android apps and Google Play release

## If a store launch is the goal, put the closed testing period in the schedule from the start

**Situation**: A semester project aimed at a full Play Store launch in week 15. Personal developer accounts created after 2023-11-13 must run a closed test with at least 12 testers opted in for 14 consecutive days before they can apply for production; until then the production menu is locked (checked 2026-10).

**Cause**: Treating release as only the last step after development leaves this period out of the schedule.

**Rules**
- If launch is the goal, make creating the developer account and recruiting testers task #1 in the first planning week. Gather about 15 to allow for drop-outs.
- Count back from the launch date: closed test start = launch date − 14 days − slack for the production access review. Upload a first build then even if features are unfinished.
- Check target API requirements too. From 2026-08-31 new apps must target Android 16 (API 36) or higher.
- Store policy changes often. When writing it in a doc, note the date checked and the official doc link, and recheck right before launch.
  - Testing requirement: https://support.google.com/googleplay/android-developer/answer/14151465
  - Target API: https://developer.android.com/google/play/requirements/target-sdk

## For designs that open other people's websites in a WebView, write down the spam policy risk first

**Situation**: A feature was designed to open overseas shops in an in-app browser (WebView) and translate the page text in place. Play's spam policy bans apps whose main purpose is showing others' websites in a WebView without permission, and lists "an app wrapping another company's shop in a WebView" as a violation example.

**Rules**
- For designs opening third-party sites in a WebView, put this policy on the risk list at the planning stage and tell the user.
- Build mitigations into the design: make the app's main purpose (its own features) clear on screen and in the store listing, support address entry like a general browser rather than one site only, and use text names instead of third-party logos (logos risk the IP policy).
- Prepare a fallback path in case review rejects it (e.g. receive links/screenshots via the share intent from other apps).
- Policy text: https://support.google.com/googleplay/android-developer/answer/9899034
