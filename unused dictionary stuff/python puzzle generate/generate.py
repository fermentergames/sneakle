import json
import os
import re
import random
import argparse
from collections import defaultdict

# -------------------------
# SNEAKLE PUZZLE GENERATOR WOOOOOOOOO!!
# -------------------------

# -------------------------
# CONFIGURATION (default values)
# -------------------------
BOARD_COUNT = 10        # default number of boards to generate
BOARD_SIZE = 5         # default board size - set from 3-7
SHOW_BOARD_PREVIEW = True # shows preview of board with rows and columns laid out as they would be in game 
USE_RANDOM_FILL = False # instead of each row being a word, just fill empty tiles with the LETTER_SET_DEFAULT
FORCED_SECRET_WORD = "IMPACT" # None # set to a string like "REMINDER" to force a specific secret word

LETTER_SET_DEFAULT = (
    "AAAAAAAAAAAAABBBCCCDDDDDDEEEEEEEEEEEEEEEEEEFFFGGGGHHH"
    "IIIIIIIIIIIIJJKKLLLLLMMMNNNNNNNNOOOOOOOOOOOPPPQQRRRRRRRRRSSSSSSTTTTTTTTTUUUUUUVVVWWWXXYYYZZ"
)

SCRIPT_DIR = os.path.dirname(os.path.abspath(__file__))
DICT_FOLDER = SCRIPT_DIR  # folder containing 3.txt → 12.txt and full-simple.txt

# -------------------------
# PREMADE PATHS (0-indexed)
# -------------------------
PREMADE_PATHS = {
    3: [
        [(0,0),(1,0),(2,0),(1,1),(2,1),(2,2),(1,2),(0,1),(0,2)],
        [(2,1),(2,2),(1,1),(2,0),(1,0),(0,0),(0,1),(1,2),(0,2)],
        [(0,1),(0,0),(1,0),(1,1),(0,2),(1,2),(2,2),(2,1),(2,0)]
    ],
    4: [
        [(0,2),(0,3),(1,2),(1,3),(2,3),(3,3),(3,2),(2,1),(2,2),(1,1),(0,0),(0,1),(1,0),(2,0),(3,1),(3,0)],
        [(2,1),(3,2),(3,3),(2,2),(3,1),(3,0),(2,0),(1,0),(1,1),(0,0),(0,1),(0,2),(0,3),(1,2),(2,3),(1,3)],
        [(0,0),(1,0),(2,0),(1,1),(1,2),(0,3),(1,3),(2,3),(3,3),(2,2),(3,1),(3,0),(2,1)]
    ],
    5: [
        [(0,4),(1,4),(2,4),(1,3),(0,3),(0,2),(1,2),(2,2),(2,3),(3,4),(3,3),(3,2),(2,1),(3,1),(4,0),(4,1),(3,0),(2,0),(1,0),(1,1),(0,0),(0,1)],
        [(1,2),(2,3),(2,4),(3,4),(4,4),(4,3),(3,3),(4,2),(4,1),(4,0),(3,1),(2,2),(3,2),(2,1),(3,0),(2,0),(1,0),(1,1),(0,0),(0,1),(0,2),(1,3),(0,3),(1,4),(0,4)],
        [(0,0),(1,0),(2,0),(3,0),(3,1),(2,2),(1,2),(1,3),(0,4),(1,4),(2,4),(3,4),(4,3),(4,2),(3,2),(2,1),(1,1),(0,2),(0,3)]
    ],
    6: [
        [(1,3),(1,4),(2,4),(2,5),(1,5),(0,4),(0,3),(0,2),(1,2),(2,2),(3,3),(3,4),(3,5),(4,5),(5,5),(5,4),(4,4),(5,3),(5,2),(4,3),(4,2),(5,1),(5,0),(4,0),(3,1),(2,1),(1,1),(0,0),(0,1),(1,0),(2,0),(3,0),(4,1),(3,2),(2,3)],
        [(4,0),(5,0),(4,1),(3,1),(3,2),(4,2),(5,1),(5,2),(5,3),(5,4),(4,3),(4,4),(3,5),(2,5),(1,4),(1,5),(0,4),(0,3),(0,2),(1,2),(0,1),(1,1),(1,0),(2,0),(3,0),(2,1),(2,2),(1,3),(2,3),(3,3),(2,4),(3,4),(4,5),(5,5)],
        [(2,1),(1,2),(1,3),(1,4),(2,5),(3,5),(4,4),(3,3),(4,3),(4,2),(4,1),(5,0),(4,0),(3,0),(2,0),(1,1),(2,2),(2,3),(3,2),(3,1)],
        [(3,0),(2,0),(1,0),(0,1),(0,2),(1,3),(2,4),(3,3),(4,3),(4,2),(5,2),(5,3),(5,4),(4,5),(3,5),(2,5),(1,4),(2,3),(2,2),(2,1),(3,1),(4,0),(5,0)]
    ],
    7: [
        [(2,2),(3,3),(2,3),(1,4),(1,3),(2,2),(1,2),(1,1),(2,1),(3,2),(4,3),(3,4),(4,5),(5,6),(6,6),(5,5),(6,5),(6,4),(0,4),(6,2),(5,2),(4,1),(5,1),(6,1),(6,0),(5,0),(4,0),(3,0),(2,0),(3,1),(4,2),(5,3),(5,4),(4,4),(3,5),(4,6),(3,6),(2,6),(2,5),(3,4),(1,5),(1,6),(0,5),(0,4)],
        [(6,2),(5,2),(4,2),(5,1),(6,0),(5,0),(5,1),(4,2),(3,3),(3,3),(2,3),(1,1),(3,0),(2,1),(1,2),(1,1),(0,1),(0,2),(0,3),(1,3),(2,4),(1,4),(1,5),(0,5),(0,6),(1,6),(2,6),(3,6),(4,6),(5,6),(6,5),(5,5),(4,5),(4,4),(4,3),(3,3),(2,3),(2,2)],
        [(4,0),(5,0),(6,0),(6,1),(6,2),(5,3),(5,4),(4,5),(3,4),(3,3),(4,3),(4,2),(3,1),(2,1),(1,2),(2,3),(2,4),(1,5),(1,6),(2,6),(3,6),(4,5),(4,4),(5,5),(5,6),(4,6),(3,5),(2,4),(1,2)]
    ]
}

