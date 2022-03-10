require 'mittsu'

require_relative 'player'
require_relative 'enemy'
require_relative 'score'

Dir.glob("directors/*.rb") {|path| require_relative path }

SCREEN_WIDTH = 1024
SCREEN_HEIGHT = 768
ASPECT = SCREEN_WIDTH.to_f / SCREEN_HEIGHT.to_f

scene = Mittsu::Scene.new
camera = Mittsu::PerspectiveCamera.new(75.0, 1.333, 0.1, 1000.0)
renderer = Mittsu::OpenGLRenderer.new width: SCREEN_WIDTH, height: SCREEN_HEIGHT, title: 'GAME:るーびっく'

cube_map_texture = Mittsu::ImageUtils.load_texture_cube(
  [ 'rt', 'lf', 'up', 'dn', 'bk', 'ft' ].map { |path|
    File.join File.dirname(__FILE__), 'images',"alpha-island_#{path}.png"
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

# 
director = Directors::TitleDirector.new(renderer, SCREEN_WIDTH, SCREEN_HEIGHT)

# キー押下時のイベントハンドラを登録
renderer.window.on_key_pressed do |glfw_key|
	director.on_key_pressed(glfw_key: glfw_key)
end


# オープニング画面とゲームクリア画面の追加(画面遷移込み) #
# (出来れば)"Retry" "Exit"ボタン?を追加 #
renderer.window.run do
  # ※ これによって、シーン切替を実現している。メカニズムの詳細はdirectors/base.rb参照
	director = director.current_director
  director.play
  renderer.render(scene, camera)
end