#http://pubapi.cryptsy.com/api.php?method=singlemarketdata&marketid={MARKET ID} 
#MARKET IDS
#
# ANC
# DOGE
# HBN
# LTC 3
# POT
# UNO

require 'rubygems'
require 'curb'
require 'json'

values = {}

markets = {
  "ANC" => "66",
  "DOGE" => "132",
  "LTC" => "3",
  "POT" => "173",
  "HBN" => "80",
  "UNO" => "133",
  "FST" => "44",
  "FTC" => "5",
  "MEOW" => "149",
  "NYAN" => "184"
}


http = Curl.get("https://www.bitstamp.net/api/ticker/")
json_data = JSON.parse(http.body_str)
last_value = json_data["last"]  

puts "BTC #{last_value}"

http = Curl.get("http://pubapi.cryptsy.com/api.php?method=marketdatav2")
json_data = JSON.parse(http.body_str)
markets.each_pair do |coin, market_id|
  last_value = json_data["return"]["markets"]["#{coin}/BTC"]["lasttradeprice"]  
  values.merge!({"#{coin}" => "#{last_value}"})
  puts "#{coin} #{last_value}"
end
puts values.inspect
