###
###   シミュレーション本体
###
#! ruby -Ks
require 'csv'
require './toilet_1.rb'
require 'pry'

DURATION = 540
max_frequency = 6
facilities_per_restroom = 12
max_use_duration = 2
population_range = 10..600
num_of_restroom = 1

#max_num_of_restroom.each{|num_of_restroom|
	data={}
	population_range.step(10).each do |population_size|
		Person.population.clear
		population_size.times{Person.population << 
			Person.new(rand(max_frequency)+1, rand(max_use_duration)+1) }
		data[population_size] = []
		restrooms = []
		num_of_restroom.times{restrooms << Restroom.new(facilities_per_restroom) }
#		binding.pry
		DURATION.times do |t|
			restroom_shortest_queue = restrooms.min{|n,m| n.queue.size <=> m.queue.size}
			data[population_size] << restroom_shortest_queue.queue.size
			
			restrooms.each{|restroom|
				queue = restroom.queue.clone
				restroom.queue.clear
				until queue.empty?
					restroom.enter queue.shift
				end
			}
			Person.population.each do |person|
				person.frequency = (t > 270 and t < 390) ? 12 : rand(max_frequency) + 1
				if person.need_to_go?
					restroom = restrooms.min{|a,b| a.queue.size <=> b.queue.size}
					restroom.enter person
				end
			end
			restrooms.each{|restroom| restroom.tick }
		end
	end

	CSV.open("./toilet_sim/Simulation3.csv",'w') do |csv|
		lbl = []
		population_range.step(10).each {|population_size| lbl << population_size }
		csv << lbl
		DURATION.times do |t|
			row = []
			population_range.step(10).each do |population_size|
				row << data[population_size][t]
			end
			csv << row
		end
	end
#}

