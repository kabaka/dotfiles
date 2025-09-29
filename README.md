# Dotfiles

This repository is an archival snapshot of my personal dotfiles. It groups together the shell, editor, and tooling configuration that I carried across macOS machines for years. The goal here is not to provide a polished starter kit, but to document how I once set things up and to preserve those configurations for anyone who is curious.

## What's included (high level)

- **Shell environment:** login profiles, aliases, and prompt tweaks that shaped my interactive shell workflow.
- **Editor preferences:** settings and plugin references for Vim/Neovim, plus pointers to dedicated editor repos that contain the bulk of my configuration.
- **Tooling odds and ends:** helper scripts, small utilities, and configuration snippets for command-line tools I used regularly.

The dotfiles are arranged exactly as they lived in my home directory, so expect a mixture of macOS-focused choices with occasional Linux remnants from the distant past.

## Using these dotfiles

1. **Review before running anything.** This project reflects habits from another era, so make sure every file still makes sense for you.
2. **Install script (optional).** The `install.sh` script copies the contents of the repository into your home directory, backing up any conflicting files with a timestamped suffix. Run it from the repo root:
   ```bash
   ./install.sh
   ```
3. **Manual cherry-picking.** If you only need a few ideas, copy snippets or individual files instead of running the installer.

## Limitations and caveats

- **macOS bias:** Most of these configurations were maintained on macOS. Linux-specific tweaks have not been touched in nearly a decade and are likely broken or irrelevant on modern distributions.
- **Out-of-date tooling:** Package references and plugin managers reflect the ecosystem as it existed years ago. Expect hardcoded paths, deprecated plugins, and assumptions about Homebrew or other tooling that may no longer hold.
- **Install script caution:** `install.sh` is deliberately simple—it relies on `rsync`, performs minimal error handling, and assumes a Unix-like shell. Review the script before running it, especially if you are using Windows, WSL, or a recent Linux distribution.
- **No support or roadmap:** This repository is shared purely for fun and curiosity. I don't plan to accept contributions or update the setup beyond this historical snapshot.

## Related configuration

My Vim configuration lives in a separate repository that still houses the heavier editor setup: [kabaka/vimrc](https://github.com/kabaka/vimrc).

## License

These files were originally written for personal use. Use anything you find helpful, but do so at your own risk and responsibility.
