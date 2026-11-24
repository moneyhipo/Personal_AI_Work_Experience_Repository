# AI illustration for game assets (NovelAI)

Collected 2026-11-25 for the Lantern game (soft pastel anime style, slime girl + enemies). Sources: two Korean web-fiction community tip posts, a Korean character-AI community style study (NAI V4), NovelAI official docs, rentry "Blue's guide on NAI image gen", foxcg NovelAI guide. **Not yet tested by us**: the user said the prompts will be tuned when actually generating. Project copy (Korean, with tables): `lantern/docs/참고/AI일러-팁.md`; style decision: `lantern/docs/기획/18-그림규격.md` "그림체".

### Fetching the community posts
**Situation**: arca.live posts returned HTTP 403 to WebFetch.
**Rules**: Do not retry arca.live with WebFetch; ask the user to paste the post text. NovelAI docs (`docs.novelai.net`), rentry and foxcg load fine.

### Writing prompts
**Situation**: Natural-language prompts (e.g. written by an LLM) and machine-translated words hit far less often than tags.
**Rules**
- Use Danbooru tag names, not sentences or translations (e.g. hand shielding the sun = `shading eyes`; upper body lower than hips = `top-down bottom-up`).
- Character order: count → framing → hair → eyes/skin → body → clothes (`1girl, solo, full body, ...`). Pin clothes with colours (`blue robe, brown gloves`), keep the character block verbatim, change one thing per test.
- Do not write what must not appear: `red eyes` + `closed eyes` forces the eyes open; `upper body` + `black pantyhose` pulls the legs in. To push a tag that will not stick, put its opposite in the negative or use `-1::open eyes::` (V4.5+).
- Weighting: `{tag}` ×1.05 per brace, `[tag]` ÷1.05, `1.5::tag::` (V4+), `0.5::tag::` to weaken; SD-style `(tag:1.2)` does nothing.
- Tag position vs strength is disputed: community users (V4) say **later = stronger** and put the main artist **last**; official docs say put style tags first; foxcg says position no longer matters in V5. Test with a fixed seed instead of trusting one source.
- V4 artist mixing: several artist tags do not blend evenly; the model tends to pick one. Use few artists, main artist last, colour/body artists in front.

### Negative prompts copied from others
**Situation**: A copied negative prompt contained exactly what the user wanted, so generations kept missing.
**Rules**: Read every negative tag before using it. For game assets in particular:
- remove `multiple views` (in NAI's default Heavy preset) when generating turnarounds / sprite sheets;
- remove `chibi` when sprites are 2–3 heads tall;
- remove `disfigured` for grotesque monsters, `dynamic pose` / `dutch angle` / `negative space` when a cutscene needs them;
- `outline`, `simple`, `blurry` fight thin lineart, plain backgrounds and `soft focus`.
- Official V5 Heavy: `lowres, artistic error, film grain, scan artifacts, worst quality, bad quality, jpeg artifacts, very displeasing, chromatic aberration, dithering, halftone, screentone, multiple views, logo, too many watermarks, negative space, blank page`.

### Soft pastel style
- Tags (to test): `pastel colors, pale color, muted color, soft focus, soft lighting, dreamy atmosphere, pink theme, clean lineart, cell shading, gradient hair, colored tips, blush`. No documented tag for coloured (red/pink) lineart; try `color trace` + `pink theme`.
- Avoid `high contrast`, `anime coloring` (hard two-tone), `pastel (medium)` (crayon medium), `smooth shading` (less cel). Lower guidance = softer.
- Community V4 settings: steps 28, guidance 6, Euler Ancestral, Karras, guidance rescale 0.5; quality `{best quality, amazing quality, very aesthetic, highres, incredibly absurdres}`.
- Chosen combo for Lantern ("soft chibi fairy-tale"): `[[[[wagashi (dagashiya)]]]], [[[[artist:eonsang]]]], [[[[artist:nyong nyong]]]], artist:mikozin, artist:nakta, artist:tianliang duohe fangdongye, year 2024,`. Weakness: six artists → style drifts between images. Fallback with fewer artists: `[[[[artist:nakta]]]], [[artist:mikozin]], tianliang duohe fangdongye, year 2024,`. These were tuned on V4; a commenter says V4.5 does not reproduce them as-is.

### Keeping one character across many images
- Fixed seed + change one tag keeps the composition.
- Character Reference (Precise Reference, docs say V4.5): reference = clean full-body neutral pose on a plain background (1024×1536), optional face crop in a corner; cannot be combined with Vibe Transfer. Vibe Transfer copies style, not identity; a white-background reference drags outputs to white backgrounds.
- Sheets: `multiple views, turnaround`, `reference sheet, no text`, `expressions`; directions `facing viewer / from side / from behind / from above`. Backgrounds: `white background` then remove; `transparent background` in V5 is unverified.

### Do not use upscaled images as-is (covers, cutscene CG)
**Situation**: A 4× upscale looked fine small but lines smeared and stuck together when zoomed, especially the eyes.
**Rules** (MediBang Paint, free):
1. Bring in the original (832×1216) and the 4× upscale; resize to the same size (200% / 50% → 1664×2432).
2. Layer the upscale on top at 60–70% opacity and merge; the untouched areas get acceptable detail.
3. Crop the part to fix (face) into a 1024×1024 canvas (free i2i sizes: 832×1216, 1024×1024, 1216×832), save PNG, keep the paint program and layer positions untouched.
4. NAI i2i → inpaint only that area (do not paint up to the canvas edge). Detail only: Strength 0.2–0.4. Change (eye colour, gloves): higher Strength + the new tag.
5. Paste the result back on the crop layer, merge, paste into the full image.
- Small in-game sprites do not need this; only covers / store art / cutscene CG.
