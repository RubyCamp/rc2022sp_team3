require 'mittsu'
require_relative 'game'

SCREEN_WIDTH = 1024
SCREEN_HEIGHT = 768
ASPECT = SCREEN_WIDTH.to_f / SCREEN_HEIGHT.to_f

renderer = Mittsu::OpenGLRenderer.new width: SCREEN_WIDTH, height: SCREEN_HEIGHT, title: 'Sample Game'

game = Game.new(renderer, SCREEN_WIDTH, SCREEN_HEIGHT)

renderer.window.run do
  game.play
end
