minerup
=======

A Collection of Web Controllable Crypto Currency Mining Helper Scripts

by greyskies13

Choose which version you want to run, until I get to 0.3 which does the full feature set of both versions.

CURRENT Version - 0.2

A) with minerup you can remotely control which coin your miners are working on from the internet
   by updating a text file on a webserver with the name of the coin you want to mine

B) this feature is now broken - setup backup pools so minerup cycles through them when one goes down to keep you mining
   you can run the minerup 0.1 software which does cycle through backup pools, but only checks to switch coins when a 
   pool fails toreconnect
   
PREVIOUS Version - 0.1

A) cycles through mining pools when one goes down

B) you can control which coin is being mined from the internet
   by updating a text file on a webserver that you own with the name of the coin you want to mine
       but it won't switch until a pool goes down :(



expanding upon ideas from loopminer.sh by pooler https://gist.github.com/pooler/2053044
but written in ruby

feel free to modify and use this.  this is open source and for everyone in the mining community that has helped me in some way.


donations: btc 14p4DgLMiPkrssyqTDKaLyspKKp3g8DZj8 | doge D6MTLa1aMNHiuSv776FX28RezvhDVPHxFg 
           ltc LbyLm7ZNiyRy6FopqJZxC43RG9yhs2SVcK | ppc PGwMuKQzPinNDKTG8ikwR9FPFgapZHitvj
           frc 15XGfccyxFLqwpKSGDLZaTiThrxcLEpR43 | fst fyMzkrHXuJa925bbh8cCxX34aqFh88aqVy
           nmc NGvtF7Xm9nArTXrqDrF4tAr1bEsM8rKbU2 | dvc 1FQ7MUK9xKPvqXRc3vmGciwjTGmCeidjmm
           zet ZYiFWf5toJrWTsGZzbo4WtuLucUohUkTNM


to run this you will need curl, ruby (2.0 would be better than something lower), rubygems, and curb

- download this file and put it in /Applications
- edit the file to put in your pools and coins
- open up terminal and type these commands
- cd /Applications
- chmod u+x minerup.rb
- gem install curb
- ruby minerup.rb