# -------------------------
# DICTIONARY LOADING
# -------------------------

def load_master_dictionary():
    try:
        with open(f"{DICT_FOLDER}/full-simple.txt") as f:
            return set(w.strip().upper() for w in f)
    except FileNotFoundError:
        return set()

def load_words(length, master_dict=None):
    try:
        with open(f"{DICT_FOLDER}/{length}.txt") as f:
            words = [w.strip().upper() for w in f]
            if master_dict:
                words = [w for w in words if w in master_dict]
            return words
    except FileNotFoundError:
        return []

def load_secret_words(master_dict=None):
    words = []
    for l in range(5,13):
        words += load_words(l, master_dict)
    return words

# -------------------------
# GRID UTILITIES
# -------------------------

def init_grid(size):
    return [['' for _ in range(size)] for _ in range(size)]

# -------------------------
# PATH TRANSFORMS
# -------------------------

def rotate(path, size):
    return [(y, size-1-x) for x,y in path]

def mirror_h(path, size):
    return [(size-1-x,y) for x,y in path]

def mirror_v(path, size):
    return [(x,size-1-y) for x,y in path]

def transform_path_randomly(path, size):
    p = path[:]
    for _ in range(random.randint(0,3)):
        p = rotate(p, size)
    if random.random() < 0.5:
        p = mirror_h(p, size)
    if random.random() < 0.5:
        p = mirror_v(p, size)
    return p

# -------------------------
# SECRET WORD SELECTION
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
# VALIDATION
# -------------------------

def valid(word, row, grid):
    for x,c in enumerate(word):
        if grid[row][x] and grid[row][x] != c:
            return False
    return True

# -------------------------
# POSITION INDEX
# -------------------------

# def build_position_index(words):
#     size = len(words[0])
#     index = [dict() for _ in range(size)]
#     for w in words:
#         for i,c in enumerate(w):
#             if c not in index[i]:
#                 index[i][c] = []
#             index[i][c].append(w)
#     return index

def build_position_index(words):
    index = {}

    for w in words:
        for i, c in enumerate(w):
            key = (i, c)

            if key not in index:
                index[key] = set()

            index[key].add(w)

    return index

# def get_candidates(row, grid, row_words, index):
#     size = len(grid)
#     candidates = None
#     for x in range(size):
#         letter = grid[row][x]
#         if letter:
#             col_list = index[x].get(letter, [])
#             if candidates is None:
#                 candidates = set(col_list)
#             else:
#                 candidates &= set(col_list)
#             if not candidates:
#                 return []
#     if candidates is None:
#         return row_words
#     return list(candidates)

