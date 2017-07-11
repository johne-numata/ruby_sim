###
###   シミュレーション本体
###
#! ruby -Ks
require 'csv'
require './market.rb'
require 'pry'

COST = 5
NUM_OF_PRODUCERS = 10
MAX_STARTING_PROFIT = 5
MAX_STARTING_SUPPLY = 20
NUM_OF_CONSUMERS = 10
SIMULATION_DURATION = 150
SUPPLY_INCREMENT = 80
MAX_ACCEPTABLE_PRICE = COST * 10
PRICE_INCREMENT = 1.1
PRICE_DECREMENT = 0.9

def initialize_data(additional_consumer_num)
	$producers = []
	NUM_OF_PRODUCERS.times do
#	binding.pry
		producer = Producer.new
		producer.price = COST + rand(MAX_STARTING_PROFIT)
		producer.supply = rand(MAX_STARTING_SUPPLY)
		$producers << producer
	end

	$consumers = []
	(NUM_OF_CONSUMERS + additional_consumer_num).times do
		$consumers << Consumer.new
	end

	$generated_demand = []
	SIMULATION_DURATION.times{|n| $generated_demand << ((Math.sin(n)+2)*20).round }

	$demand_supply = []
	$price_demand = []
end

def execute_simulation(additional_consumer_count)
	initialize_data(additional_consumer_count)

	SIMULATION_DURATION.times{|t|
		$consumers.each{|consumer| consumer.demands = $generated_demand[t] }
		$demand_supply << [t, Market.demands, Market.supply]
		$producers.each{|producer| producer.produce }
		$price_demand << [t, Market.average_price, Market.demands]
		until Market.demands == 0 or Market.supply == 0
			$consumers.each{|consumer| consumer.buy }
		end
#	
#		if t == SIMULATION_DURATION - 1
#			sample_prices = []
#			$producers.each{|producer| sample_prices << [producer.price] }
#			write("sample_prices", sample_prices)
#		end
	}

	write("./market_sim/demand_supply" + additional_consumer_count.to_s, $demand_supply)
	write("./market_sim/price_demand" + additional_consumer_count.to_s, $price_demand)
end

MAX_CONSUMERS = 20
(MAX_CONSUMERS - NUM_OF_CONSUMERS).times{|i| execute_simulation(i) }
