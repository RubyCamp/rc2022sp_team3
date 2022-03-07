require 'mittsu'

SCREEN_WIDTH = 800
SCREEN_HEIGHT = 600


scene = Mittsu::Scene.new
camera = Mittsu::PerspectiveCamera.new(75.0, 1.333, 0.1, 1000.0)
renderer = Mittsu::OpenGLRenderer.new width: 1024, height: 768, title: 'RubyCamp 2022'

bullets = []

i = 0

renderer.window.on_key_pressed do |glfw_key|
  if glfw_key == GLFW_KEY_SPACE
    geometry = Mittsu::SphereGeometry.new(0.5, 8, 8)
    material = Mittsu::MeshBasicMaterial.new(color: 0xff0000)
    bullet = Mittsu::Mesh.new(geometry, material)
    scene.add(bullet)
    bullets << bullet
    i += 1
    puts "#{i}"
  end
end

camera.position.x = 3
camera.look_at(Mittsu::Vector3.new(0, 0, -3))

renderer.window.run do
  bullets.each do |bullet|
    bullet.position.z -= 0.5
  end

  renderer.render(scene, camera)
end
