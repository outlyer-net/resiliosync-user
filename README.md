# Resilio Sync per-user launcher

This is a small script to run [Resilio Sync][resilio] (formerly Bittorrent Sync) as an unprivileged user using initscript-like syntax.

Hint: Add `btsync.user start` to the list of programs to run on login (and `btsync.user stop` to the list of programs to run on logout if your <acronym title="Desktop Environment">DE</acronym> supports it to have Resilio Sync running while you're logged in). 

**NOTE**: For historic reasons the script is called `btsync.user`, if installed through the makefile an additional `rslsync.user` symbolic link will be created.

**NOTE**: The `/sbin/start-stop-daemon` script and the `jq` program are required to run this script. Additionally `xdg-open` is used to launch a browser if the `webui` parameter is passed.


## Usage

```shell
$ btsync.user start
```

Starts the Resilio Sync client in the background.

If no configuration is present, creation is handled by Resilio Sync itself.

The script uses `~/.config/resilio-sync` as configuration directory.

```shell
$ btsync.user stop
```

Stops a running instance.

```shell
$ btsync.user status
```

Displays running status, including the HTTP address of the Web UI.

```shell
$ btsync.user webui
```

Opens the Web UI on the default browser (using `xdg-open`).
\
Alternatively you may use [the companion `btsync.gui` script](#btsyncgui) to load the Web UI in Chromium's app mode.

## Example output

```shell
$ btsync.user start
Starting /usr/bin/rslsync...
By using this application, you agree to our Privacy Policy, Terms of Use and End User License Agreement.
https://www.resilio.com/legal/privacy
https://www.resilio.com/legal/terms-of-use
https://www.resilio.com/legal/eula

Resilio Sync forked to background. pid = 12345
```

```shell
$ btsync.user stop
Stopped /usr/bin/rslsync (pid 12345).
```

```shell
$ btsync.user status
Resilio Sync running with pid 25308
    Web UI listening on https://127.0.0.1:7777 0.0.0.0:7777
```

## Per-user configuration

Resilio Sync includes a script to generate per-user configuration, usually at `/etc/resilio-sync/init_user_config.sh`.

It can be used to e.g. adjust the Web UI port.

When run without an existing configuration the aforementioned script will be invoked.

# btsync.gui

Also included here is the _`btsync.gui.bash`_ script which will try to open
the WebUI in a browser in app mode.

Unlike `btsync.user webui`, which uses `xdg-open` to launch the user's default browser,
`btsync.gui` will try to use one of the known derivatives of Chromium (currently
Chromium, Google Chrome and Microsoft Edge), since those have an _app mode_.

As with `btsync.user`, if installing with the makefile, a corresponding `rslsync.gui` will
be installed too.

<!-- links -->

[resilio]: https://www.resilio.com
