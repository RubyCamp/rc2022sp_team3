class Score
    attr_accessor :scene, :camera, :points
  
    def initialize(screen_width, screen_height)
      @camera = Mittsu::OrthographicCamera.new(-screen_width / 2.0, screen_width / 2.0, screen_height / 2.0, -screen_height / 2.0, 0.0, 1.0)
      @scene = Mittsu::Scene.new
      @points = 0
      @hitpoint = 100
      @digits = []
      dx = 64
  
      sprintf("%05d", @points).chars.each_with_index do |point, index|
        map = Mittsu::ImageUtils.load_texture("images/#{point}.png")
        material = Mittsu::SpriteMaterial.new(map: map)
        Mittsu::Sprite.new(material).tap do |sprite|
          sprite.scale.set(128, 128, 1.0)
          sprite.position.set(-(screen_width / 2.0) + 64 + dx * index, (screen_height / 2.0) - 64, 0.0)
          @scene.add(sprite)
          @digits << sprite
        end
      end
      
      # 体力ゲージを右下に描画#
      geometry = Mittsu::BoxGeometry.new(2.0, @hitpoint, 0.0)
      materia = Mittsu::SpriteMaterial.new(geometry: geometry, color: 0xffff00)
      Mittsu::Sprite.new(materia).tap do |sprite2|
        sprite2.scale.set(128, -256, 0)
        sprite2.position.set((screen_width / 2.0) + 64 + dx * 2, (screen_height / 2.0) + 64, 0.0)
        @scene.add(sprite2)
      end  
    end
  
    def update_points
      sprintf("%05d", @points).chars.each_with_index do |point, index|
        map = Mittsu::ImageUtils.load_texture("images/#{point}.png")
        sprite = @digits[index]
        sprite.material.set_values(map: map)
        material = Mittsu::SpriteMaterial.new(map: map)
      end
    end

     # 体力の処理 #
    # def update_hitpoints
    # end  

  end
  