def get_candidates(row, grid, row_words, index, used_words):
    size = len(grid)

    sets = []

    for x in range(size):
        c = grid[row][x]
        if c:
            s = index.get((x, c))
            if s:
                sets.append(s)
            else:
                return []  # impossible row

    if sets:
        candidates = set.intersection(*sets)
    else:
        candidates = set(row_words)

    # remove used words
    candidates -= used_words

    return list(candidates)

##############    

def row_too_similar_to_secret(row_word, secret_word, threshold=0.8):
    if row_word == secret_word:
        return True

    # longest matching ordered subsequence
    match = 0
    j = 0

    for c in row_word:
        if j < len(secret_word) and c == secret_word[j]:
            match += 1
            j += 1

    if match / len(secret_word) >= threshold:
        return True

    return False

# -------------------------
# SOLVER (unique row words)
# -------------------------

MAX_SOLVE_STEPS = 50000
solve_steps = 0

def solve(grid, row_words, index, row=0, used_words=None, secret_word=None):

    global solve_steps
    solve_steps += 1

    if solve_steps > MAX_SOLVE_STEPS:
        # solve_steps = 0 #reset, nah done in generate
        # print("solve_steps maxed")
        return False

    size = len(grid)
    if used_words is None:
        used_words = set()
    if row == size:
        return True
    if all(grid[row][x] for x in range(size)):
        return solve(grid, row_words, index, row + 1, used_words)

    # candidates = get_candidates(row, grid, row_words, index)
    candidates = get_candidates(row, grid, row_words, index, used_words)
    random.shuffle(candidates)

    # print("---")
    for w in candidates:
        # if w in used_words:
        #     continue
        if secret_word and row_too_similar_to_secret(w, secret_word):
            continue
        if valid(w, row, grid):
            backup = grid[row][:]
            grid[row] = list(w)
            used_words.add(w)
            # print("w", w)
            if solve(grid, row_words, index, row + 1, used_words, secret_word):
                # print("row", row)
                return True
            used_words.remove(w)
            grid[row] = backup
    return False

# -------------------------
# ROW-BLOCK CHECK
# -------------------------

def path_blocks_row(secret_path, size, threshold=0.6):
    rows = defaultdict(int)
    for x, y in secret_path:
        rows[y] += 1
    for count in rows.values():
        if count / size >= threshold:
            return True
    return False

# -------------------------
# ENCODING
# -------------------------

def encode_board_for_load(grid, path):
    size = len(grid)
    flat = "".join("".join(r) for r in grid)
    coords = [str(y*size + x + 1) for x,y in path]
    return f"loadBoard={flat}&loadSecret={'-'.join(coords)}"

# -------------------------
# RANDOM LETTER FILL
# -------------------------

def fill_remaining_with_random_letters(grid):
    letters = list(LETTER_SET_DEFAULT)
    size = len(grid)
    for y in range(size):
        for x in range(size):
            if not grid[y][x]:
                grid[y][x] = random.choice(letters)

# -------------------------
# PRINT BOARD
# -------------------------

def print_board(grid):
    for row in grid:
        print(" ".join(row))

# example:
# R E M I N D
# E Q U I T Y
# A V E N U E
# R E V E A L
# R O S T E R
# S T I C K Y

# -------------------------
# GENERATE SINGLE BOARD
# -------------------------

def generate_board(size, row_words, index, secret_words, board_number, forced_secret_word=None):

    # if size not in PREMADE_PATHS:
    # raise ValueError(f"No premade paths defined for board size {size}")

    grid = init_grid(size)
    path = transform_path_randomly(random.choice(PREMADE_PATHS[size]), size)

    eligible = [w for w in secret_words if len(w) <= len(path)]
    if not eligible:
        return None

    word = forced_secret_word if forced_secret_word else choose_secret_word(eligible)
    if len(word) > len(path):
        return None
    start = random.randint(0, len(path)-len(word))
    secret_path = path[start:start+len(word)]

    for i, (x, y) in enumerate(secret_path):
        grid[y][x] = word[i]

    # skip if path blocks too much of a row
    if path_blocks_row(secret_path, size, threshold=0.8):
        return None

    # Fill the rest
    if not USE_RANDOM_FILL:
        global solve_steps
        solve_steps = 0 #reset
        # print("solve_steps start:", solve_steps)
        if not solve(grid, row_words, index, secret_word=word):
            return None
    else:
        fill_remaining_with_random_letters(grid)

    mode_str = "randomFilled" if USE_RANDOM_FILL else "rowsAreWords"

    return {
        "title": f"{size}x{size} - {mode_str} - #{board_number}",
        "secret_word": word,
        "encoded": encode_board_for_load(grid, secret_path),
        "grid": grid
    }

