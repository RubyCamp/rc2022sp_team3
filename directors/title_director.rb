require_relative 'base'

module Directors
  # タイトル画面用ディレクター
  class TitleDirector < Base
    # 初期化
    def initialize(renderer, screen_width, screen_height)
      super
      # タイトル画面の次に遷移するシーンのディレクターオブジェクトを用意
      self.next_director = GameDirector.new(renderer, screen_width, screen_height)
      puts "タイトル#{self.next_director}"
      # タイトル画面の登場オブジェクト群を生成
      create_objects
    end

    # １フレーム分の進行処理
    def play
      # 説明用文字パネルを１フレーム分進行させる
      @description.play      
      self.renderer.clear
      self.renderer.render(
        self.scene,
        self.camera)
    end

    # キー押下（単発）時のハンドリング
    def on_key_pressed(glfw_key:)
      case glfw_key
        # SPACEキー押下で弾丸を発射
        when GLFW_KEY_SPACE
          puts "シーン遷移 → GameDirector"
          transition_to_next_director
      end
    end

    private

    # タイトル画面の登場オブジェクト群を生成
    def create_objects
      # 太陽光をセット
      @sun = LightFactory.create_sun_light
      self.scene.add(@sun)

      # タイトル文字パネルの初期表示位置（X座標）を定義
      start_x = -0.35


      # 説明文字列用のパネル作成
      # タイトル画面表示開始から180フレーム経過で表示するように調整
      # 位置は適当に決め打ち
      @description = Panel.new(width: 1, height: 1, start_frame: 0, map: TextureFactory.create_texture_map("alpha-island_bk.png"))
      @description.mesh.position.y = -0.2
      @description.mesh.position.z = -0.5
      puts "#{@description}"
      self.scene.add(@description.mesh)
    end

    # タイトルロゴ用アニメーションパネル作成
    # タイトル画面の表示開始から30+delay_framesのフレームが経過してから、120フレーム掛けてアニメーションするよう設定
    def create_title_logo(char, x_pos, delay_frames)
      panel = AnimatedPanel.new(start_frame: 30 + delay_frames, duration: 120, map: TextureFactory.create_string(char))
      panel.mesh.position.x = x_pos
      panel.mesh.position.z = -0.5
      self.scene.add(panel.mesh)
      @panels ||= []
      @panels << panel
    end
  end
end