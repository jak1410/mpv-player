```
                                  _                       
   _ __ ___  _ ____   __     _ __ | | __ _ _   _  ___ _ __ 
  | '_ ` _ \| '_ \ \ / /____| '_ \| |/ _` | | | |/ _ \ '__|
  | | | | | | |_) \ V /_____| |_) | | (_| | |_| |  __/ |   
  |_| |_| |_| .__/ \_/      | .__/|_|\__,_|\__, |\___|_|   
            |_|             |_|            |___/           
```

mpv-player is a music player that uses mpv quitely in the background. You interact with it using a socket, and you can also print it's satus to text (ready for a dwm status bar)

WARNING:
this code is not very good. I made this quickly just for my own personal use. Because it is just for me, there are many hard coded paths.

If you actually intend to use this you will need to go through and change the hard coded paths to what you will use. You also need to change the dmenu flags as mine are based on a couple patches for dmenu, specificaly centered and border (there's probably more that I'm forgeting)

Last.fm support is very loose but technically functional. You will need to generate a new token and session key using the provided scripts. After you can use them to have the mpv-listener script keep track of what you are listening to.

keep in mind that my lastfm scripts are built with my file structure for music in mind

~/Music/Artist/Album/Song

so if you do something different you will need to rework the script.

