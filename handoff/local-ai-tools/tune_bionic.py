import json, os, shutil, time

H = os.path.expanduser("~/.lmstudio")
B = os.path.join(H, "apps", "bionic")
NEW_MODELS = r"D:\ai\lm-models"
stamp = time.strftime("%Y%m%d_%H%M%S")


def load(p):
    with open(p, encoding="utf-8") as f:
        return json.load(f)


def save(p, d):
    shutil.copy2(p, p + ".bak_" + stamp)
    with open(p, "w", encoding="utf-8") as f:
        json.dump(d, f, ensure_ascii=False, indent=2)
    print("saved", p)


# 1) Bionic main settings
p = os.path.join(B, "settings.json")
s = load(p)
s["language"] = "ko"
s["downloadsFolder"] = NEW_MODELS
s["chat"]["moveDeletedItemsToTrash"] = True
s["developer"]["jitModelTTL"] = {"enabled": True, "ttlSeconds": 600}
s["developer"]["showResourceConsumptionWidget"] = True
s["defaultContextLength"] = {"type": "custom", "value": 16384}
save(p, s)

# 2) Bionic internal settings
p = os.path.join(B, ".internal", "settings.json")
s = load(p)
s["appLanguage"] = "ko"
s["notifications"]["sessionCompletedEnabled"] = True
save(p, s)

# 3) classic LM Studio settings (same models folder)
p = os.path.join(H, "settings.json")
s = load(p)
s["downloadsFolder"] = NEW_MODELS
save(p, s)

# 4) local server: don't write prompts/answers into log files
p = os.path.join(H, ".internal", "http-server-config.json")
s = load(p)
s["logSensitiveData"] = False
save(p, s)

# 5) move models C: -> D:
src = os.path.join(H, "models")
os.makedirs(NEW_MODELS, exist_ok=True)
for name in os.listdir(src):
    dst = os.path.join(NEW_MODELS, name)
    if os.path.exists(dst):
        print("skip (exists)", dst)
        continue
    print("moving", name, "...", flush=True)
    shutil.move(os.path.join(src, name), dst)
print("models now in", NEW_MODELS, os.listdir(NEW_MODELS))
