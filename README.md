scripts
=======

Various scripts I made, README.md is WIP.

apps/arya
---------
Emerge wrapper for Gentoo. Just a very simple bash script but it does the job. I wanted to copy the simple syntax of Arch's Pacman & Aura.

EDIT: Now with 100% more notification support!

apps/mpv
---------
Mpv wrapper, it automaticly launches mpv with youtube-dl if an url is found, otherwise it will just launch vanilla mpv.

apps/pomf
---------
My very own pomf.se screenshot upload script. With notification support.

clock
-----
Just a simple dzen2 clock, I position the clock with FVWM.

music
-----
Music button, on hover a popup appears with info about the song, artist & album, also shows album art with feh. Again these windows are placed with FVWM.

notify
------
My very own "notification system" using URxvt, currently displays mpd, scrot/pomf and rtorrent notifications. It's very easy to make notifications for other programs if you can get the info from the program (I get the MPD info from mpc and ncmpcpp, the rtorrent info from rtorrent, etc.).

pager
-----
This is not actually a pager, but just a button with an icon next to fvwmpager, pure eye-candy.

reminder
----
A window that show number of lines in your todo text file. Still very WIP.

