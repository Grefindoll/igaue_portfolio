Geocoder.configure(
  # ジオコーディングサービスが応答しない場合の待ち時間（秒）
  timeout: 5,

  # 住所から緯度経度を検索するサービスを指定 (Google Maps API を利用)
  lookup: :google,

  # 結果の言語を日本語に設定
  language: :ja,

  # Google Maps API を利用する場合は HTTPS を使用
  use_https: true,

  # Rails Credentials からAPIキーを読み込む設定
  api_key: Rails.application.credentials.Maps_api_key,

  # 距離計算の単位をキロメートルに設定
  units: :km
)
