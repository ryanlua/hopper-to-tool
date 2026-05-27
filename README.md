# Hopper to Tool

[![Get it on Creator Store](https://raw.githubusercontent.com/gist/ryanlua/fd42012f04cc39106fb57402dd518433/raw/link-creator-store.svg)](https://create.roblox.com/store/asset/127755570108720)
[![GitHub](https://raw.githubusercontent.com/gist/ryanlua/fd42012f04cc39106fb57402dd518433/raw/link-github-compact.svg)](https://github.com/ryanlua/hopper-to-tool/releases)
[![Discord](https://raw.githubusercontent.com/gist/ryanlua/fd42012f04cc39106fb57402dd518433/raw/link-discord-compact.svg)](https://discord.gg/N2KEnHzrsW)

Roblox Studio plugin to help migrate from deprecated [HopperBin](https://create.roblox.com/docs/reference/engine/classes/HopperBin) instances to Tool by converting classes and scripts.

* Replace [`HopperBin`](https://create.roblox.com/docs/reference/engine/classes/HopperBin) instances with [`Tool`](https://create.roblox.com/docs/reference/engine/classes/Tool#Unequipped)
* Convert scripts using HopperBin class methods
  * `HopperBin.Selected` → `Tool.Equipped`
  * `HopperBin.Deselected` → `Tool.Unequipped`

Supports undo and redo. Converted instances are selected after conversion. Works to convert HopperBin instances relying internal scripts.

## Usage

1. Install the Roblox Studio plugin
2. Select HopperBin instances to convert
3. Activate the plugin by pressing it's button

## License

Hopper to Tool is available under the Apache 2.0 license. See [LICENSE.md](LICENSE.md) for details.
