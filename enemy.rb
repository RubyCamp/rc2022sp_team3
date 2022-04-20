require_relative 'bullet' #敵の弾はbulletのmesh2を使用

class Enemy
  attr_accessor :mesh,:bullets,:flag

  def initialize(x, y, z, renderer, scene)
    @x,@y,@z = x,y,z
    @scene,@renderer = scene,renderer
    @bullets = []
    @flag = 1

    @mesh = Mittsu::Mesh.new(
      Mittsu::BoxGeometry.new(1, 1, 1),
      Mittsu::MeshBasicMaterial.new(color: 0x0000ff)
    )
    @mesh.position.set(@x, @y, @z)
  end

  def fire#敵が弾を発射
    if @flag == 1
      bullet = Bullet.new(@x,@y,@z)
      @scene.add(bullet.mesh2)
      @bullets << bullet
    else
    end
  end

  def hit # enemyがplayerの弾に当たった時の処理
    @scene.remove(@mesh)
    @bullets.each do |bullet|
      @scene.remove(bullet.mesh2)
    end
    @bullets.delete_if do |bullet|
      1
    end
    @flag = 0
  end

  def update#移動
    @mesh.position.x += 3
  end
end