require_relative 'player'
require_relative 'enemy'
require_relative 'score'

class Game
  def initialize(renderer, screen_width, screen_height)
    @renderer = renderer
    renderer.auto_clear = false

    # 体力ゲージ描画を要微調整 #

    @widget_scene = Mittsu::Scene.new
    @widget_camera = Mittsu::OrthographicCamera.new(screen_width / 2.0, -screen_width / 2.0, screen_height / 2.0, -screen_height / 2.0, 0.0, 1.0)
    @scene = Mittsu::Scene.new
    @camera = Mittsu::PerspectiveCamera.new(75.0, ASPECT, 0.1, 1000.0)
    @hitpoint = 100

    @mesh = Mittsu::Mesh.new(
      Mittsu::BoxGeometry.new(2.0, @hitpoint, 0),
      Mittsu::MeshBasicMaterial.new(color: 0xffff00)
    )
    @mesh.scale.set(2, 2, 2)
    @mesh.position.set(-256, -256, 10)
    @widget_scene.add(@mesh)

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

    # 消滅したenemyからは弾が出ないようにする #
    # よりゲーム性を上げるように処理を増やす #
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

    @score.update_points # 動作済み #
    @player.update_hitpoints 

    @renderer.clear
    @renderer.render(@widget_scene, @widget_camera)
    @renderer.render(@scene, @camera)
    @renderer.render(@score.scene, @score.camera)
  end
end
