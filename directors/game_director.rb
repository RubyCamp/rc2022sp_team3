require_relative 'base'

module Directors
	# ゲーム本編のディレクター
	class GameDirector < Base
		CAMERA_ROTATE_SPEED_X = 0.01
		CAMERA_ROTATE_SPEED_Y = 0.01

		# 初期化
		def initialize(renderer, screen_width, screen_height)
			super

			@bossflg = false

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

			10.times do
				@enemy2 = Enemy.new((rand(1..5) - 3).to_f, (rand(1..5) -3).to_f, -30.0, @renderer, @scene)
				# @scene.add(@enemy.mesh2)
				@enemies << @enemy2
			  end
		  
			@ruby = Enemy.new((rand(1..5) - 3).to_f, (rand(1..5) - 3).to_f, -50.0, @renderer, @scene)
			# @scene.add(@ruby.ruby)
			
			@player = Player.new(0.0, 0.0, 10.0, @renderer, @scene, @score, @hitpoint)
			@scene.add(@player.mesh)
			@player.mesh.add(@camera)
		  end
		
		  def play
			@player.update

			if @player.mesh.position.z == -20 && @flag == 0
			  @scene.add(@enemy2.mesh2)
			  @flag = 1
			elsif @player.mesh.position.z == -40 && @flag == 1
			  @scene.add(@ruby.ruby)
			  @flag = 2
			else
			  #
			end

			@time_count += 1
		
			puts "#{@time_count}, (#{@player.mesh.position.x}, #{@player.mesh.position.y}, #{@player.mesh.position.z}), #{@player.hitpoint} ,#{@score.points}"

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
			#bossを削除
			if @bossflg == true
				if @boss.flag == 0
					@scene.remove(@boss)
					puts "gameclear"
				end
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
	  
			# よりゲーム性を上げるように処理を増やす #
			#ボスの処理↓
			if @bossflg == true
				@player.check4(@boss)
				@boss.updatehit
				if @time_count % 20 == 0
						#@boss.fire
						@boss.update
				end
				@boss.bullets.each do |bullet|
					bullet.updete2
				end
			end
			#ボス処理終わり↑

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
				if @bossflg == false
				@boss = Boss.new(0,0,0,@renderer,@scene)
				@bossflg = true
				end
			  @time_count = 0
			end


		
			@player.check(@enemies) # 動作済み #
			@player.check2(@enemies)# 動作済み #
			@enemies.each do |enemy|# 動作済み #
			  @player.check3(enemy.bullets) 

			end
			@score.update_points
			@player.update_hitpoints
		
			@renderer.clear
			@renderer.render(@widget_scene, @widget_camera)
			@renderer.render(@scene, @camera)
			@renderer.render(@score.scene, @score.camera)
		end
		
		
		# キー押下（単発）時のハンドリング
		def on_key_pressed(glfw_key:)
			case glfw_key
				# ESCキー押下でエンディングに無理やり遷移
				when GLFW_KEY_ESCAPE
					puts "シーン遷移 → EndingDirector"
					transition_to_next_director

				# SPACEキー押下で弾丸を発射
				when GLFW_KEY_SPACE
					shoot
			end
		end
	end
end