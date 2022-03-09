require_relative 'bullet'

class Player
  attr_accessor :mesh
  
  def initialize(x, y, z, renderer, scene, score, hitpoint)
    @mesh = Mittsu::Mesh.new(
      Mittsu::BoxGeometry.new(1.0, 1.0, 1.0),
      Mittsu::MeshBasicMaterial.new(color: 0x00ff00)
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
        else
          # 衝突してない
        end
      end
    end
  end
  
  # enemyとplayerの接触処理 #
  def check2
    @enemies.each do |enemy|
      if enemy.mesh.position.distance_to(@mesh.position) <= 0.5 + 0.5
        @hitpoint = 0
        @score.points -= 100
      else
        # 
      end
    end
  end

  # enemyの弾とplayerの接触処理 #
  def check3
    @bullets.each do |bullet|
      if bullet.mesh2.position.distance_to(@mesh.position) <= 0.1 + 0.5
        @hitpoint -= 10
        #@scene.remove(bullet.mesh2)
        #@bullets.delete(bullet)
        @score.points -= 100
      else
        # 
      end
    end
  end

  # HPの処理 #
  def update_hitpoints
    if @hitpoint == 20
      game.mesh.material.color.set(0xff0000)
    elsif @hitpoint == 0
      puts "Game over"
      return 0
    else
      return
    end
  end
end
