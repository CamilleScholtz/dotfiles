clock
-----

Spawns a super small URxvt window clock with a clock, I use FVWM to make the clock static, click through, etc.

Programs needed: URxvt, FVWM (optional, you can also user other WMs)

music
-----

Spawn a URxvt "button", I made the button clickable with FVWM. When clicking the button it spawns a mini window with information about the current playing song, a small progressbar, and album art (feh).

Programs needed: URxvt, mpd, mpc, feh, FVWM (optional)

notify
------

My very own "notification system", notify.sh spawn an URxvt window with the notification text. mpd_current sets the notification text to the current playing song, I execute this script with the "on_song_change" option from ncmpcpp. mpd_toggle.sh set the notification text to notify if the song is playing or paused, I execute this with FVWM.

Programs needed: URxvt, mpd, mpc, ncmpcpp, FVWM (optional, you can also user other WMs and use sxhkd or other hotkey programs

pager
-----

Spawns a button next to the FVWM pager, pretty much useless and only eye-candy.

Programs needed: URxvt, FVWM

todo
----

Heavy WIP, spawns a button with information about todo.txt
