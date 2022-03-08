class Enemy
  attr_accessor :mesh, :bullets, :hitpoint

  def initialize(x, y, z, renderer, scene)
    @mesh = Mittsu::Mesh.new(#メッシュにまとめて代入
      Mittsu::BoxGeometry.new(1, 1, 1),
      Mittsu::MeshBasicMaterial.new(color: 0x0000ff)
    )
    @mesh.position.set(x, y, z)

    @scene,@renderer = scene,renderer

    @scene.add(@mesh)

    @bullets = []
    @boxs = []
    @hitpoint = 3
  end


  def hit#プレイヤーの弾が当たった時
    @hitpoint -= 1
  end

  def fire#敵が弾を発射
    @bullet = Enemybullet.new(@x,@y,@z,@scene) 
    @bullets << @bullet
  end

  def dead#消滅時処理
    @box = Box.new(@x,@y,@z,@scene)
    @boxs << @box
    @scene.remove(@mesh)
  end

  def update#移動
    mesh.position.x += rand(2)
    mesh.position.z += rand(2)
>>>>>>> f99c24f5cfaa105120ac94217ee4a8015c8fbe03
  end
end


class Enemybullet#敵弾
  def initialize(x,y,z, scene)
    @x,@y,@z,@scene = x,y,z,scene
    @bullet = Mittsu::Mesh.new(
      Mittsu::SphereGeometry.new(0.5,0.5,0.5),
      Mittsu::MeshBasicMaterial.new(color: 0x0050ff)
    )
    @bullet.position.set(@x,@y,@z)
    @scene.add(@bullet)
  end

  def update
    @bullet.position.z -= 1 
  end

  def del
    @scene.remove(@bullet)
  end
end


class Box#アイテムbox
  def initialize(x,y,z,scene)
    @x,@y,@z,@scene = x,y,z,scene
    @box = Mittsu::Mesh.new(
     Mittsu::BoxGeometry.new(1, 1, 1),
     Mittsu::MeshBasicMaterial.new(color: 0x000055)
    )
    @bullet.position.set(@x,@y,@z)
    @scene.add(@box)
  end

  def del
    @scene.remove(@box)
  end

end
