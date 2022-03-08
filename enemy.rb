require_relative 'bullet' #敵の弾はbulletのmesh2を使用

class Enemy
  attr_accessor :mesh,:hitpoint,:bullets

  def initialize(x, y, z, renderer, scene)
    @mesh = Mittsu::Mesh.new(#メッシュにまとめて代入
      Mittsu::BoxGeometry.new(1, 1, 1),
      Mittsu::MeshBasicMaterial.new(color: 0x0000ff)
    )
    @mesh.position.set(x, y, z)

    @scene,@renderer = scene,renderer

    @hitpoint = 3
    @bullets =[]
    @boxs = []
  end

  def fire#敵が弾を発射
    @bullet = Bullet.new(@x,@y,@z)
    @scene.add(@bullet.mesh2)
    @bullets << @bullet
  end

  def dead#消滅時処理
    @box = Box.new(@x,@y,@z,@scene)
    @scene.add(@box.mesh)
    @boxs << @box
  end

  def update#移動
    #mesh.position.z += 0.1
  end
end

class Box#アイテムbox
  attr_accessor :mesh
  def initialize(x,y,z,scene)
    @x,@y,@z,@scene = x,y,z,scene
    @mesh = Mittsu::Mesh.new(
     Mittsu::BoxGeometry.new(1, 1, 1),
     Mittsu::MeshBasicMaterial.new(color: 0x000055)
    )
    @bullet.position.set(@x,@y,@z)
  end

end