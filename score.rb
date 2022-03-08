class Score
    attr_accessor :scene, :camera, :points
  
    def initialize(screen_width, screen_height)
      @camera = Mittsu::OrthographicCamera.new(-screen_width / 2.0, screen_width / 2.0, screen_height / 2.0, -screen_height / 2.0, 0.0, 1.0)
      @scene = Mittsu::Scene.new
      @scene2 = Mittsu::Scene.new
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

      geometry = Mittsu::BoxGeometry.new(2.0, @hitpoint, 0.0)
      material = Mittsu::SpriteMaterial.new(geometry: geometry, color: 0xffff00)
      sprite = Mittsu::Sprite.new(material)
      sprite.scale.set(128, -128, 0)
      sprite.position.set((screen_width / 2.0) + 64 + dx, (screen_height / 2.0) + 64, 0.0)
      @scene2.add(sprite)
        
    end
  
    def update_points
      sprintf("%03d", @points).chars.each_with_index do |point, index|
        map = Mittsu::ImageUtils.load_texture("images/#{point}.png")
        sprite = @digits[index]
        sprite.material.set_values(map: map)
        material = Mittsu::SpriteMaterial.new(map: map)
      end
    end

    # def update_hitpoints
    # end  

  end
  
