#
# Ruby2D Example: Key Events
#
# This is a simple example capturing KeyEvents. Run it and try typing!
# => author: slime-man
require 'ruby2d'

set title: "KeyEvent Example"
text_size = 20

on :key_down do |k|
  key = k['key']
  case key
  when 'space'
    clear
  when 'backspace'
    close
  else
    Text.new(
      x: rand((get :width) - text_size),
      y: rand((get :height) - text_size),
      text: key,
      size: text_size,
      z: 0,
      color: 'random'
    )
  end
end

show
