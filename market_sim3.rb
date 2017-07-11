###
###   シミュレーション本体
###
#! ruby -Ks
require 'csv'
require './market2.rb'
require 'pry'

SIMULATION_DURATION = 150
NUM_OF_PRODUCERS = 10
NUM_OF_CONSUMERS = 10
MAX_STARTING_SUPPLY = Hash.new
MAX_STARTING_SUPPLY[:ducks] = 20
MAX_STARTING_SUPPLY[:chickens] = 20
SUPPLY_INCREMENT = 60
COST = Hash.new
COST[:chickens] = 12
COST[:ducks] = 12
MAX_ACCEPTABLE_PRICE = Hash.new
MAX_ACCEPTABLE_PRICE[:ducks] = COST[:ducks] * 10
MAX_ACCEPTABLE_PRICE[:chickens] = COST[:chickens] * 10
MAX_STARTING_PROFIT = Hash.new
MAX_STARTING_PROFIT[:ducks] = 15
MAX_STARTING_PROFIT[:chickens] = 15
PRICE_INCREMENT = 1.1
PRICE_DECREMENT = 0.9
PRICE_CONTROL = Hash.new
PRICE_CONTROL[:ducks] = 28
PRICE_CONTROL{:chickens] = 16

$producers = []
NUM_OF_PRODUCERS.times do
#	binding.pry
	producer = Producer.new
	producer.price[:chickens] = COST[:chickens] + rand(MAX_STARTING_PROFIT[:chickens])
	producer.price[:ducks] = COST[:ducks] + rand(MAX_STARTING_PROFIT[:ducks])
	producer.supply[:chickens] = rand(MAX_STARTING_SUPPLY[:chickens])
	producer.supply[:ducks] = rand(MAX_STARTING_SUPPLY[:ducks])
	$producers << producer
end

$consumers = []
NUM_OF_CONSUMERS.times do
	$consumers << Consumer.new
end

$generated_demand = []
SIMULATION_DURATION.times{|n| $generated_demand << ((Math.sin(n)+2)*20).round }

price_data = []
supply_data = []
SIMULATION_DURATION.times{|t|
	$consumers.each{|consumer| consumer.demands = $generated_demand[t] }
	supply_data << [t, Market.supply(:chickens), Market.supply(:ducks)]
	$producers.each{|producer| producer.produce }
	cheaper_type = Market.cheaper(:chickens, :ducks)
	until Market.demands == 0 or Market.supply(cheaper_type) == 0
		$consumers.each{|consumer| consumer.buy(cheaper_type) }
	end
	price_data << [t, Market.average_price(:chickens), Market.average_price(:ducks)]
}

write("./market_sim/price_data", price_data)
write("./market_sim/supply_data", supply_data)

