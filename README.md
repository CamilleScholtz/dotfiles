scripts
=======

Various scripts I made, README.md is WIP. Check out https://github.com/lainscerealexpe/scripts for more widgets.

apps/arya
---------
Emerge wrapper for Gentoo. Just a very simple bash script but it does the job. I wanted to copy the simple syntax of Arch's Pacman & Aura.

EDIT: Now with 100% more notification support!

apps/mpv
---------
Mpv wrapper, it automaticly launches mpv with youtube-dl if an url is found, otherwise it will just launch vanilla mpv.

apps/neet
---------
My NEET cli app, it tracks my escapism and stuff. SUPER WIP

apps/pomf
---------
My very own pomf.se screenshot upload script. With notification support.

apps/rmscrot
---------
Removes all images (scrots) in $HOME

clock
-----
Just a simple dzen2 clock, I position the clock with MVWM.

music
-----
Music button, on hover a popup appears with info about the song, artist & album, also shows album art with feh. Again these windows are placed with MVWM.

neet
----
A button that shows my current watching series/animu with episode count.

notify
------
My very own "notification system" using URxvt and some scripts, currently displays notfications for:

* mpd (toggling pause/play, and song changes)
* scrot (both for screen shots and window shots)
* pomf (also displays the url)
* rtorrent (When a torrent finishes downloading)
* transmission (^)
* arya/emerge (when finishing (un)installing programs, and updating @world)

It's very easy to make notifications for other programs if you can get the info from the program (I get the mpd info from mpc and ncmpcpp, the rtorrent info from rtorrent, etc.).

pager
-----
This is not actually a pager, but just a button with an icon next to fvwmpager, pure eye-candy.
