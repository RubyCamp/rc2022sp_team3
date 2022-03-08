class Bullet
  attr_accessor :mesh

  def initialize(x, y, z)
    @mesh = Mittsu::Mesh.new(
      Mittsu::BoxGeometry.new(2.0, 2.0, 2.0),
      Mittsu::MeshBasicMaterial.new(color: 0x00ff00)
    )
    @mesh.position.set(x, y, z)
    @speedZ = 0.5
  end

  def update
    @mesh.position.z -= @speedZ
  end
end