require 'mittsu'
require_relative 'enemy.rb'


SCREEN_WIDTH = 800
SCREEN_HEIGHT = 600
ASPECT = SCREEN_WIDTH.to_f / SCREEN_HEIGHT.to_f

renderer = Mittsu::OpenGLRenderer.new width: SCREEN_WIDTH, height: SCREEN_HEIGHT, title: 'ex'

scene = Mittsu::Scene.new

#カメラ
camera = Mittsu::PerspectiveCamera.new(75.0, ASPECT, 0.1, 1000.0)
camera.position.x = 0
camera.position.y = 0
camera.position.z = 0

#敵
enemys=[]
5.times do
enemy = Enemy.new(1,rand(4),1,renderer,scene)
    enemys<<enemy #配列に代入
end

#プレイヤー
player = Mittsu::Mesh.new(
    Mittsu::BoxGeometry.new(1, 1, 1),
    Mittsu::MeshBasicMaterial.new(color: 0x00ff00)
  )
player.position.set(0.0,0.0,10.0)

  
scene.add(player)
player.add(camera)#プレイヤーにカメラをセット 一人称

timecount = 0
renderer.window.run do
    player.position.y += 0.1 if renderer.window.key_down?(GLFW_KEY_UP)
    player.position.y -= 0.1 if renderer.window.key_down?(GLFW_KEY_DOWN)
    player.position.x -= 0.1 if renderer.window.key_down?(GLFW_KEY_LEFT)
    player.position.x += 0.1 if renderer.window.key_down?(GLFW_KEY_RIGHT)
    player.position.z += 0.1 if renderer.window.key_down?(GLFW_KEY_Z)
    player.position.z -= 0.1 if renderer.window.key_down?(GLFW_KEY_X)
    timecount +=1
    
    if timecount == 120
      enemys.each do |enemy|
        enemy.goforwerd
      end
    end

    if timecount > 250
      timecount = 0
    end

    

    
    renderer.render(scene, camera)#シーンをレンダリング
end