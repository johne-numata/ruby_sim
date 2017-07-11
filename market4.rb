###
###  市場シミュレーションに関するシミュレーション用ベースクラス
###

class Producer
	attr_accessor :supply, :price
	
	def initialize
		@supply = {:chickens => 0, :ducks => 0}
		@price = {:chickens => 0, :ducks => 0}
	end
	
	def change_pricing
		@price.each{|type, price|
			if @supply[type] > 0
				@price[type] *= PRICE_DECREMENT unless price < COST[type]
			else
				@price[type] *= PRICE_INCREMENT unless price > PRICE_CONTROL[type]
			end
		}
	end
	
	def genarate_goods
		to_produce = Market.average_price(:chickens) > Market.average_price(:ducks) ? :chickens : :ducks
		@supply[to_produce] += SUPPLY_INCREMENT if @price[to_produce] > COST[to_produce]
	end
	
	def produce
		change_pricing
		genarate_goods
	end
end

class Consumer
	attr_accessor :demands
	
	def initialize
		@demands = 0
	end
	
	def buy(type)
		until @demands <= 0 or Market.supply(type) <= 0
			cheapest_producer = Market.cheapest_producer(type)
			
			if cheapest_producer
				@demands *= 0.5 if cheapest_producer.price[type] > MAX_ACCEPTABLE_PRICE[type]
				cheapest_supply = cheapest_producer.supply[type]
				
				if @demands > cheapest_supply
					@demands -= cheapest_supply
					cheapest_producer.supply[type] = 0
				else
					cheapest_producer.supply[type] -= @demands
					@demands = 0
				end
			end
		end
	end
end

class Market
	def self.average_price(type)
		($producers.inject(0.0){|memo, producer| memo + producer.price[type]} /
								$producers.size).round(2)
	end
	
	def self.supply(type)
		$producers.inject(0){|memo, producer| memo + producer.supply[type]}
	end
	
	def self.demands
		$consumers.inject(0){|memo, consumer| memo + consumer.demands}
	end
	
	def self.cheaper(a, b)
		cheapest_a_price = $producers.min_by{|f| f.price[a]}.price[a]
		cheapest_b_price = $producers.min_by{|f| f.price[b]}.price[b]
		cheapest_a_price < cheapest_b_price ? a : b
	end
	
	def self.cheapest_producer(type)
		producers = $producers.find_all{|producer| producer.supply[type] > 0}
		producers.min_by{|producer| producer.price[type]}
	end
end

def write(name, data)
	CSV.open("#{name}.csv", "w") do |csv|
		data.each{|row| csv << row }
	end
end
