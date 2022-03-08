class Bullet
  attr_accessor :mesh

  def initialize(x, y, z)
    @mesh = Mittsu::Mesh.new(
      Mittsu::BoxGeometry.new(sizeX, sizeY, sizeZ),
      Mittsu::MeshBasicMaterial.new(color: col)
    )
    @mesh.position.set(x, y, z)
    @speedZ = 0.5
  end

  def update
    @mesh.position.z += @speedZ
  end
end