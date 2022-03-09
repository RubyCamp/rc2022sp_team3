require_relative 'player'
require_relative 'enemy'
require_relative 'score'

class Game
  def initialize(renderer, screen_width, screen_height)
    @renderer = renderer
    renderer.auto_clear = false

    # widget_cameraの動作が良くわからん #

    @widget_scene = Mittsu::Scene.new
    @widget_camera = Mittsu::OrthographicCamera.new(75.0, ASPECT, 0.1, 1000.0)
    @scene = Mittsu::Scene.new
    @camera = Mittsu::PerspectiveCamera.new(75.0, ASPECT, 0.1, 1000.0)
    @hitpoint = 100

    @mesh = Mittsu::Mesh.new(
      Mittsu::PlaneGeometry.new(2.0, @hitpoint),
      Mittsu::MeshBasicMaterial.new(color: 0xffff00)
    )
    @mesh.scale.set(1,1,1)
    @mesh.position.set(-256, -256, 10)
    @widget_scene.add(@mesh)
    # @mesh.add(@widget_scene)

    # directionalLight = Mittsu::DirectionalLight.new(0xffffff)
    # directionalLight.position.set(1, 1, 1)
    # @widget_scene.add(directionalLight)

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
    
    @player = Player.new(0.0, 0.0, 10.0, @renderer, @scene, @score, @hitpoint)
    @scene.add(@player.mesh)
    @player.mesh.add(@camera)
  end

  def play
    @player.update
    @time_count += 1
    puts "#{@time_count}, (#{@player.mesh.position.x}, #{@player.mesh.position.y}, #{@player.mesh.position.z}), #{@hitpoint}"

    @enemies.each do |enemy|
      enemy.bullets.each do |bullet|
        bullet.update2
      end
    end

    @enemies.each do |enemy|
      if @time_count == 60
        enemy.fire
        enemy.update
      elsif @time_count == 120
        enemy.update2
      else
        #
      end
    end

    if @time_count > 255
      @time_count = 0
    end

    @player.check(@enemies) # 動作済み #
    @player.check2
    @player.check3 

    @score.update_points
    @player.update_hitpoints #

    @renderer.clear
    @renderer.render(@widget_scene, @widget_camera)
    @renderer.render(@scene, @camera)
    @renderer.render(@score.scene, @score.camera)
  end
end
