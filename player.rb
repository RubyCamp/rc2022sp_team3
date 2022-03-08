require_relative 'bullet'

class Player
  attr_accessor :mesh

  def initialize(x, y, z, renderer, scene, score, hitpoint)
    @mesh = Mittsu::Mesh.new(
      Mittsu::BoxGeometry.new(1.0, 1.0, 1.0),
      Mittsu::MeshBasicMaterial.new(color: 0x00ff00)
    )
    @mesh.position.set(x, y, z)

  =begin
    @mesh2 = Mittsu::Mesh.new(
      Mittsu::BoxGeometry.new(2.0, 50.0, 0.0)
      Mittsu::MeshBasicMaterial.new(color: 0xffff00)
    )
    @mesh2.position.set(x, y, z)
  =end

    @renderer = renderer
    @scene = scene
    
    @bullets = []
    @renderer.window.on_key_typed do |key|
      case key
      when GLFW_KEY_SPACE
        bullet = Bullet.new(@mesh.position.x, @mesh.position.y, @mesh.position.z)
        @scene.add(bullet.mesh)
        @bullets << bullet
      end
    end
    
    @score = score
    @hitpoint = hitpoint

  =begin
    Mittsu::Sprite.new(@mesh2).tap do |sprite|
      sprite.scale.set(128, 128, 1.0)
      sprite.position.set((screen_width / 2.0) + 64 + dx * index, (screen_height / 2.0) + 64, 0.0)
      @scene.add(sprite)
      @mesh2 << sprite
    end
  =end
  end

  def update
    @mesh.position.y += 0.1 if @renderer.window.key_down?(GLFW_KEY_UP)
    @mesh.position.y -= 0.1 if @renderer.window.key_down?(GLFW_KEY_DOWN)
    @mesh.position.x -= 0.1 if @renderer.window.key_down?(GLFW_KEY_LEFT)
    @mesh.position.x += 0.1 if @renderer.window.key_down?(GLFW_KEY_RIGHT)
    @mesh.position.z += 0.1 if @renderer.window.key_down?(GLFW_KEY_Z)
    @mesh.position.z -= 0.1 if @renderer.window.key_down?(GLFW_KEY_A)

    @bullets.each do |bullet|
      bullet.update
    end
  end

  def check(enemies)
    enemies.each do |enemy|
      @bullets.each do |bullet|
        if bullet.mesh.position.distance_to(enemy.mesh.position) <= 0.1 + 0.5
          enemy.mesh.material.color.set(0xff0000)
          @scene.remove(bullet.mesh)
          @bullets.delete(bullet)
          sleep(0.5)
          @scene.remove(enemy.mesh)
          @enemies.delete(enemy)
          @score.points += 50
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
        @hitpoint -= 10
        @score.points -= 100
      else
        # 
      end
    end
  end
=end
end
