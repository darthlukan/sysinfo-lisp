# Sysinfo
> Author: Brian Tomlinson <briantomlinson at duck dot com>

## Description

`sysinfo` is a small program that displays simple status info to a bar application
such as `swaybar` or `i3bar`.

## Requirements

`sysinfo` is written in [Common Lisp](https://lisp-lang.org), specifically, using [SBCL](https://www.sbcl.org).
Any Common Lisp distribution should do, but only `sbcl` on [Debian](https://www.debian.org/) is referenced in
these instructions.

### Prerequisites

- `sbcl` or another Common Lisp distribution
- `jq` system package, used in querying local IP information
- `uiop` [package](https://asdf.common-lisp.dev/uiop.html), for OS interaction
- `asdf` [package](https://asdf.common-lisp.dev), for buildng the `sysinfo` package
- (optional) `quicklisp` [package](https://www.quicklisp.org/index.html), for installing `asdf` and `uiop`

### Installing the prerequisites

The following should work on `apt` based distributions. `sbcl` and `jq` are common enough packages that most 
package managers for major Linux distributions have them readily available.

Step 1: Clone this git repository to your target system, and then execute the following:

``` shell
$ sudo apt update && sudo apt install sbcl jq -y
$ curl -O https://beta.quicklisp.org/quicklisp.lisp
$ curl -O https://beta.quicklisp.org/quicklisp.lisp.asc
$ gpg --verify quicklisp.lisp.asc quicklisp.lisp
$ sbcl --load quicklisp.lisp
```

Step 2: Within the `sbcl` REPL you just started:

``` common-lisp
* (quicklisp-quickstart:install)
* (ql:quickload "asdf") ; Install asdf
* (ql:quickload "uiop") ; Install uiop
* (ql:add-to-init-file)
* (quit)
```

## Usage

`sysinfo` can be executed as a script, or as a compiled binary. Instructions for both methods
are described below.

### Compiling

A `Makefile` is provided to make things easier, just execute:

``` shell
$ make build
```

This will run your `sbcl` REPL, perform the compilation, and exit. The binary is named `sysinfo` and will
reside in the root of the repo.

You can then `mv` it to a directory in your `$PATH`, such as `~/bin`.

``` shell
$ mv sysinfo ~/bin/sysinfo
```

### Script

To use `sysinfo` as a script, simply `cp` it to some directory in your `$PATH` and ensure execute permissions
are set:

``` shell
$ cp ~/bin
$ chmod +x ~/bin/sysinfo.lisp
```

### Adding to your bar config

`sway` users using `swaybar` may use the following in their `~/.config/sway/config` in the `bar` settings area:

``` shell
... <SNIP>
# Compiled
status_command while /path/to/sysinfo; do sleep 15; done
# OR

# Script
status_command while sbcl --script /path/to/sysinfo.lisp; do sleep 15; done
... <SNIP>
```

Reload your Sway config or log out and back in and within `15` seconds you should see output such as the 
following in your bar:

``` shell
📦 <UPGRADEABLE_PACKAGES_INT> | 🖪 <DISK_AVAIL_INT>/<DISK_USED_INT> <DISK_USED_PERCENT> | 🖧 <SSID> | 🛈 <LOCAL_IPV4> | 🗓 Sun 27 Apr 2025 00:06:54 |

# Output from a real system
📦 0 | 🖪 939G/45G 6% | 🖧 coffee_n_memes | 🛈 <SNIP> | 🗓 Sun 27 Apr 2025 00:06:54 |
```

## Customization

`sysinfo` is set up to be specific to my Raspberry Pi 5 running Debian where I currently only require a 
wifi connection, and so, it looks only for `wlan0`. You can change this by updating the `command-strings`
alist entries for the `nmcli` and `ip` commands to use your desired interface.

The `apt-get` entry in `command-strings` will obviously not work on a non-APT-GET system. Replace this entry
with your package manager's equivalent "upgradeable" count command to see the packages available for upgrade.
Depending on your system setup, you may need to set a `cronjob` to update your repositories on some sensible
interval. An example cron that I use to run `apt update` every hour is provided here:

``` shell
# m h  dom mon dow   command
0 * * * * sudo apt update -q
```

More advanced customizations are possible. Learn Lisp ;)

## License
MIT, See LICENSE file.
