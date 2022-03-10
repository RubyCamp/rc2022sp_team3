require_relative 'bullet' #敵の弾はbulletのmesh2を使用

class Boss
  attr_accessor :mesh,:bullets,:flag,:ruby


  def initialize(x, y, z, renderer, scene)
    @x,@y,@z = x,y,z
    @scene,@renderer = scene,renderer
    @bullets =[]
    @flag = 1#1生存 0死亡
    @hp = 30
    @hitf = 1#1未被弾 0被弾中
    @hitc = 0

    geometry = Mittsu::CylinderGeometry.new(8,0.1,10,12,1,false,0.0,::Math::PI * 2.0)
    material = Mittsu::MeshBasicMaterial.new(color: 0xff0000,wireframe: true)
    @ruby = Mittsu::Mesh.new(geometry, material)
    @ruby.position.set(@x,@y,@z)
    @scene.add(@ruby)
  end

  def fire#敵が弾を発射
    if @flag == 1
      bullet = Bullet.new(@x,@y,@z)
      @scene.add(bullet.mesh2)
      @bullets << bullet
    else
    end
  end

  def hit
        @hitf = 0
        @ruby.material.color.set(0x00ff00)
    @hp -= 1
    if @hp <= 0
        dead
    end
  end
  def nohit
    @ruby.material.color.set(0xff0000)
  end
  def dead
    @scene.remove(@ruby)
    @bullets.each do |bullet|
      @scene.remove(bullet.mesh2)
    end
    @bullets.delete_if do |bullet|
      1
    end
    @flag = 0
  end

  def rotate
    @ruby.rotation.y += 0.5
  end

def updatehit
    if @hitf == 0
        @hitc+=1
        if @hitc >= 60
            @hitf =1
            @hitc = 0
            nohit
        end
    end
end

    def update
        @ruby.rotation.y += 0.5
    end
end