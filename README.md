# homebrew-devsetup
A template for your own homebrew tap. Fork this repo (or copy it) and add your own formula to set up new devices how you want.

Works for WSL, Linux, and macOS.

## Why not just use `brew` directly?

This creates a more focused interface for end users to set up their devices in a consistent manner, with short and concise documentation for referece rather than dealing with the brew docs each time. It also allows an abstract way to reference packages regardless of OS.

## Install

You can copy and paste this whole thing into your terminal to install.

<!-- TODO: what about tapping private repos? -->

```bash
# platform agnostic brew installer with shellenv installation
wget -O - https://raw.githubusercontent.com/nsheaps/homebrew-devsetup/HEAD/install_brew.sh | bash

# set up your environment
brew tap nsheaps/devsetup
brew install nsheaps/devsetup/devsetup
devsetup set-tap nsheaps/devsetup
devsetup install devsetup-base
```

## Maintenance

### Linting

`npx mega-linter-runner --flavor cupcake`
## Getting Started With Your Own Tap

This tap is to serve as an example and template for new taps for your own personalized setup. The only thing it comes with a basic structure of a homebrew tap, some example formulas to demonstrate OS-agnostic installs of specific software, and a tool for keeping your own devsetup up to date for use in an organization. The real power of this comes in when you customize it.

Fork or copy this repo and add your own formula to set up new devices how you want. You can add your own formulas to the `Formula` directory, and they will be available to install with `devsetup install <formula>`.

**Don't forget to change the name of the repo in all of the documentation to match your repo. for `nsheaps/devsetup`, `nsheaps/homebrew-devsetup` and `nsheaps/devsetup-bin` (the repo that contains the `devsetup` command if you want to make changes)**

**Note:** Don't forget, your repo name must start with `homebrew-`! See [this doc](https://docs.brew.sh/Taps#repository-naming-conventions-and-assumptions).

