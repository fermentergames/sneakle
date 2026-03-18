import os

INPUT_START = 4
INPUT_END = 12
OUTPUT_FOLDER = "output"
WHITELIST_FILE = "whitelist.txt"
LOG_FILE = "removed_log.txt"

os.makedirs(OUTPUT_FOLDER, exist_ok=True)

# Load whitelist
if os.path.exists(WHITELIST_FILE):
    with open(WHITELIST_FILE) as f:
        WHITELIST = set(w.strip().lower() for w in f if w.strip())
else:
    WHITELIST = set()

def is_basic_plural(word):
    if word in WHITELIST:
        return False

    if word.endswith("es"):
        return True

    if word.endswith("s"):
        if word.endswith(("ss", "us", "is")):
            return False
        return True

    return False


# Clear old log
open(LOG_FILE, "w").close()

def process_file(filename):
    with open(filename) as f:
        words = [w.strip().lower() for w in f]

    kept = []
    removed = []

    for w in words:
        if is_basic_plural(w):
            removed.append(w)
        else:
            kept.append(w)

    output_path = os.path.join(OUTPUT_FOLDER, filename)

    with open(output_path, "w") as f:
        f.write("\n".join(kept))

    with open(LOG_FILE, "a") as log:
        log.write(f"\n=== {filename} ===\n")
        for w in removed:
            log.write(w + "\n")

    print(f"{filename} -> {output_path} ({len(removed)} removed)")


for i in range(INPUT_START, INPUT_END + 1):
    process_file(f"{i}.txt")

print("All files processed!")
print(f"Removal log saved to {LOG_FILE}")
