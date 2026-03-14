import random
from collections import Counter
import os

DICT_FOLDER = "."  # folder containing 3.txt–12.txt and full-simple.txt

# -------------------------
# Load master dictionary
# -------------------------
def load_master_dictionary():
    try:
        with open(os.path.join(DICT_FOLDER, "full-simple.txt")) as f:
            return set(w.strip().upper() for w in f)
    except FileNotFoundError:
        return set()

master_dict = load_master_dictionary()

# -------------------------
# Load secret words 5–12 letters and filter
# -------------------------
def load_words(length, master_dict=None):
    filename = os.path.join(DICT_FOLDER, f"{length}.txt")
    try:
        with open(filename) as f:
            words = [w.strip().upper() for w in f]
            if master_dict:
                words = [w for w in words if w in master_dict]
            return words
    except FileNotFoundError:
        return []

secret_words = []
for l in range(5, 13):
    secret_words += load_words(l, master_dict)

# -------------------------
# Weighted selection function
# -------------------------
def choose_secret_word(words):
    weights = []
    for w in words:
        l = len(w)
        if 7 <= l <= 9:
            weights.append(4)      # strongly favor 7-9 letters
        elif l == 6:
            weights.append(0.5)     # unlikely 6-letter words
        elif l == 5:
            weights.append(0.1)     # very unlikely 5-letter words
        else:
            weights.append(1)       # default weight for others
    return random.choices(words, weights=weights, k=1)[0]

# -------------------------
# Simulation
# -------------------------
results = []
N = 10000  # number of picks
for _ in range(N):
    if not secret_words:
        break
    w = choose_secret_word(secret_words)
    results.append(len(w))

counts = Counter(results)

# -------------------------
# Print text-based histogram
# -------------------------
print(f"Simulation over {N} picks (filtered by full-simple.txt):")
if counts:
    max_count = max(counts.values())
    scale = 50 / max_count  # scale bars to max 50 chars
    for length in range(5, 13):
        cnt = counts.get(length, 0)
        bar = "#" * int(cnt * scale)
        print(f"{length:2} | {cnt:5} | {bar}")
else:
    print("No eligible words found after filtering by full-simple.txt.")