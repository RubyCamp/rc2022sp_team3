require_relative 'bullet' #敵の弾はbulletのmesh2を使用

class Enemy
  attr_accessor :mesh,:bullets

  def initialize(x, y, z, renderer, scene)
    @x,@y,@z = x,y,z
    @scene,@renderer = scene,renderer
    @bullets =[]
    @flag = 1


    @mesh = Mittsu::Mesh.new(#メッシュにまとめて代入
      Mittsu::BoxGeometry.new(1, 1, 1),
      Mittsu::MeshBasicMaterial.new(color: 0x0000ff)
    )
    @mesh.position.set(@x, @y, @z)

    # z軸30のところにenemy.mesh2をenemy.meshと同じように描画 #
=begin
    @mesh2 = Mittsu::Mesh.new(
      Mittsu::BoxGeometry.new(1, 1, 1),
      Mittsu::MeshBasicMaterial.new(color: 0x0000ff)
    )
    @mesh2.position.set(@x, @y, @z)

    # z軸50のところにRuby画像をenemy.mesh3として描画 #
    @mesh3 = Mittsu::Mesh.new(
      texture = Mittsu::ImageUtils.load_texture(File.join File.dirname(__FILE__), 'rubig-ruby.png')
      material = Mittsu::MeshBasicMaterial.new(map: texture)
    )
    @mesh3.position.set(@x, @y, @z)
=end

    @scene.add(@mesh)
    #@scene.add(@mesh2)
    #@scene.add(@mesh3)
  end

  def fire#敵が弾を発射
    if @flag == 1
      bullet = Bullet.new(@x,@y,@z)
      @scene.add(bullet.mesh2)
      @bullets << bullet
    end
  end

  def hit # enemyがplayerの弾に当たった時の処理
    @scene.remove(@mesh)
    @flag = 0
  end

  # enemy.mesh3に関しては別にhit, dead関数を作成 #

  # x, y, z軸全方向に対応したupdate関数を作成 #
  def update#移動
    @z += 1
    @mesh.position.set(@x, @y, @z)
  end

  def update2 
    @mesh.position.x += 3
  end
end