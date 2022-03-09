require 'mittsu'

scene = Mittsu::Scene.new
camera = Mittsu::PerspectiveCamera.new(75.0, 1.333, 0.1, 1000.0)
renderer = Mittsu::OpenGLRenderer.new width: 800, height: 600, title: 'RubyCamp 2022'

cube_map_texture = Mittsu::ImageUtils.load_texture_cube(
  [ 'rt', 'lf', 'up', 'dn', 'bk', 'ft' ].map { |path|
    "alpha-island_#{path}.png"
  }
)

shader = Mittsu::ShaderLib[:cube]
shader.uniforms['tCube'].value = cube_map_texture

skybox_material = Mittsu::ShaderMaterial.new({
  fragment_shader: shader.fragment_shader,
  vertex_shader: shader.vertex_shader,
  uniforms: shader.uniforms,
  depth_write: false,
  side: Mittsu::BackSide
})

skybox = Mittsu::Mesh.new(Mittsu::BoxGeometry.new(100, 100, 100), skybox_material)
scene.add(skybox)

geom = Mittsu::SphereGeometry.new(0.5, 8, 8)
mat = Mittsu::MeshBasicMaterial.new(color: 0x00ff00)
mesh = Mittsu::Mesh.new(geom, mat)
scene.add(mesh)
mesh.position.z = -2

renderer.window.run do
  camera.position.x -= 0.1 if renderer.window.key_down?(GLFW_KEY_LEFT)
  camera.position.x += 0.1 if renderer.window.key_down?(GLFW_KEY_RIGHT)
  camera.look_at(mesh.position)
  renderer.render(scene, camera)
end