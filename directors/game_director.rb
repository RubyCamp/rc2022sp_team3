require_relative 'base'

module Directors
	# ゲーム本編のディレクター
	class GameDirector < Base
		CAMERA_ROTATE_SPEED_X = 0.01
		CAMERA_ROTATE_SPEED_Y = 0.01

		# 初期化
		def initialize(renderer, screen_width, screen_height)
			super
			# ゲーム本編の次に遷移するシーンのディレクターオブジェクトを用意
			self.next_director = EndingDirector.new(renderer, screen_width, screen_height)

			# ゲーム本編の登場オブジェクト群を生成
			
			@renderer = renderer
			renderer.auto_clear = false
		
			# 体力ゲージ描画を要微調整 #
		
			@widget_scene = Mittsu::Scene.new
			@widget_camera = Mittsu::OrthographicCamera.new(screen_width / 2.0, -screen_width / 2.0, screen_height / 2.0, -screen_height / 2.0, 0.0, 1.0)
			@scene = Mittsu::Scene.new
			@camera = Mittsu::PerspectiveCamera.new(75.0, ASPECT, 0.1, 1000.0)
			@hitpoint = 100
		
			@mesh = Mittsu::Mesh.new(
			  Mittsu::BoxGeometry.new(5.0, @hitpoint, 0),
			  Mittsu::MeshBasicMaterial.new(color: 0xffff00)
			)
			@mesh.scale.set(2, 2, 2)
			@mesh.position.set(-400, -256, 10)
			@widget_scene.add(@mesh)
		
			@camera.position.z = 10.0
			@widget_camera.position.z = 10.0
			@score = Score.new(screen_width, screen_height)
			@time_count = 0
			@flag = 0
			
			@enemies = []
			@bullets = []
			10.times do
			  @enemy = Enemy.new((rand(1..5) - 3).to_f, (rand(1..5) -3).to_f, 0.0, @renderer, @scene)
			  @scene.add(@enemy.mesh)
			  @enemies << @enemy
			end
			
			@player = Player.new(0.0, 0.0, 10.0, @renderer, @scene, @score, @hitpoint)
			@scene.add(@player.mesh)
			@player.mesh.add(@camera)
		  end

		  def play
			@player.update
			@time_count += 1

			#敵弾の移動
			@enemies.each do |enemy|
				enemy.bullets.each do |bullet|
					bullet.update2
				end
			end
			#flagが0のenemyを削除#
			@enemies.delete_if  do |enemy|
				enemy.flag == 0
			end

			#5以上の敵を倒していたら敵を追加
			if @player.killcount >= 5
				5.times do |i|
					@enemy = Enemy.new(i, (rand(1..5) -3).to_f, 0.0, @renderer, @scene)
					@scene.add(@enemy.mesh)
					@enemies << @enemy
				end
				@player.killcount = 0
			end
	  
			@enemies.each do |enemy|
			  if @time_count % 20 == 0
				#enemy.fire
				#enemy.update
			  elsif @time_count == 120
			    enemy.update2
			  else
				#
			  end
			end
			if @time_count > 100
			  @time_count = 0
			end

			@player.check(@enemies) # 動作済み #
			@player.check2(@enemies)# 動作済み #
			@enemies.each do |enemy|# 動作済み #
			  @player.check3(enemy.bullets) 
			end
			@score.update_points
			@player.update_hitpoints
			#@renderer.clear
			@renderer.render(@widget_scene, @widget_camera)
			@renderer.render(@scene, @camera)
			@renderer.render(@score.scene, @score.camera)
		end		
	end
end