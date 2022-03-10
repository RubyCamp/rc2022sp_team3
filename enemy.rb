require_relative 'bullet' #敵の弾はbulletのmesh2を使用

class Enemy
  attr_accessor :mesh,:bullets
  attr_reader :flag

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

    # z軸-30のところにenemy.mesh2をenemy.meshと同じように描画 #
    @mesh2 = Mittsu::Mesh.new(
      Mittsu::BoxGeometry.new(1, 1, 1),
      Mittsu::MeshBasicMaterial.new(color: 0x0000ff)
    )
    @mesh2.position.set(@x, @y, @z)

    # # z軸-50のところにRuby画像をenemy.mesh3として描画 #
    # geometry = Mittsu::SphereGeometry.new(1.0, 32, 16)
    # texture = Mittsu::ImageUtils.load_texture(File.join File.dirname(__FILE__), 'images',"rubig-ruby.png")
    # material = Mittsu::MeshBasicMaterial.new(map: texture)
    # @ruby = Mittsu::Mesh.new(geometry, material)
    # @ruby.position.set(@x, @y, @z)

    @scene.add(@mesh)
    #@scene.add(@mesh2)
    #@scene.add(@ruby)
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

  # enemy.mesh3に関しては別にhit, dead関数を作成 #

  def update#ランダム移動
    dx = rand(3)
		dy = rand(3)
		case dx
		when 1
			self.mesh.position.x += 0.01
		when 2
			self.mesh.position.x -= 0.01
		end

		case dy
		when 1
			self.mesh.position.y += 0.01
		when 2
			self.mesh.position.y -= 0.01
		end
  end

  def update2 
    @mesh.position.x += 3
  end
end