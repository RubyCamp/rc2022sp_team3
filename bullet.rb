class Bullet
  attr_accessor :mesh,:mesh2

  def initialize(x, y, z)
    @x,@y,@z=x,y,z
    @mesh = Mittsu::Mesh.new(
      Mittsu::CircleGeometry.new(1.0, 32, 32),
      Mittsu::MeshBasicMaterial.new(color: 0x00ff00)
    )
    @mesh.position.set(@x, @y, @z)

    @mesh2 = Mittsu::Mesh.new(
      Mittsu::SphereGeometry.new(0.5, 32, 32),
      Mittsu::MeshBasicMaterial.new(color: 0xff0000)
    )
    @mesh2.position.set(@x, @y, @z)

    @speedZ = 1.0
  end

  def update
    @mesh.position.z -= @speedZ
  end

  def update2
    @mesh2.position.z += 1.0
  end
end



