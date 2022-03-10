require 'mittsu'
require_relative 'enemy.rb'
require_relative 'game.rb'

SCREEN_WIDTH = 800
SCREEN_HEIGHT = 600
ASPECT = SCREEN_WIDTH.to_f / SCREEN_HEIGHT.to_f

renderer = Mittsu::OpenGLRenderer.new width: SCREEN_WIDTH, height: SCREEN_HEIGHT, title: 'ex'
scene = Mittsu::Scene.new

#カメラ
camera = Mittsu::PerspectiveCamera.new(75.0, ASPECT, 0.1, 1000.0)

#敵
enemys=[]
5.times do 
    enemy = Enemy.new(0,rand(1..5),0,renderer,scene)
    enemys << enemy
end

#プレイヤー
player = Mittsu::Mesh.new(
    Mittsu::BoxGeometry.new(1, 1, 1),
    Mittsu::MeshBasicMaterial.new(color: 0x00ff00)
  )
player.position.set(0.0,0.0,10.0)

#bullets = []
  
scene.add(player)
player.add(camera)#プレイヤーにカメラをセット 一人称

timecount=0#フレーム数計測
renderer.window.run do
    player.position.y += 0.1 if renderer.window.key_down?(GLFW_KEY_UP)
    player.position.y -= 0.1 if renderer.window.key_down?(GLFW_KEY_DOWN)
    player.position.x -= 0.1 if renderer.window.key_down?(GLFW_KEY_LEFT)
    player.position.x += 0.1 if renderer.window.key_down?(GLFW_KEY_RIGHT)
    player.position.z += 0.1 if renderer.window.key_down?(GLFW_KEY_Z)
    player.position.z -= 0.1 if renderer.window.key_down?(GLFW_KEY_X)
    timecount+=1

    # renderer.window.on_key_released do GLFW_KEY_SPACE #プレイヤ－の弾
    #     bullet = Mittsu::Mesh.new(
    #     Mittsu::BoxGeometry.new(1.0, 1.0, 1.0),
    #     Mittsu::MeshBasicMaterial.new(color: 0x00f6000),
    #     )
    #     bullet.position.set(player.position.x , player.position.y - 1, player.position.z)
    #     scene.add(bullet)
    #     bullets << bullet
    # end

    # bullets.each do |bullet|
    #     bullet.position.z -= 1
    # end

    enemys.each do |enemy|
        enemy.bullets.each do |bullet|
            bullet.update2
        end
    end
    
    if timecount == 75
        enemys.each do |enemy|
            enemys.update

            enemy.fire#敵の攻撃
        end
    end

    if timecount > 225
        timecount = 0
    end

    renderer.render(scene, camera)
end