# aohg-pkgs

Aohg 的个人 Nix 包集合。nixpkgs 中没有的包（或需要自定义补丁/变体的包）
都放在这里。

## 包列表

| 属性名 | 说明 | 上游 |
|--------|------|------|
| `maple-mono.NFPropo-CN` | Maple Mono NF CN 变体，带 Nerd Font 与比例连字 | [Aohgga/maple-font](https://github.com/Aohgga/maple-font) |
| `bilibili-mpv` | MPV 的 B 站弹幕/评论脚本 | [itKelis/MPV-Play-BiliBili-Comments](https://github.com/itKelis/MPV-Play-BiliBili-Comments) |
| `material-osc` | mpv 的 Material Design OSC，MD3E 不透明配色 + 中文界面 | [brahmkshatriya/material-osc](https://github.com/brahmkshatriya/material-osc) |

## 使用方法

### 作为 flake input

```nix
{
  inputs.aohg-pkgs = {
    url = "github:Aohgga/aohg-pkgs";
    inputs.nixpkgs.follows = "nixpkgs";
  };
}
```

然后直接引用包：

```nix
inputs.aohg-pkgs.packages.${pkgs.stdenv.hostPlatform.system}.bilibili-mpv
```

### 通过 overlay

```nix
{
  inputs.aohg-pkgs = {
    url = "github:Aohgga/aohg-pkgs";
    inputs.nixpkgs.follows = "nixpkgs";
  };
}
```

应用 overlay：

```nix
nixpkgs.overlays = [ inputs.aohg-pkgs.overlays.default ];
```

之后这些包就像普通 `pkgs` 属性一样可用：

```nix
programs.mpv.scripts = [ pkgs.bilibili-mpv ];
```

### 无需安装，直接构建

```bash
nix build github:Aohgga/aohg-pkgs#bilibili-mpv
nix build github:Aohgga/aohg-pkgs#maple-mono.NFPropo-CN
```

### 格式化

```bash
nix fmt        # 使用 nixfmt-rfc-style 格式化本仓库
```

## 各包说明

### `bilibili-mpv`

固定上游某个具体 commit，并把 Nix 提供的 Python 替换进脚本，
因此无需系统 `PATH` 中存在 Python 即可运行。

### `material-osc`

固定上游 `main` 的某个 commit，应用 `material-osc-md3e.patch` 后
用上游的 `bundle.py`（python + fonttools）重新打包，输出与上游
release 相同的 `scripts/material-osc.lua` 与 `fonts/`。

补丁相对上游的改动：

- 配色换成 MD3 暗色：面板/菜单/控件背景 `#211F26`、文字 `#E6E0E9`、
  次要文字 `#CAC4D0`、选中背景 `#4F378B`，强调色仍由 `accent_color` 控制。
- 去掉菜单、控制条、时间胶囊、弹窗面板的透明度（原来有半透明叠加）。
- 界面文案翻译为中文。
- 关闭菜单/弹窗时收拢的终点圆点从 28dp 缩小到 2dp。
- 修正中文全角字宽测量（2485 → 3480），避免文字溢出胶囊。

### `maple-mono.NFPropo-CN`

Unhinted TTF 变体，安装到 `$out/share/fonts/truetype` 下。
来自自定义字体构建。

## 许可证

每个包的许可证见其 `meta.license`：

- `bilibili-mpv` — GPL-3.0+
- `maple-mono.NFPropo-CN` — 见上游字体许可证

本仓库中的打包代码（Nix 表达式）在未另行声明的情况下采用
MIT 许可证。
