###
###   シミュレーション本体
###
#! ruby -Ks
require 'csv'
require './toilet_1.rb'
require 'pry'

DURATION = 540
frequency = 3
facilities_per_restroom_range = 1..30
use_duration = 1
population_size = 1000

data={}
facilities_per_restroom_range.step.each do |facilities_per_restroom|
	Person.population.clear
	population_size.times{Person.population << Person.new(frequency, use_duration)}
	data[facilities_per_restroom] = []
	restroom = Restroom.new facilities_per_restroom
#	binding.pry
	DURATION.times do |t|
		data[facilities_per_restroom] << restroom.queue.size
		queue = restroom.queue.clone
		restroom.queue.clear
		until queue.empty?
			restroom.enter queue.shift
		end
		Person.population.each do |person|
			if person.need_to_go?
				restroom.enter person
			end
		end
		restroom.tick
	end
end

CSV.open('./toilet_sim/Simulation2.csv','w') do |csv|
	lbl = []
	facilities_per_restroom_range.step.each {|facilities_per_restroom| lbl << facilities_per_restroom }
	csv << lbl
	DURATION.times do |t|
		row = []
		facilities_per_restroom_range.step.each do |facilities_per_restroom|
			row << data[facilities_per_restroom][t]
		end
		csv << row
	end
end

