require 'tk'

e = TkEntry.new { relief 'sunken' }.pack('fill' => 'x')

r = 0.25

TkFrame.new { |f|
  "789*456/123-0+=C".split(//).each_with_index do |w, i|
  TkButton.new(f) {
    text "#{w}"
    bind('1', proc { e.value = eval e.value }) if w == "="
    bind('1', proc { e.value = "" }) if w == "C"
    command { e.insert('end', w) }  if w != "C" && w != "="
    place('relx' => (i % 4) * r, 'rely' => i / 4 * r,
          'relw' => r, 'relh' => r)
  }
  i += 1
  end
  height 120
  width 120
}.pack('fill' => 'x')

Tk.mainloop
