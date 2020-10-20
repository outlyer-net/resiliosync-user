# resiliosync-user
Small script to run Resilio Sync (formerly Bittorrent Sync) as an unprivileged user using initscript-like syntax.

Hint: Add `btsync.user start` to the list of programs to run on login (and `btsync.user stop` to the list of programs to run on logout if your DE supports it to have Resilio Sync running while you're logged in). 

**NOTE**: For historic reasons the script is called `btsync.user`, if installed through the makefile an additional `rslsync.user` symbolic link will be created.

**NOTE**: The `/sbin/start-stop-daemon` script is required to run this script.


## Usage

`$ btsync.user start`

Starts the Resilio Sync client in the background.

If no configuration is present, creation is handled by Resilio Sync itself.

The script uses `~/.config/resilio-sync` as configuration directory.

`$ btsync.user stop`

Stops a running instance.

`$ btsync.user status`

Displays running status, including the HTTP address of the Web UI.

## Example output

`$ btsync.user start`

    Starting /usr/bin/rslsync...
    By using this application, you agree to our Privacy Policy, Terms of Use and End User License Agreement.
    https://www.resilio.com/legal/privacy
    https://www.resilio.com/legal/terms-of-use
    https://www.resilio.com/legal/eula
    
    Resilio Sync forked to background. pid = 12345

`$ btsync.user stop`

    Stopped /usr/bin/rslsync (pid 12345).

`$ btsync.user status`

    Resilio Sync running with pid 25308
       Web UI listening on https://127.0.0.1:7777 0.0.0.0:7777

## Per-user configuration

Resilio Sync includes a script to generate per-user configuration, usually at `/etc/resilio-sync/init_user_config.sh`.

It can be used to e.g. adjust the Web UI port.

When run without an existing configuration the aforementioned script will be invoked.

