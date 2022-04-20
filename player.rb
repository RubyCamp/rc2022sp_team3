require_relative 'bullet'
Dir.glob("directors/game_director.rb") {|path| require_relative path }

class Player
  attr_accessor :mesh,:killcount,:hitpoint
  
  def initialize(x, y, z, renderer, scene, score, hitpoint)
    @mesh = Mittsu::Mesh.new(
      Mittsu::BoxGeometry.new(0, 0, 0),
      Mittsu::MeshBasicMaterial.new(color: 0x000000, opacity: 0.0, transparent: true)
    )
    @mesh.position.set(x, y, z)

    @renderer = renderer
    @scene = scene
    @bullets = []    
    @score = score
    @hitpoint = hitpoint
    @killcount = 0

        #左クリックで弾発射
        renderer.window.on_mouse_button_pressed do |glfw_button, position|
          case glfw_button
          when GLFW_MOUSE_BUTTON_LEFT
            bullet = Bullet.new(@mesh.position.x, @mesh.position.y, @mesh.position.z)
            @scene.add(bullet.mesh)
            @bullets << bullet
          end
        end    
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

  #プレイヤーの弾が敵に命中
  def check(enemies)
    enemies.each do |enemy|
      @bullets.each do |bullet|
        if bullet.mesh.position.distance_to(enemy.mesh.position) <= 0.1 + 0.5
          enemy.hit
          @score.points += 100
          @killcount+=1          
        end
      end
    end
  end

  #敵の弾がプレイヤーに命中
  def check3(bullets)
    bullets.each do |bullet|
      if bullet.mesh2.position.distance_to(@mesh.position) <= 0.1 + 0.5
        @hitpoint -= 10
        game_director.mesh.geometry.height.set(@hitpoint)
        if @score.points >= 100
          @score.points -= 100
        end
      end
    end
  end

  #プレイヤーのHPが0になったら
  def update_hitpoints    
    if @hitpoint == 0
      puts "Game over"
    end
  end
end