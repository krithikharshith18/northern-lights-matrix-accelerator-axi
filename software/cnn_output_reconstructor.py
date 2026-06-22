import os

print(os.getcwd())
import numpy as np
from PIL import Image

# =========================
# PARAMETERS
# =========================
O = 255
NUM_FILTERS = 4

# =========================
# READ OUTPUT FILE
# =========================
with open(r"C:\Users\aklav\Desktop\Northern_Lights_32bit\Northern_Lights_32bit.sim\sim_1\behav\xsim\output.txt","r") as f:
    lines = [line.strip() for line in f if line.strip() != ""]

print("Total lines:", len(lines))

data = [list(map(int, line.split())) for line in lines]

# =========================
# GROUP INTO TILES
# =========================
tiles = []

for i in range(0, len(data), 4):
    if i + 3 < len(data):
        tiles.append(np.array(data[i:i+4]))

print("Tiles read:", len(tiles))

expected_tiles = (O*O + 3)//4
print("Expected tiles:", expected_tiles)

# trim extra tile if TB added one
if len(tiles) > expected_tiles:
    print("Trimming extra tile...")
    tiles = tiles[:expected_tiles]

# =========================
# RECONSTRUCT FEATURE MAPS
# =========================
feature_maps = [np.zeros((O, O), dtype=int) for _ in range(NUM_FILTERS)]

tile_id = 0

for idx in range(O * O):

    r = idx // O
    c = idx % O

    if idx % 4 == 0:
        tile = tiles[tile_id]
        tile_id += 1

    k = idx % 4

    for f in range(NUM_FILTERS):
        feature_maps[f][r][c] = tile[f][k]

print("Reconstruction done ✔")
print("Tiles used:", tile_id)

# =========================
# SAVE FEATURE MAPS
# =========================
def save_fmap(arr, name):
    arr = arr.astype(np.float32)
    arr -= arr.min()
    if arr.max() != 0:
        arr /= arr.max()
    arr *= 255
    img = Image.fromarray(arr.astype(np.uint8))
    img.save(name)

for i in range(NUM_FILTERS):
    save_fmap(feature_maps[i], fr"C:\Users\aklav\Desktop\Northern_Lights_32bit\Northern_Lights_32bit.sim\sim_1\behav\xsim\fmap_{i}.png" )

print("Feature maps saved ✔")