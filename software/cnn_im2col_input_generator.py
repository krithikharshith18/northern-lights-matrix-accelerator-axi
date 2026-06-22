from PIL import Image
import numpy as np

# =========================
# LOAD IMAGE (256x256)
# =========================
img = Image.open("testimage.jpg").convert("L")
I_np = np.array(img)

H, W = I_np.shape
assert H == 256 and W == 256, "Image must be 256x256"

I = I_np.tolist()

print("Image loaded:", H, "x", W)

# =========================
# FILTERS (4 filters, 2x2)
# =========================
filters = [
    [1, 2, 3, 4],
    [1, 0, 0, 1],
    [0, 1, 1, 0],
    [1, -1, 1, -1]
]

# =========================
# GENERATE PATCHES
# =========================
K = 2
O = H - K + 1   # 255

patches = []

for r in range(O):
    for c in range(O):
        patch = [
            I[r][c],
            I[r][c+1],
            I[r+1][c],
            I[r+1][c+1]
        ]
        patches.append(patch)

print("Total patches:", len(patches))

# =========================
# GROUP INTO TILES
# =========================
tiles = []

for i in range(0, len(patches), 4):
    group = patches[i:i+4]

    while len(group) < 4:
        group.append([0,0,0,0])

    tiles.append(group)

NUM_TILES = len(tiles)
print("NUM_TILES:", NUM_TILES)   # should be 16257

# =========================
# GENERATE STREAM
# =========================
stream = []

for tile in tiles:

    # A (filters)
    for f in range(4):
        for val in filters[f]:
            stream.append(int(val))

    # B (interleaved)
    for k in range(4):
        for t in range(4):
            stream.append(int(tile[t][k]))

# =========================
# WRITE FILE
# =========================
with open("input.txt", "w") as f:
    for v in stream:
        f.write(str(v) + "\n")

print("input.txt generated ✔")