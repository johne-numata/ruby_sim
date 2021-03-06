require 'cairo'
require 'stringio'

# 画像を生成する
def make_image()

  format = Cairo::FORMAT_ARGB32
  width = 300
  height = 200

  # 画像の新規作成
  surface = Cairo::ImageSurface.new(format, width, height)
  context = Cairo::Context.new(surface)

  context.set_source_rgb(1, 1, 1)
  context.rectangle(0, 0, width, height)
  context.fill

  context.set_source_rgb(0, 0, 1)
  context.arc(width / 2, height / 2, height / 4, 0, 2 * Math::PI)
  context.fill

  # PNG画像を書き込み
  io = StringIO.new
  surface.write_to_png(io)
  io.pos = 0
  io
end

# 画像にラクガキする
def draw_rakugaki(io)

  # PNG画像を読み込み
  surface = Cairo::ImageSurface.from_png(io)
  context = Cairo::Context.new(surface)

  w = surface.width / 4
  h = surface.height / 4

  context.set_source_color(Cairo::Color::GREEN)
  context.set_line_width(10)
  context.move_to(w, h)
  context.line_to(w * 3, h * 3)
  context.stroke

  # PNG画像を書き込み
  io = StringIO.new
  surface.write_to_png(io)
  io.pos = 0
  io
end

open('sample1.png', 'wb') do |io|
  io.write(make_image.read)
end

open('sample2.png', 'wb') do |output|
  open('sample1.png', 'rb') do |input|
    output.write(draw_rakugaki(input).read)
  end
end
