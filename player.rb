require_relative 'bullet'
Dir.glob("directors/game_director.rb") {|path| require_relative path }
# require_relative 'directors/game_director'

class Player
  attr_accessor :mesh,:killcount
  attr_reader :hitpoint
  
  def initialize(x, y, z, renderer, scene, score, hitpoint)
    @mesh = Mittsu::Mesh.new(
      Mittsu::BoxGeometry.new(0, 0, 0),
      Mittsu::MeshBasicMaterial.new(color: 0x000000, opacity: 0.0, transparent: true)
    )
    @mesh.position.set(x, y, z)

    @renderer = renderer
    @scene = scene
    
    @bullets = []
    @enemies = []
    renderer.window.on_mouse_button_pressed do |glfw_button, position|
      case glfw_button
      when GLFW_MOUSE_BUTTON_LEFT
        bullet = Bullet.new(@mesh.position.x, @mesh.position.y, @mesh.position.z)
        @scene.add(bullet.mesh)
        @bullets << bullet
      end
    end
    
    @score = score
    @hitpoint = hitpoint
    @killcount = 0
  end

  def update
    @mesh.position.y += 0.1 if @renderer.window.key_down?(GLFW_KEY_W)
    @mesh.position.y -= 0.1 if @renderer.window.key_down?(GLFW_KEY_S)
    @mesh.position.x -= 0.1 if @renderer.window.key_down?(GLFW_KEY_A)
    @mesh.position.x += 0.1 if @renderer.window.key_down?(GLFW_KEY_D)
    @mesh.position.z += 0.1 if @renderer.window.key_down?(GLFW_KEY_E)
    @mesh.position.z -= 0.1 if @renderer.window.key_down?(GLFW_KEY_Q)

    @bullets.each do |bullet|
      bullet.update
    end
  end 

  def check(enemies)
    enemies.each do |enemy|
      @bullets.each do |bullet|
        if bullet.mesh.position.distance_to(enemy.mesh.position) <= 0.1 + 0.5
          enemy.hit
          @score.points += 100
          @killcount+=1
        else
          
        end
      end
    end
  end
  
  # enemyとplayerの接触処理 #
  def check2(enemies)
    @enemies.each do |enemy|
      if enemy.mesh.position.distance_to(@mesh.position) <= 0.5 + 0.5
        @hitpoint -= 20
        game_director.mesh.geometry.height.set(@hitpoint)
        if @score.points >= 100
          @score.points -= 100
        end
      end
    end
  end

  # enemyの弾とplayerの接触処理 #
  def check3(bullets)
    bullets.each do |bullet|
      if bullet.mesh2.position.distance_to(@mesh.position) <= 0.1 + 0.5
        @hitpoint -= 10
        game_director.mesh.geometry.height.set(@hitpoint)
        #@scene.remove(bullet.mesh2)
        #@bullets.delete(bullet)
        if @score.points >= 100
          @score.points -= 100
        end
      end
    end
  end
  
  #bossの弾の処理
  def check4(boss)
    boss.bullets.each do |bullet|
      if bullet.mesh2.position.distance_to(@mesh.position) <= 0.1 + 0.5
        @hitpoint -= 10
        #@scene.remove(bullet.mesh2)
        #@bullets.delete(bullet)
        if @score.points >= 100
          @score.points -= 100
        end
      end
    end
  end

  # HPの処理 #
  def update_hitpoints
    if @hitpoint == 20
      gamedirector.mesh.material.color.set(0xff0000)
      puts "hp danger!!!"
    elsif @hitpoint == 0
      puts "Game over"
      return 0
    else
      #
    end
  end
end