require_relative 'player'
require_relative 'enemy'
require_relative 'score'

class Game
  def initialize(renderer, screen_width, screen_height)
    @renderer = renderer
    renderer.auto_clear = false

    @scene = Mittsu::Scene.new
    @camera = Mittsu::PerspectiveCamera.new(75.0, ASPECT, 0.1, 1000.0)

    # 背景を描画 #
    # camera.position.z = 10.0
    @score = Score.new(screen_width, screen_height)

    @enemies = []
    5.times do
      enemy = Enemy.new((rand(1..5) - 3).to_f, (rand(1..5) -3).to_f, 0.0, @renderer, @scene)
      @scene.add(enemy.mesh)
      @enemies << enemy
    end
    
    @player = Player.new(0.0, 0.0, 10.0, @renderer, @scene, @score)
    @scene.add(@player.mesh)
    @player.mesh.add(@camera)
  end

  def play
    @player.update

    @enemies.each do |enemy|
      enemy.fire
      enemy.update
    end

    @player.check(@enemies)
    @player.check2(@enemies)
    # @player.check3(@enemy_bullets) #

    @score.update_points
    # @score.update_hitpoints #

    @renderer.clear
    @renderer.render(@scene, @camera)
    @renderer.render(@score.scene, @score.camera)
  end
end
