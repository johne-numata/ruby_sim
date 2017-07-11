###
###  市場シミュレーションに関するシミュレーション用ベースクラス
###

class Producer
	attr_accessor :supply, :price
	
	def initialize(facilities_per_restroom = 3)
		@supply = 0
		@price = 0
	end
	
	def genarate_goods
		@supply += SUPPLY_INCREMENT if @price > COST
	end
	
	def produce
		if @supply > 0
			@price *= PRICE_DECREMENT
		else
			@price *= PRICE_INCREMENT
			genarate_goods
		end
	end
end

class Consumer
	attr_accessor :demands
	
	def initialize
		@demands = 0
	end
	
	def buy
		until @demands <= 0 or Market.supply <= 0
			cheapest_producer = Market.cheapest_producer
			
			if cheapest_producer
				@demands *= 0.5 if cheapest_producer.price > MAX_ACCEPTABLE_PRICE
				cheapest_supply = cheapest_producer.supply
				
				if @demands > cheapest_supply
					@demands -= cheapest_supply
					cheapest_producer.supply = 0
				else
					cheapest_producer.supply -= @demands
					@demands = 0
				end
			end
		end
	end
end

class Market
	def self.average_price
		($producers.inject(0.0){|memo, producer| memo + producer.price} /
								$producers.size).round(2)
	end
	
	def self.supply
		$producers.inject(0){|memo, producer| memo + producer.supply}
	end
	
	def self.demands
		$consumers.inject(0){|memo, consumer| memo + consumer.demands}
	end
	
	def self.cheapest_producer
		producers = $producers.find_all{|f| f.supply > 0}
		producers.min_by{|f| f.price}
	end
end

def write(name, data)
	CSV.open("#{name}.csv", "w") do |csv|
		data.each{|row| csv << row }
	end
end
