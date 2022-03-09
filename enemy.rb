require_relative 'bullet' #敵の弾はbulletのmesh2を使用

class Enemy
  attr_accessor :mesh,:bullets

  def initialize(x, y, z, renderer, scene)
    @x,@y,@z = x,y,z
    @scene,@renderer = scene,renderer
    @bullets =[]

    @mesh = Mittsu::Mesh.new(#メッシュにまとめて代入
      Mittsu::BoxGeometry.new(1, 1, 1),
      Mittsu::MeshBasicMaterial.new(color: 0x0000ff)
    )
    @mesh.position.set(@x, @y, @z)
    @scene.add(@mesh)
  end

  def fire#敵が弾を発射
    bullet = Bullet.new(@x,@y,@z)
    @scene.add(bullet.mesh2)
    @bullets << bullet
  end

  def hit # enemyがplayerの弾に当たった時の処理
    @scene.remove(@mesh)
    @bullets.each do |bullet|
      @scene.remove(bullet.mesh)
      @bullets.delete(bullet)
    end
  end

=begin
  def dead # enemyの消滅処理
      end
  end
end
=end

  def update#移動
    @mesh.position.z += 0.3
  end
end