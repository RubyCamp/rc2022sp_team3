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
  end


  def hit#プレイヤーの弾が当たった時 -> check関数で処理済み
    @hitpoint -= 1
    @bullets =[]
    @boxs = []
  end

=begin
  def fire#敵が弾を発射
    @bullet = Bullet.new(@x,@y,@z)
    @scene.add(@bullet.mesh2)
    @bullets << @bullet
    bullet.update2
  end
=end

  def dead#消滅時処理 -> check関数で処理済み
    @box = Box.new(@x,@y,@z,@scene)
    @scene.add(@box.mesh)
    @boxs << @box
  end

  def update#移動
    mesh.position.x += (rand(0.1..0.5) + 0.1).to_f
    mesh.position.z += (rand(0.1..0.5) + 0.2).to_f
  end
end

class Box#アイテムbox -> 今回は使用しないかも...
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