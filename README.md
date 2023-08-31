# homebrew-devsetup
A template for your own homebrew tap. Fork this repo (or copy it) and add your own formula to set up new devices how you want.

Works for WSL, Linux, and macOS.
## Install

You can copy and paste this whole thing into your terminal to install.

<!-- TODO: what about tapping private repos? -->

```bash
if ! command -v brew >/dev/null; then
    # brew is not installed
    # Install brew - Keep up to date with homepage script here: https://brew.sh/
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

    # If you're on linux, add the necessary parts
    ## sets up brew on the CLI for getting `brew --prefix` later
    test -d ~/.linuxbrew && eval "$(~/.linuxbrew/bin/brew shellenv)" 
    test -d /home/linuxbrew/.linuxbrew && eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

    # add for most common shells
    test -r ~/.bash_profile && echo "eval \"\$($(brew --prefix)/bin/brew shellenv)\"" >> ~/.bash_profile
    test -r ~/.zprofile     && echo "eval \"\$($(brew --prefix)/bin/brew shellenv)\"" >> ~/.zprofile
    test -r ~/.profile      && echo "eval \"\$($(brew --prefix)/bin/brew shellenv)\"" >> ~/.profile
fi
echo "Brew version: $(brew --version)"
brew tap nsheaps/devsetup
brew install nsheaps/devsetup/devsetup
```

## Getting Started With Your Own Tap

This tap is to serve as an example and template for new taps for your own personalized setup. The only thing it comes with a basic structure of a homebrew tap, some example formulas to demonstrate OS-agnostic installs of specific software, and a tool for keeping your own devsetup up to date for use in an organization. The real power of this comes in when you customize it.

Fork or copy this repo and add your own formula to set up new devices how you want. You can add your own formulas to the `Formula` directory, and they will be available to install with `devsetup install <formula>`.

**Don't forget to change the name of the repo in all of the documentation to match your repo. for `nsheaps/devsetup` and `nsheaps/homebrew-devsetup`**

**Note:** Don't forget, your repo name must start with `homebrew-`! See [this doc](https://docs.brew.sh/Taps#repository-naming-conventions-and-assumptions).

* [Maintaining your own homebrew tap](https://docs.brew.sh/Taps)
* [Distributing software from private repos with `GitHubPrivateRepositoryReleaseDownloadStrategy`](https://github.com/goreleaser/goreleaser/issues/507)([article](https://medium.com/prodopsio/creating-homebrew-taps-for-private-internal-tools-c41363d58ab0))

## The `devsetup` command

| command | description |
| --------- | ------------------- |
| `devsetup install`<br>`devsetup i` | installs the basic layer of software. Additional software can be available and upgraded from the tap, but the `install` command only installs the basic set. |
| `devsetup install <formula>`<br>`devsetup i <formula>` | installs a formula from this tap, an alias for `brew install nsheaps/devsetup/<formula>`. This is to avoid trying to pin this tap ([deprecated](https://github.com/Homebrew/brew/pull/5925)) when installing your locked versions of software |
| `devsetup update`<br>`devsetup u` | updates the local clone of this tap, then updates all software installed from it |
| `devsetup add <formula>`<br>`devsetup add <owner>/<tap>/<formula>` | makes a clone of the upstream formula in this tap to lock it's definition |
| `devsetup alias <formula> <alias>`<br>`devsetup remove <owner>/<tap>/<formula> <alias>` | creates a new formula that has the upstream formula as a direct dependency<br>**Note:**versioning ls less controllable here and updates only propagate when the created formula changes. |
| `devsetup doctor` | checks for common issues with the machine and produces a diagnostic report for the owner to help diagnose<br><b>Note:</b> The functionality of this command is provided by you |
| `devsetup help` | prints the help message |
| `devsetup version` | prints the version of the devsetup command |
| `devsetup tap-info [--prefix]` | alias for `brew tap-info nsheaps/devsetup`. `--prefix` just returns the location of the tap (alias for `$(brew --repository nsheaps/devsetup`) |
| `devsetup configure <topic> [--reconfigure]` | Alias for `brew update && brew install nsheaps/devsetup/devsetup-configure-<topic>`. If `--reconfigure` is passed, then the formula is removed first, which removes any configuration it set up prior. |

### `devsetup doctor`

Use this as a way to gather information about a user's machine to diagnose issues. The default functionality runs `brew config && brew doctor`

### `devsetup configure` topics

These are examples but some setup scripts come out of the box for you to customize and use. These boil down into additional devsetup formulas (like `devsetup-configure-git`).

When installed, the formula should check to see if conflicting configurations exist and warn accordingly.
Passing `--preserve` will make it non-interactive and assume that the configuration is correct and the formula will adopt it as it's own if possible. The configuration may not complete non-interactively if the configuration is not considered complete.

When upgraded, the formula should only configure new or additional things, and warn if it is going to change something that already exists (such as the default ssh key). This is an alias to installing with the `--preserve` flag.

When removed, the uninstall scripts should remove any configuration they had set up interactively. Passing `--preserve` will make it non-interactive and not remove any configuration.
Passing `--force` will remove the configuration without warning.

If you want any of these configurations to happen automatically on `devsetup install`, add the formula as a depdendency to the `devsetup` formula.

| topic | description |
| --------- | ------------------- |
| `git` | sets up git with a global user and email. |
| `github-token` | sets up a GITHUB_TOKEN and adds it to your profile |
| `github-ssh` | sets up github to prefer ssh via `git config --global url.ssh://git@github.com/.insteadOf https://github.com/` |
| `ssh` | sets up ssh with a key and config |
| `gpg` | sets up gpg with a key and config |
| `aws` | sets up aws with a profile and config |