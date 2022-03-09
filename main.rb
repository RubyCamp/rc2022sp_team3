require 'mittsu'
require_relative 'game'

SCREEN_WIDTH = 1024
SCREEN_HEIGHT = 768
ASPECT = SCREEN_WIDTH.to_f / SCREEN_HEIGHT.to_f

scene = Mittsu::Scene.new
camera = Mittsu::PerspectiveCamera.new(75.0, 1.333, 0.1, 1000.0)

# 全体で共通のレンダラーを生成
renderer = Mittsu::OpenGLRenderer.new width: SCREEN_WIDTH, height: SCREEN_HEIGHT, title: 'Sample Game'

# 初期シーンのディレクターオブジェクトを生成
director = Directors::TitleDirector.new(screen_width: SCREEN_WIDTH, screen_height: SCREEN_HEIGHT, renderer: renderer)

# キー押下時のイベントハンドラを登録
renderer.window.on_key_pressed do |glfw_key|
	director.on_key_pressed(glfw_key: glfw_key)
end

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

game = Game.new(renderer, SCREEN_WIDTH, SCREEN_HEIGHT)

renderer.window.run do
  game.play
  renderer.render(scene, camera)
  # 現在のディレクターオブジェクトに、処理対象となるディレクターオブジェクトを返させる
	# ※ これによって、シーン切替を実現している。メカニズムの詳細はdirectors/base.rb参照
	director = director.current_director

	# 処理対象のディレクターオブジェクトが返ってこない（nilが返ってくる）場合はメインループを抜ける
	break unless director

	# １フレーム分、最新のディレクターオブジェクトを進行させる
	director.play

	# 現在のディレクターオブジェクトが保持するシーンを、同じく現在のディレクターオブジェクトが持つカメラでレンダリング
	renderer.render(
		director.scene,
		director.camera)

end