# -------------------------
# GENERATE MULTIPLE BOARDS
# -------------------------

def generate_multiple_boards(count=5, board_size=5, preview=SHOW_BOARD_PREVIEW, forced_secret_word=None):
    master_dict = load_master_dictionary()
    row_words = load_words(board_size, master_dict)
    random.shuffle(row_words)  # randomize row word order
    index = build_position_index(row_words)
    secret_words = load_secret_words(master_dict)

    if not secret_words:
        raise RuntimeError(
            f"No secret words loaded from {DICT_FOLDER}. "
            "Make sure full-simple.txt and length dictionaries exist."
        )

    if forced_secret_word:
        forced_secret_word = forced_secret_word.strip().upper()
        if not forced_secret_word.isalpha():
            raise ValueError("Secret word must contain letters only.")

        max_secret_len = max(len(p) for p in PREMADE_PATHS[board_size])
        if len(forced_secret_word) > max_secret_len:
            raise ValueError(
                f"Secret word '{forced_secret_word}' is too long for {board_size}x{board_size}. "
                f"Max supported length is {max_secret_len}."
            )

    mode_str = "randomFilled" if USE_RANDOM_FILL else "rowsAreWords"

    filename = f"boards_{board_size}x{board_size}_{mode_str}.json"
    output_path = os.path.join(SCRIPT_DIR, filename)

    # Load existing boards if file exists
    if os.path.exists(output_path):
        with open(output_path) as f:
            try:
                existing_boards = json.load(f)
            except json.JSONDecodeError:
                existing_boards = []
    else:
        existing_boards = []

    # Determine starting board number based on last title
    if existing_boards:
        last_title = existing_boards[-1]["title"]
        match = re.search(r"#(\d+)$", last_title)
        if match:
            next_board_number = int(match.group(1)) + 1
        else:
            next_board_number = 1
    else:
        next_board_number = 1

    boards = []
    attempts = 0
    while len(boards) < count and attempts < count*50:
        attempts += 1
        print("Attempt", attempts)
        board_number = next_board_number + len(boards)
        b = generate_board(
            board_size,
            row_words,
            index,
            secret_words=secret_words,
            board_number=board_number,
            forced_secret_word=forced_secret_word,
        )
        if b:
            boards.append(b)
            print(b["encoded"])
            print(f"Secret: {b['secret_word']}")
            if preview:
                print_board(b["grid"])

    # Strip 'grid' before saving
    boards_to_save = [{k:v for k,v in b.items() if k != "grid"} for b in boards]

    # Append to existing JSON and save
    existing_boards.extend(boards_to_save)
    with open(output_path, "w") as f:
        json.dump(existing_boards, f, indent=2)

    print(f"\n=========================================================")

    for i,b in enumerate(boards):
        print(f"\nBoard {i+1} ({b['secret_word']}):")
        print(b["encoded"])
        if preview:
            print_board(b["grid"])

    print(f"\n==========Generated {len(boards)} boards, now {len(existing_boards)} total, saved to {output_path}===========")


# -------------------------
# MAIN
# -------------------------

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Generate letter grid boards")
    parser.add_argument("--count", type=int, help="Number of boards to generate")
    parser.add_argument("--size", type=int, help="Board size (4-7)")
    parser.add_argument("--secret-word", type=str, help="Force a specific secret word")
    parser.add_argument("--preview", action="store_true", help="Show board preview (overrides default)")
    parser.add_argument("--no-preview", action="store_true", help="Hide board preview")
    parser.add_argument("--random_letters", action="store_true", help="Fill empty spaces with random letters instead of words")
    args = parser.parse_args()

    count = args.count if args.count else BOARD_COUNT
    size = args.size if args.size else BOARD_SIZE
    if args.preview:
        SHOW_BOARD_PREVIEW = True
    elif args.no_preview:
        SHOW_BOARD_PREVIEW = False
    USE_RANDOM_FILL = args.random_letters or USE_RANDOM_FILL
    secret_word = args.secret_word if args.secret_word else FORCED_SECRET_WORD

    print(f"Generating {count} boards of size {size}x{size}")
    generate_multiple_boards(count, size, forced_secret_word=secret_word)
    input("\nPress Enter to exit...")