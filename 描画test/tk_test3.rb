require 'tk'
require 'tkafter'

text = "DataPath."

canvaswidth = 200
textwidth = text.length * 8 + canvaswidth
limitaverage = Float(textwidth + canvaswidth) / Float(textwidth + canvaswidth * 2)
speed = TkVariable.new('25.0')
pos = 0.0

canvas = TkCanvas.new(nil,
	     'width' => canvaswidth,
	     'height' => 20,
		      'scrollregion' => "-#{canvaswidth} 0 #{textwidth} 20")
canvas.pack

txt = TkcText.new(canvas,
	    0,2,
	    'anchor' => 'nw',
	    'text' => text)

TkLabel.new(nil, 'text' => 'slow').pack('side' => 'left')
scale = TkScale.new(nil,
		    'showvalue' => 'false',
		    'from' => 100.0,
		    'to' => 1.0,
		    'width' => 8,
		    'length' => 120,
		    'orient' => 'horizontal',
		    'resolution' => 0.5,
		    'tickinterval' => 0,
		    'sliderlength' => 16,
		    'variable' => speed)
scale.pack('side' => 'left', 'fill' => 'x', 'expand' => 'yes')
TkLabel.new(nil, 'text' => 'fast').pack('side' => 'left')

TkAfter.new(2, -1,
	    proc{if pos > limitaverage then
		   pos = 0.0
		 else
		   pos += 0.01 / (speed.value).to_f  
		 end;
	      canvas.xview('moveto', pos)}).start
Tk.mainloop
