require 'tk'
require 'matrix'
=begin
class Roid
	attr_reader :velocity, :position

	def initialize(p, v)
		@velocity = v
		@position = p
	end
	
	def draw
		@slot.oval(left:@position[0], top:@position[1], radius:ROID_SIZE, enter:true)
		@slot.line(@position[0], @position[1], @positon[0] - @velocity[0], @position[1] - @velocity[1])
	end
	
	def move
		@delta = Vector[0,0]
		%w(separate align cohere muffle).each{|action| self.send action}
		@velocity += @delta
		@position += @velocity
		draw
	end
end

$roids = []
10.times{
	random_location = Vector[rand(100), rand(100)]
	random_velocity = Vector[rand(11) - 5, rand(11) - 5]
	$roids << Roid.new(random_location, random_velocity)
}
=end
canvas = TkCanvas.new(width: 400, height: 400){|c|
	$o = TkcOval.new(c, 200, 200, 300, 300)
}.pack
#$o = TkcOval.new(canvas, 200, 200, 300, 300)
#sleep(1)
#o.move(50,50)
#TkAfter.new(1, -1, o.move(10, 10)).start
def timer
  TkAfter.new(1000, -1, $o.move(50, 80))
end
timer.start # start timer

Tk.mainloop
