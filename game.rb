require_relative 'player'
require_relative 'enemy'
require_relative 'score'

class Game
  def initialize(renderer, screen_width, screen_height)
    @renderer = renderer
    renderer.auto_clear = false

    @widget_scene = Mittsu::Scene.new
    @widget_camera = Mittsu::OrthographicCamera.new(75.0, ASPECT, 0.1, 1000.0)
    @scene = Mittsu::Scene.new
    @camera = Mittsu::PerspectiveCamera.new(75.0, ASPECT, 0.1, 1000.0)

    @mesh = Mittsu::Mesh.new(
      Mittsu::BoxGeometry.new(2.0, 100, 0.0),
      Mittsu::MeshBasicMaterial.new(color: 0xffff00)
    )
    @mesh.position.set(-128, -128, 1)
    @widget_scene.add(@mesh)
    # @mesh.add(@widget_scene)

    # directionalLight = Mittsu::DirectionalLight.new(0xffffff)
    # directionalLight.position.set(1, 1, 1)
    # @widget_scene.add(directionalLight)

    # 背景を描画 #
    @camera.position.z = 10.0
    @widget_camera.position.z = 10.0
    @score = Score.new(screen_width, screen_height)
    @time_count = 0

    @enemies = []
    @bullets = []
    5.times do
      @enemy = Enemy.new((rand(1..5) - 3).to_f, (rand(1..5) -3).to_f, 0.0, @renderer, @scene)
      @scene.add(@enemy.mesh)
      @enemies << @enemy
    end
    
    @player = Player.new(0.0, 0.0, 10.0, @renderer, @scene, @score)
    @scene.add(@player.mesh)
    @player.mesh.add(@camera)
  end

  def play
    @player.update
    @time_count += 1
    puts "#{@time_count}"

    @enemies.each do |enemy|
        enemy.bullets.each do |bullet|
          bullet.update2
        end
    end

    if @time_count == 60
      @enemies.each do |enemy|
        enemy.fire
        enemy.update
      end
    end

    if @time_count > 255
      @time_count = 0
    end

    @player.check(@enemies)
    @player.check2(@enemies)
    @player.check3(@bullets) 

    @score.update_points
    @player.update_hitpoints #

    @renderer.clear
    @renderer.render(@widget_scene, @widget_camera)
    @renderer.render(@scene, @camera)
    @renderer.render(@score.scene, @score.camera)
  end
end
