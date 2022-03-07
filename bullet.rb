class Bullet
  attr_accessor :mesh,:speedX,:speedY,:speedZ

  def initialize(x, y, z, sizeX,sizeY,sizeZ,col,speedX,speedY,speeedZ)
    @mesh = Mittsu::Mesh.new(
      Mittsu::BoxGeometry.new(sizeX, sizeY, sizeZ),
      Mittsu::MeshBasicMaterial.new(color: col)
    )
    @mesh.position.set(x, y, z)
    @speedX = speedX
    @speedY = speedY
    @speedZ = speedZ
  end

  def update
    @mesh.position.x += @speedX
    @mesh.position.y += @speedY
    @mesh.position.z += @speedZ
  end
end