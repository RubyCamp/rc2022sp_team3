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
    @mesh.position.set(-400, -256, 10)
    @widget_scene.add(@mesh)

    #@camera.position.z = 10.0
    @widget_camera.position.z = 10.0
    @score = Score.new(screen_width, screen_height)
    @time_count = 0
    @flag = 0
    
    @enemies = []
    @bullets = []
    10.times do
      @enemy = Enemy.new((rand(1..5) - 3).to_f, (rand(1..5) -3).to_f, 0.0, @renderer, @scene)
      @scene.add(@enemy.mesh)
      @enemies << @enemy
    end

    10.times do
      @enemy2 = Enemy.new((rand(1..5) - 3).to_f, (rand(1..5) -3).to_f, -30.0, @renderer, @scene)
      # @scene.add(@enemy.mesh2)
      @enemies << @enemy2
    end

    @ruby = Enemy.new((rand(1..5) - 3).to_f, (rand(1..5) - 3).to_f, -50.0, @renderer, @scene)
    # @scene.add(@ruby.ruby)
    
    @player = Player.new(0.0, 0.0, 10.0, @renderer, @scene, @score, @hitpoint)
    @scene.add(@player.mesh)
    @player.mesh.add(@camera)
  end

  def play
    @player.update

    if @player.mesh.position.z == -20 && @flag == 0
      @scene.add(@enemy2.mesh2)
      @flag = 1
    elsif @player.mesh.position.z == -20 && @flag == 1
      @scene.add(@ruby.ruby)
      @flag = 2
    else
      #
    end

    @time_count += 1

    puts "#{@time_count}, (#{@player.mesh.position.x}, #{@player.mesh.position.y}, #{@player.mesh.position.z}), #{@player.hitpoint} ,#{@score.points}"

    @enemies.each do |enemy|
      enemy.bullets.each do |bullet|
        bullet.update2
      end
    end

    # 消滅したenemyからは弾が出ないようにする #
    # よりゲーム性を上げるように処理を増やす #
    @enemies.each do |enemy|
      if @time_count % 20 == 0
        enemy.fire
        enemy.update
      elsif @time_count == 120
        #
      else
        #
      end
    end

    if @time_count > 200
      @time_count = 0
    end      

    @player.check(@enemies) # 動作済み #
    @player.check2(@enemies)
    @enemies.each do |enemy|
      @player.check3(enemy.bullets) 
    end
    @score.update_points
    @player.update_hitpoints

    @renderer.clear
    @renderer.render(@widget_scene, @widget_camera)
    @renderer.render(@scene, @camera)
    @renderer.render(@score.scene, @score.camera)
  end
end