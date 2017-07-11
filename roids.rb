#! ruby -Ks
require 'matrix'

FPS = 20
ROID_SIZE = 6
WORLD = {:xmax => ROID_SIZE * 100, :ymax => ROID_SIZE * 100}
POPULATION_SIZE = 30
OBSTACLE_SIZE = 30

SEPARATION_RADIUS = ROID_SIZE * 3.5 # steer to avoid crowding of flockmates
ALIGNMENT_RADIUS = ROID_SIZE * 15 # steer towards average heading of flockmates
COHESION_RADIUS = ROID_SIZE * 15 # steer to move toward average position of flockmates

SEPARATION_ADJUSTMENT = 10
ALIGNMENT_ADJUSTMENT = 8
COHESION_ADJUSTMENT = 100
MAX_ROID_SPEED = 20

class Roid
	attr_reader :velocity, :position

	def initialize(slot, p, v)
		@velocity = v
		@position = p
		@slot = slot
	end

	def distance_from(roid)
		distance_from_point(roid.position)
	end

	def distance_from_point(vector)
		x = @position[0] - vector[0]
		y = @position[1] - vector[1]
		Math.sqrt(x*x + y*y)
	end
	
	def nearby?(threshold, roid)
		return false  if roid === self
		distance_from(roid) < threshold and within_fov?(roid)
	end
	
	def within_fov?(roid)
		v1 = @velocity
		v2 = roid.position - @position
		cos_angle = v1.inner_product(v2)/(v1.r * v2.r)
		Math.acos(cos_angle) < 0.75 * Math::PI
	end
	
	def draw
		@slot.oval(:left => @position[0], :top => @position[1], :radius => ROID_SIZE, :center => true)
		@slot.line(@position[0], @position[1], @position[0] - @velocity[0], @position[1] - @velocity[1])
	end
	
	def move
		@delta = Vector[0.0,0.0]
#		%w(separate align cohere muffle avoid).each{|action| self.send action}
		%w(separate align cohere muffle).each{|action| self.send action}
		@velocity += @delta
		@position += @velocity
		fallthrough
		draw
	end
	
	def separate
		distance = Vector[0,0]
		$roids.each{|roid|
			distance += @position - roid.position if nearby?(SEPARATION_RADIUS, roid)
		}
		@delta += distance / SEPARATION_ADJUSTMENT
	end

	def align
		nearby, average_velocity = 0, Vector[0,0]
		$roids.each{|roid|
			if nearby?(ALIGNMENT_RADIUS, roid)
				average_velocity += roid.velocity
				nearby += 1
			end
		}
		average_velocity /= nearby  if nearby != 0
		@delta += (average_velocity - @velocity) / ALIGNMENT_ADJUSTMENT
	end
	
	def cohere
		nearby, average_position = 0, Vector[0,0]
		$roids.each{|roid|
			if nearby?(COHESION_RADIUS, roid)
				average_position += roid.position
				nearby += 1
			end
		}
		average_position /= nearby  if nearby != 0
		@delta += (average_position - self.position) / COHESION_ADJUSTMENT
	end
	
	def muffle
		if @velocity.r > MAX_ROID_SPEED
			@velocity /= @velocity.r
			@velocity *= MAX_ROID_SPEED
		end
	end
	
	def fallthrough
		x = case
			when @position[0] < 0 			 then WORLD[:xmax] + @position[0]
			when @position[0] > WORLD[:xmax] then WORLD[:xmax] - @position[0]
			else @position[0]
		end
		y = case
			when @position[1] < 0			 then WORLD[:ymax] + @position[1]
			when @position[1] > WORLD[:ymax] then WORLD[:ymax] - @position[1]
			else @position[1]
		end
		@position = Vector[x,y]
	end
	
	def avoid  
      	$obstacles.each do |obstacle|
      		if distance_from_point(obstacle) < (OBSTACLE_SIZE + ROID_SIZE*2)
        		@delta += (self.position - obstacle)
      		end
    	end
  	end
end

Shoes.app(:title => 'Roids', :width => WORLD[:xmax], :height => WORLD[:ymax]) do
	stroke blue #slategray
	fill red #gainsboro
	$roids = []
	POPULATION_SIZE.times{
		random_location = Vector[rand(WORLD[:xmax]), rand(WORLD[:ymax])]
		random_velocity = Vector[rand(11) - 5, rand(11) - 5]
		$roids << Roid.new(self, random_location, random_velocity)
	}
	animate(FPS){
		clear{
			background ghostwhite
			$roids.each{|roid| roid.move}
		}
	}
end
