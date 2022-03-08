class Enemy
  attr_accessor :mesh

  def initialize(x, y, z, renderer, scene) #位置とをmainからもらう
    @mesh = Mittsu::Mesh.new(#メッシュにまとめて代入
      Mittsu::BoxGeometry.new(1.0, 1.0, 1.0),
      Mittsu::MeshBasicMaterial.new(color: 0x0000ff)
    )
    @mesh.position.set(x, y, z)

    @scene,@renderer = scene,renderer

    @scene.add(@mesh)

    @bullets = []
    @boxs = []
    @hitpoint
  end

  def fire
    @bullets << Enemybullet.new(x,y,z)    
  end

  def dead
    @boxs<< Box.new(x,y,z)
  end

  def goforwerd
    mesh.position.x += rand(2)
    mesh.position.z += rand(2)
  end

  def goback
    mesh.position.x -= rand(2)
    mesh.position.z -= rand(2)

  end

  def update


    # @mesh.rotation.x += 0.1
    # @mesh.rotation.y += 0.1
  end
end

class Enemybullet
  def initialize(x,y,z)
    @x,@y,@z = x,y,z
    @bullet = Mittsu::Mesh.new(
      Mittsu::SphereGeometry.new(1,1,1),
      Mittsu::MeshBasicMaterial.new(color: 0x0000ff)
    )
    @bullet.position.set(x,y,z)
  end

  def goforwerd
    @bullet.position.z += 1 
  end
end

class Box
  def initialize(x,y,z)
    @box = Mittsu::Mesh.new(
     Mittsu::BoxGeometry.new(1, 1, 1),
     Mittsu::MeshBasicMaterial.new(color: 0x000055)
    )
    @bullet.position.set(x,y,z)
    @scene.add(@box)
  end

end
