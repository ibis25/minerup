# minerup - a web controlled crypto currency mining script
# by greyskies13
#
# A) with minerup you can remotely control which coin your miners are working on from the internet
#    by updating a text file on a webserver with the name of the coin you want to mine

# B) this feature is now broken - setup backup pools so minerup cycles through them when one goes down to keep you mining
#
# expanding upon ideas from loopminer.sh by pooler https://gist.github.com/pooler/2053044
# but written in ruby
#
# feel free to modify and use this.  this is open source and for everyone in the mining community that has helped me in some way.
# 
#
# donations: btc 14p4DgLMiPkrssyqTDKaLyspKKp3g8DZj8 | doge D6MTLa1aMNHiuSv776FX28RezvhDVPHxFg 
#            ltc LbyLm7ZNiyRy6FopqJZxC43RG9yhs2SVcK | ppc PGwMuKQzPinNDKTG8ikwR9FPFgapZHitvj
#            frc 15XGfccyxFLqwpKSGDLZaTiThrxcLEpR43 | fst fyMzkrHXuJa925bbh8cCxX34aqFh88aqVy
#            nmc NGvtF7Xm9nArTXrqDrF4tAr1bEsM8rKbU2 | dvc 1FQ7MUK9xKPvqXRc3vmGciwjTGmCeidjmm
#            zet ZYiFWf5toJrWTsGZzbo4WtuLucUohUkTNM
#
# to run this you will need curl, ruby (2.0 would be better than something lower), rubygems, and curb
# download this file and put it in /Applications
# edit the file to put in your pools and coins
# open up terminal and type these commands
# cd /Applications
# chmod u+x minerup.rb
# gem install curb
# ruby minerup.rb


#
# BEFORE YOU RUN THIS SCRIPT
# edit the variables in below to setup your coins and pools with your miner's settings

# dependencies section **************************
require "rubygems"
require "curb"

# begin variables section **************************
# you most likely only need to edit things in the variables section
valid_coins = ["doge", "fst"]  #put one entry in this array for every coin that you want to be able to setup
coin_control_url = "http://yoururl.com/your_coin_file.txt" #make a text file on the web and enter the name of the coin you want it to mine
default_coin = "doge" # default coin to use if you dont get one from your page
current_coin = "" # this should also be set to blank, since we aren't mining anything to start
polling_seconds = 5 # number of seconds that the program waits between checks of the coin control url

# these arrays are the groups of mining pools that will be used 
# to add a new pool, initialize a hash and name the hash #{coin}_mine
# where you replace coin with the string from valid_coins, 
# note that my valid_coins are doge and fst, and i have two hashes, fst_mine and doge_mine
# in each hash enter one line per miner command that you want to loop through
# be sure to put in your mining pool statistics and information,
#  otherwise you will be mining for me, which you are free to do if you really want to

#fastcoin mining pools hash
fst_mine = {}
fst_mine["n0"] = "./minerd -o stratum+tcp://ca1.miningpool.co:9204 -u greyskies13.doge16 -px --retries=1 -t3"
fst_mine["n1"] = "./minerd -o stratum+tcp://de1.miningpool.co:9203 -u greyskies13.doge16 -px --retries=1 -t3"

#dogecoin mining pools hash
doge_mine = {}
doge_mine["n0"] = "./minerd -o stratum+tcp://miner.coinedup.com:3359 -u greyskies13.dogedoge98 -p 8u7w --retries=1 -t3"
doge_mine["n1"] = "./minerd -o stratum+tcp://pool.dogepool.net:4444 -u imbiat.dogedoge98 -p 8u7w --retries=1 -t3"
doge_mine["n2"] = "./minerd -o stratum+tcp://eu.stratum.coinpool.de:1005 -u imbiat.doge98 -p 8u7w --retries=1 -t3"
doge_mine["n3"] = "./minerd -o stratum+tcp://doge.netcodepool.org:4094 -u imbiat.dogedoge98 -p 8u7w --retries=1 -t3"

# some variables you prolly dont want to edit
i = 0 # initial array position to start at when picking the first pool to mine in
mine_command = ""


# main script begins here **************************


while true do
  puts "CURRENTLY MINING: #{current_coin}\n**************************CHECKING FOR COIN CHANGE"

  begin
    # get the coin you need to mine from 
    c = Curl::Easy.perform(coin_control_url)
    now_coin = c.body_str
  rescue
    now_coin = default_coin
    puts "COIN CONTROL URL NOT AVAILABLE --- ERROR ERROR ERROR --- mining default coin #{now_coin}"
  end
  # make sure that our control file is telling us to mine a valid coin
  (now_coin = default_coin) unless valid_coins.include?(now_coin)
  
  puts "SHOULD MINE: #{now_coin}"
  
  # coin just changed, we need to try to kill it
  if current_coin != now_coin && current_coin != ""
    puts "TRYING TO KILL CURRENT MINING PROCESS"
    `ps -ef|grep [m]inerd|grep -v grep|awk '{ print $2 }'|xargs kill -9`
  end

  if now_coin != current_coin
    
    i = 0
    # set the mine_ray to the array containing the mining commands for the coin we need to mine
    mine_ray = eval("#{now_coin}_mine")
    puts "STARTING TO MINE COIN: #{now_coin}"

    # select next mining command
    mine_command = "#{mine_ray["n#{i}"]}"

    # if we've incremented past the end of the array grab the first item
    if mine_command.nil?
      mine_command = mine_ray["n0"]
      i = 0
    end

    #execute mine command
    puts "TRYING POOL: #{mine_command}\n\n"
    `screen -S test2 -d -m #{mine_command}`

    current_coin = now_coin

  end  

  # increment the i position for selecting the mining command from the arrays
  i = i + 1
  sleep(polling_seconds) #let the cpu rest for a few seconds, remove this prolly like
end



