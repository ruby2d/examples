# A simple "Triangle Game" that allows you to move a Roguelike '@' around the
# window (and off of it). This is a working example on MacOS 10.12 as of Dec 16, 2017.
# This combines some of the Ruby2D tutorial code with keypress management
# that actually works.
# 
# Keys: hjkl: movement, q: quit
# 
# To run: ruby triangle-game.rb after installing the Simple2D library and Ruby2D Gem.
#
# Author: Douglas P. Fields, Jr.
# E-mail: symbolics@lisp.engineer
# Site: https://symbolics.lisp.engineer/
# Copyright 2017 Douglas P. Fields, Jr.
# License: The MIT License

require 'ruby2d'

set title: "Triangle Game"

Triangle.new(
  x1: 320, y1:  50,
  x2: 540, y2: 430,
  x3: 100, y3: 430,
  color: ['red', 'green', 'blue']
)

msg = Text.new(x: 320, y: 240, text: 'Hi, Tres!', size: 20, font: '../fonts/Ubuntu.ttf')

player = Text.new(x: 0, y: 0, text: '@', size: 32, font: '../fonts/Ubuntu.ttf');

msg.x = 320 - msg.width / 2
msg.y = 240 - msg.height / 2

tick = 0
t = Time.now

on :key do |e|
  # puts e
  if e.type == :down
    case e.key
    when 'j'
      player.y += player.height
    when 'k'
      player.y -= player.height
    when 'h'
      player.x -= player.width
    when 'l'
      player.x += player.width
    when 'q'
      close
    end
  end
end

update do
  if tick % 60 == 0
    set background: 'random'
  end
  tick += 1
  # Close the window after 5 seconds
  #if Time.now - t > 5 then close end
end

show

