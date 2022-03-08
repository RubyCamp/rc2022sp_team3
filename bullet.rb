class Bullet
  attr_accessor :mesh,:mesh2

  def initialize(x, y, z)
    @x,@y,@z = x,y,z
    @mesh = Mittsu::Mesh.new(
      Mittsu::SphereGeometry.new(2.0, 2.0, 2.0),
      Mittsu::MeshPhongMaterial.new(color: 0x00ff00)
    )
    @mesh.position.set(x, y, z)

    @mesh2 = Mittsu::Mesh.new(
      Mittsu::SphereGeometry.new(0.5, 0.5, 0.5),
      Mittsu::MeshBasicMaterial.new(color: 0x55ff0)
    )
    @mesh2.position.set(@x, @y, @z)

    @speedZ = 0.5
  end

  def update
    @mesh.position.z -= @speedZ
  end

  def update2
    @mesh2.position.z += @speedZ
  end
  end