import os
import struct
import sys

out_dir = sys.argv[1]
sources = sys.argv[2:]

for src in sources:
    data = bytearray(open(src, "rb").read())
    num_tables = struct.unpack(">H", data[4:6])[0]
    cmap = None
    name = None
    for i in range(num_tables):
        off = 12 + i * 16
        tag = data[off:off + 4]
        if tag == b"cmap":
            cmap = struct.unpack(">I", data[off + 8:off + 12])[0]
        elif tag == b"name":
            name = struct.unpack(">I", data[off + 8:off + 12])[0]
    if cmap is None:
        raise SystemExit("no cmap table in " + src)
    # 上游把 cmap 标成 MS Symbol（3,0），FreeType 按 Symbol 取字形，kitty 拿不到
    # 中文和 ASCII 的 glyph；改成 Unicode BMP（0,3）让所有应用都能直接使用。
    records = struct.unpack(">H", data[cmap + 2:cmap + 4])[0]
    for j in range(records):
        rec = cmap + 4 + j * 8
        if struct.unpack(">HH", data[rec:rec + 4]) == (3, 0):
            struct.pack_into(">HH", data, rec, 0, 3)
    base = os.path.basename(src)
    with open(os.path.join(out_dir, base), "wb") as f:
        f.write(data)
    if not base.endswith("12pt.otb"):
        continue
    # kitty 的等宽后备要 12pt 点阵，单独一个 family 名，避免 fontconfig
    # 在 9/10/11/12pt 里先选中 9pt 或 10pt。
    if name is None:
        raise SystemExit("no name table in " + src)
    count, string_offset = struct.unpack(">HH", data[name + 2:name + 6])
    family = "WenQuanYi Bitmap Song 12pt Mono".encode("utf-16-be")
    for j in range(count):
        rec = name + 6 + j * 12
        platform, _, _, name_id, length, offset = struct.unpack(">HHHHHH", data[rec:rec + 12])
        if platform == 3 and name_id in (1, 4):
            if length != len(family):
                raise SystemExit("unexpected name record length in " + src)
            start = name + string_offset + offset
            data[start:start + length] = family
    with open(os.path.join(out_dir, "wenquanyi_12pt_mono.otb"), "wb") as f:
        f.write(data)