* [Maintaining your own homebrew tap](https://docs.brew.sh/Taps)
* [Distributing software from private repos with `GitHubPrivateRepositoryReleaseDownloadStrategy`](https://github.com/goreleaser/goreleaser/issues/507)([article](https://medium.com/prodopsio/creating-homebrew-taps-for-private-internal-tools-c41363d58ab0))
* [Formula Cookbook](https://docs.brew.sh/Formula-Cookbook)
* [`brew` manpage](https://docs.brew.sh/Manpage)
* [`brew` sourcecode](https://github.com/Homebrew/brew/)

## The `devsetup` command

Uses `$HOME/.config/devsetup/` for any needed configuration files.

| command                                                | description                                                                                                                                                                                                                                      |
|--------------------------------------------------------|--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| `devsetup set-tap <tap>`                               | sets the tap to use for installing software. This is the tap that will be used when running `devsetup install <formula>`.                                                                                                                        |
| `devsetup get-tap`                                     | prints the current tap. eg `nsheaps/devsetup`                                                                                                                                                                                                    |
| `devsetup install <formula>`<br>`devsetup i <formula>` | installs a formula from this tap, an alias for `brew install $(devsetup get-tap)/<formula>`. This is to avoid trying to pin this tap ([deprecated](https://github.com/Homebrew/brew/pull/5925)) when installing your locked versions of software |
| `devsetup upgrade-all` | updates the local clone of this tap (`devsetup update`), then upgrades all software installed from it (list, filter by `$(devsetup get-tap)/.*, run`brew upgrade <formula..>`)|
| `devsetup upgrade <formula>`<br>`devsetup u <formula>` | alias for `brew upgrade $(devsetup get-tap)/<formula>`, always upgrades `devsetup` even if from another tap. |
| `devsetup update` | Alias for `$(cd $(brew --repository $(devsetup get-tap)) && git pull)`. This is to avoid updating other taps. |
| `devsetup outdated` | Alias for `brew outdated $(devsetup get-tap)/.*` |
| `devsetup list` | Lists all kegs/packages installed from the tapped homebrew tap |
| `devsetup info <formula>` | Gets the info for a formula |
| `devsetup search <str>` | Searches for a formula |
| `devsetup add <formula>`<br>`devsetup add <owner>/<tap>/<formula>` | makes a clone of the upstream formula in this tap to lock it's definition |
| `devsetup alias <formula> <alias>`<br>`devsetup remove <owner>/<tap>/<formula> <alias>` | creates a new formula that has the upstream formula as a direct dependency<br>**Note:**versioning ls less controllable here and updates **only** propagate when the created formula changes. |
| `devsetup doctor` | checks for common issues with the machine and produces a diagnostic report for the owner to help diagnose<br><b>Note:</b> The functionality of this command is provided by you |
| `devsetup help` | prints the help message |
| `devsetup version` | prints the version of the devsetup command |
| `devsetup tap-info [--prefix]` | alias for `brew tap-info $(devsetup get-tap)`. `--prefix` just returns the location of the tap (alias for `$(brew --repository $(devsetup get-tap)`) |
| `devsetup configure <topic> [--reconfigure]` | Alias for `brew update && brew install $(devsetup get-tap)/devsetup-configure-<topic>`. If `--reconfigure` is passed, then the formula is removed first, which removes any configuration it set up prior. |

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

| topic          | description                                                                                                                                                                                                                                                       |
|----------------|-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| `git`          | sets up git with a global user and email. Also globally sets `pull.rebase` to false (merge when diverge)                                                                                                                                                          |
| `github-token` | sets up a GITHUB_TOKEN and adds it to your `~/.profile`                                                                                                                                                                                                           |
| `github-ssh`   | sets up github to prefer ssh via `git config --global url.ssh://git@github.com/.insteadOf https://github.com/`, and then runs `gh ssh-key add $(devsetup-configure-ssh --keyfile)`.<br><b>Note:</b> depends on `gh` and `nsheaps/devsetup/devsetup-configure-ssh` |
| `ssh`          | sets up ssh with a key and config. Also provides a `--keyfile [keytype]` to return the location of the requested keyfile                                                                                                                                          |
| `gpg`          | sets up gpg with a key and config                                                                                                                                                                                                                                 |
| `aws`          | sets up aws with a profile and config                                                                                                                                                                                                                             |

## Tracking Upstream Formulas with Renovate

This repository uses Renovate to automatically track and update formulas against their upstream versions. This is particularly useful for Python formulas that need to stay in sync with the official Homebrew versions.

### How to Create a Formula that Tracks Upstream

To create a formula that tracks an upstream formula (like Python), follow this template:

```ruby
# renovate: datasource=custom.ghfile registryUrl=Homebrew/homebrew-core depName=Formula/p/python@3.12.rb currentDigest=master
class PythonAT312 < formula
  desc 'Installs Python 3.12.x'
  homepage 'http://github.com/nsheaps/homebrew-devsetup'
  url 'https://github.com/nsheaps/brew-meta-formula/archive/refs/tags/v1.0.0.tar.gz'
  sha256 "b14702dd54ea5c48d2ebeb6425015c14794159a6b9d342178c81d2f2e79ed2db"
  version '1.0.0'

  livecheck do
    skip "Meta formulas cannot be updated"
  end

  depends_on "https://raw.githubusercontent.com/Homebrew/homebrew-core/master/Formula/p/python@3.12.rb"

  def install
    system "touch", "trick-brew-to-install-meta-formula"
    prefix.install "trick-brew-to-install-meta-formula"
  end
end
```

The key components are:

1. The comment at the top of the file with the Renovate configuration:
   ```ruby
   # renovate: datasource=custom.ghfile registryUrl=Homebrew/homebrew-core depName=Formula/p/python@3.12.rb currentDigest=master
   ```

2. The `depends_on` line that references the raw GitHub URL of the upstream formula:
   ```ruby
   depends_on "https://raw.githubusercontent.com/Homebrew/homebrew-core/master/Formula/p/python@3.12.rb"
   ```

When Renovate runs, it will:
1. Check for updates to the upstream formula
2. Update the SHA in the `depends_on` line to point to the latest version
3. Create a pull request with the changes

### How It Works

The Renovate configuration in `renovate.json` uses a custom manager and datasource to:
1. Match formula files with the special comment format
2. Check the GitHub API for updates to the referenced file
3. Update the SHA in the `depends_on` line when changes are detected

## TODO

* [ ] Test `brew list` and see if it dumps list prefixed with installed tap (no tap is `homebrew/core`)
* [ ] Test creating an alias via [`livecheck`](https://docs.brew.sh/Brew-Livecheck#referenced-formulacask) and see if it works
  * It should, since normally it's looking at the local tap, `livecheck` should check upstream if there are updates.
* [ ] Figure out a way to pass flags for devsetup-configure scripts
* [ ] Figure out a way to reference dependencies via env var for referencing the tap rather than fully qualified
