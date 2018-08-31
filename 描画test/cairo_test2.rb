require 'cairo'

BD = 20; PA = 30; WD = 50; BW = 40
Window = BD * 2 + PA * 2 + WD * 4 + BW * 3

Surface = Cairo::ImageSurface.new(Cairo::FORMAT_ARGB32, Window, Window)
C = Cairo::Context.new(Surface)

C.set_source_color(Cairo::Color.parse("#d3d3d3"))
C.rectangle(0, 0, Window, Window)
C.fill
C.set_source_color(Cairo::Color.parse("#e0ffff"))
C.rectangle(BD, BD, Window - BD * 2, Window - BD * 2)
C.fill

class Rectangle
  def initialize(x, y)
    @x = x; @y = y
  end
  
  def draw
    C.set_source_rgb(rand, rand, rand)
    C.rectangle(@x, @y, WD, WD)
    C.fill
  end
end

rc = []
for y in 0..3
  for x in 0..3
    rc << Rectangle.new(BD + PA + x * (BW + WD), BD + PA + y * (BW + WD))
  end
end

rc.each {|a| a.draw}

100.times do |i|
  3.times { rc[rand(16)].draw }
  Surface.write_to_png("%04d.png" % i)
end
