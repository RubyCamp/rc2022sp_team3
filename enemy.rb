require_relative 'bullet.rb' #敵の弾はbulletのmesh2を使用

class Enemy
  attr_accessor :mesh,:hitpoint,:bullets

  def initialize(x, y, z, renderer, scene)
    @x,@y,@z = x,y,z
    @scene,@renderer = scene,renderer
    @hitpoint = 3
    @bullets =[]
    @dflg = 0

    @mesh = Mittsu::Mesh.new(#メッシュにまとめて代入
      Mittsu::BoxGeometry.new(1, 1, 1),
      Mittsu::MeshBasicMaterial.new(color: 0x0000ff)
    )
    @mesh.position.set(@x, @y, @z)
  end

  def fire#敵が弾を発射
    if @dflg == 0
    @bullet = Bullet.new(@x,@y,@z)
    @scene.add(@bullet.mesh2)
    @bullets << @bullet 
    else 
      return -1
    end
  end

  def hit#被弾時
    @hitpoint-=1
    if hitpoint < 0
      dead
    end
  end

  def dead#hp<0
    @scene.remove(@mesh)
    @bullets.each do |bullet|
      @scene.remove(bullet.mesh2)
      @bullets.delete(bullet)
    end

    @box = Box.new(@x,@y,@z)
    @scene.add(@box.mesh)
    @dflg = -1
  end

  def playerhit#プレイヤーに当たった
    if @dflg == 0
      return -1
    else
      @scene.remove(@box.mesh)
      return 0
    end
  end

  def update(px,py,pz)#追加分のxyz座標を入力
    @x += px
    @y += py
    @z += pz
    @z += 1
    @mesh.position.set(@x,@y,@z)
  end
end

class Box#アイテムbox
  attr_accessor :mesh
  def initialize(x,y,z)
    @x,@y,@z = x,y,z
    @mesh = Mittsu::Mesh.new(
     Mittsu::BoxGeometry.new(1, 1, 1),
     Mittsu::MeshBasicMaterial.new(color: 0x000055)
    )
    @mesh.position.set(@x,@y,@z)
  end
end
