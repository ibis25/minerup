# minerup v0.1 - a web controlled crypto currency mining script
# by greyskies13
#
# A) you can control which coin is being mined from the internet
#      by updating a text file on a webserver that you own with the name of the coin you want to mine
#        but it won't switch until a pool goes down :(
# B) cycles through mining pools when one goes down
#
# expanding upon ideas from loopminer.sh by pooler https://gist.github.com/pooler/2053044
# but written in ruby
#
# feel free to modify and use this.  this is open source and for everyone in the mining community that has helped me in some way.
#
# donations: btc 14p4DgLMiPkrssyqTDKaLyspKKp3g8DZj8 | doge D6MTLa1aMNHiuSv776FX28RezvhDVPHxFg 
#            ltc  | fst fyMzkrHXuJa925bbh8cCxX34aqFh88aqVy
#            nmc NGvtF7Xm9nArTXrqDrF4tAr1bEsM8rKbU2 | dvc 1FQ7MUK9xKPvqXRc3vmGciwjTGmCeidjmm
#
# to run this you will need curl, ruby (2.0 would be better than something lower), rubygems, and curb
# download this file and put it in /Applications
# edit the file to put in your pools and coins
# open up terminal and type these commands
# cd /Applications
# chmod u+x minerup-0.1.rb
# gem install curb
# ruby minerup-0.1.rb


#
# BEFORE YOU RUN THIS SCRIPT
# edit the variables in below to setup your coins and pools with your miner's settings

# dependencies section **************************
require "rubygems"
require "curb"

# begin variables section **************************
# you most likely only need to edit things in the variables section
valid_coins = ["doge", "fst"]  #put one entry in this array for every coin that you want to be able to setup
coin_control_url = "http://your_url.com/your_coin_file.txt" #make a txt file on the web and enter the name of the coin you want it to mine
                                                      #the word in the file should be one of the entries in the valid coin array
retries = "--retries=1" # number of times to retry a pool after it disconnects
default_coin = "doge" # default coin to use if you dont get one from your page
index_position = 0 # initial array position to start at when picking the first pool to mine in

# these arrays are the groups of mining pools that will be used 
# to add a new pool, name the array #{coin}_mine
# where you replace coin with the string from valid_coins
# and make one line per miner command that you want to loop through
# be sure to put in your mining pool statistics

#fastcoin mining pools
fst_mine = {}
fst_mine["n0"] = "./minerd #{retries} -o stratum+tcp://ca1.miningpool.co:9204 -u greyskies13.doge16 -px"
fst_mine["n1"] = "./minerd #{retries} -o stratum+tcp://de1.miningpool.co:9203 -u greyskies13.doge16 -px"

#dogecoin mining pools
doge_mine = {}
doge_mine["n0"] = "./minerd #{retries} -o stratum+tcp://miner.coinedup.com:3359 -u greyskies13.dogedoge98 -p 8u7w"
doge_mine["n1"] = "./minerd #{retries} -o stratum+tcp://pool.dogepool.net:4444 -u imbiat.dogedoge98 -p 8u7w"
doge_mine["n2"] = "./minerd #{retries} -o stratum+tcp://miner.coinedup.com:3359 -u greyskies13.dogedoge98 -p 8u7w"
doge_mine["n3"] = "./minerd #{retries} -o stratum+tcp://doge.netcodepool.org:4094 -u imbiat.dogedoge98 -p 8u7w"

# main script begins here **************************
while true do
  puts "\n\n**************************\n\nGETTING NEXT POOL"
  
  # get the coin you need to mine from 
  c = Curl::Easy.perform(coin_control_url)
  now_coin = c.body_str
  
  # make sure that our control file is telling us to mine a valid coin
  (now_coin = default_coin) unless valid_coins.include?(now_coin)
  
  # set the mine_ray to the array containing the mining commands for the coin we need to mine
  mine_ray = eval("#{now_coin}_mine")
  puts "MINING COIN: #{now_coin}"
  
  # select mining command
  mine_command = mine_ray["n#{index_position}"]
  
  # if we've incremented past the end of the array grab the first item
  if mine_command.nil?
    mine_command = mine_ray["n0"]
    index_position = 0
  end
    
  #execute mine command
  puts "STARTING POOL: #{mine_command}\n\n"
  %x(#{mine_command})
  sleep(5) #let the cpu rest for a few seconds
  
  # increment the index position for selecting the mining command from the arrays
  index_position = index_position + 1
end