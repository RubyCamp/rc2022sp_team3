require_relative 'bullet' #敵の弾はbulletのmesh2を使用

class Enemy
  attr_accessor :mesh,:bullets

  def initialize(x, y, z, renderer, scene)
    @x,@y,@z = x,y,z
    @scene,@renderer = scene,renderer
    @bullets =[]
    @dflg = 1

    @mesh = Mittsu::Mesh.new(#メッシュにまとめて代入
      Mittsu::BoxGeometry.new(1, 1, 1),
      Mittsu::MeshBasicMaterial.new(color: 0x0000ff)
    )
    @mesh.position.set(@x, @y, @z)
    @scene.add(@mesh)
  end

  def fire#敵が弾を発射
    if dflg = 1
    bullet = Bullet.new(@x,@y,@z)
    @scene.add(bullet.mesh2)
    @bullets << bullet
    else
    end
  end

  def hit # enemyがplayerの弾に当たった時の処理
    @scene.remove(@mesh)
    @dflg = 0
  end

  def update#移動
    @z+=1
    @mesh.position.set(@x, @y, @z)
  end
end