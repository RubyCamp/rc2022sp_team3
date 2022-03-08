require_relative 'bullet'

class Player
  attr_accessor :mesh
  
  def initialize(x, y, z, renderer, scene, score)
    @mesh = Mittsu::Mesh.new(
      Mittsu::BoxGeometry.new(1.0, 1.0, 1.0),
      Mittsu::MeshBasicMaterial.new(color: 0x00ff00)
    )
    @mesh.position.set(x, y, z)

    @renderer = renderer
    @scene = scene
    
    @bullets = []
    @enemies = []
    @renderer.window.on_mouse_button_pressed do |key|
      case key
      when GLFW_KEY_SPACE
        bullet = Bullet.new(@mesh.position.x, @mesh.position.y, @mesh.position.z)
        @scene.add(bullet.mesh)
        @bullets << bullet
      end
    end
    
    @score = score
    # @hitpoint = hitpoint

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
          enemy.mesh.material.color.set(0xff0000)
          @scene.remove(enemy.mesh)
          @enemies.delete(enemy)
          sleep(0.1)
          @scene.remove(bullet.mesh)
          @bullets.delete(bullet)
          
          @score.points += 1
        else
          # 衝突してない
        end
      end
    end
  end

  def check2(enemies)
    enemies.each do |enemy|
      if @mesh.position.distance_to(enemy.mesh.position) <= 0.1 + 0.5
        @hitpoint.hitpoints -= 10
        @scene.remove(enemy.mesh)
        @enemies.delete(enemy)
        @score.points -= 100
      else
        # 
      end
    end
  end

=begin
  def check3(enemy_bullets)
    enemy_bullets.each do |enemy_bullet|
      if @mesh.position.distance_to(enemy_bullet.mesh.position) <= 0.1 + 0.5
        @hitpoint.hitpoints -= 10
        @score.points -= 100
      else
        # 
      end
    end
  end

  def Gameover(hitpoints)
    if @hitpoint.hitpoints == 0
      puts "Game Over"
    else
      #
    end
  end
=end
end
