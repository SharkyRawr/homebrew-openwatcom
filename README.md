# homebrew-openwatcom

A [Homebrew](https://brew.sh/) tap for installing [Open Watcom V2](https://github.com/open-watcom/open-watcom-v2) on macOS.

Open Watcom is a free, open-source C/C++ and Fortran compiler suite with tools for targeting DOS, Windows, OS/2, and Linux from a variety of host platforms.

## Prerequisites

- macOS (Apple Silicon or Intel)
- [Homebrew](https://brew.sh/)

## Installation

Tap this repository and install the formula:

```bash
brew tap sharkyrawr/openwatcom
brew install openwatcom-v2
```

The formula installs a pre-built snapshot release of Open Watcom V2 and provides a ready-to-use bottle for fast installation.

## Environment Setup

After installation, set up the Open Watcom environment by sourcing the provided shell script:

```bash
. $(brew --prefix openwatcom-v2)/bin/owenv.sh
```

To make this permanent, add the following line to your shell profile (`~/.zshrc`, `~/.bash_profile`, etc.):

```bash
. $(brew --prefix openwatcom-v2)/bin/owenv.sh
```

This script sets:

- `WATCOM` – path to the Open Watcom installation
- `PATH` – includes the native macOS host binaries (`armo64` on Apple Silicon, `bino64` on Intel)
- `INCLUDE` – path to the standard C/C++ headers
- `EDPATH` – path to the editor data files

## Available Tools

Once the environment is set up, you can use the Open Watcom toolchain:

| Tool | Description |
|------|-------------|
| `wcc` / `wcc386` | C compilers (16-bit and 32-bit) |
| `wpp` / `wpp386` | C++ compilers (16-bit and 32-bit) |
| `wasm` / `wasm386` | Assemblers |
| `wlink` | Linker |
| `wmake` | Make utility |
| `wcl` / `wcl386` | Compile and link front-ends |
| `vi` | Open Watcom vi editor (not symlinked to avoid conflicts) |

## Cross-Compilation

Open Watcom supports building for multiple target platforms regardless of your host OS. Target-specific headers and libraries are installed under:

- `$(brew --prefix openwatcom-v2)/h` – headers
- `$(brew --prefix openwatcom-v2)/lib286` – 16-bit libraries
- `$(brew --prefix openwatcom-v2)/lib386` – 32-bit libraries

Refer to the [Open Watcom documentation](https://open-watcom.github.io/) for detailed cross-compilation guidance.

## Quick Example

```bash
# Set up environment
. $(brew --prefix openwatcom-v2)/bin/owenv.sh

# Create a test program
cat > hello.c << 'EOF'
#include <stdio.h>
int main(void) {
    printf("Hello, Open Watcom!\n");
    return 0;
}
EOF

# Compile and link
wcl386 hello.c -fe=hello

# Run
./hello
```

## Updating

Update to the latest snapshot via Homebrew:

```bash
brew update
brew upgrade openwatcom-v2
```

## Uninstalling

```bash
brew uninstall openwatcom-v2
brew untap sharkyrawr/openwatcom
```

## Troubleshooting

### `brew install` fails with a 404

If you see a 404 error when trying to download a bottle, make sure your Homebrew installation is up to date:

```bash
brew update
```

If the issue persists, the bottle for your macOS version may still be building. You can install from source instead:

```bash
brew install --build-from-source sharkyrawr/openwatcom/openwatcom-v2
```

### Missing `vi` / `ctags` symlinks

To avoid conflicts with the system `vi` and common `ctags` formulae, these binaries are **not** symlinked into `$(brew --prefix)/bin`. You can still invoke them directly:

```bash
$(brew --prefix openwatcom-v2)/armo64/vi   # Apple Silicon
$(brew --prefix openwatcom-v2)/bino64/vi   # Intel
```

## Contributing

Pull requests are welcome. If you encounter issues with this Homebrew tap, please open an issue on [GitHub](https://github.com/SharkyRawr/homebrew-openwatcom).

## License

This tap's packaging scripts are provided under the same terms as the [Open Watcom license](https://raw.githubusercontent.com/open-watcom/open-watcom-v2/refs/heads/master/license.txt).

Open Watcom itself is licensed under the [Watcom-1.0](https://spdx.org/licenses/Watcom-1.0.html) license.
