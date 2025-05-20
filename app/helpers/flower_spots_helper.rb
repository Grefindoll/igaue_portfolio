module FlowerSpotsHelper
  # フォーム用：選択肢を日本語に変換
  # 配列の2番目の要素（key）が「実際にフォームから送られる値」。①コントローラー→②モデルで変換→③データベースに保存 という順番で変換されていく
  def parking_options_for_select
    options = FlowerSpot.parkings.keys.map do |key|
      [I18n.t("activerecord.attributes.flower_spot.parkings.#{key}", default: key.to_s.humanize), key]
    end
  end

  def fee_type_options_for_select
    options = FlowerSpot.fee_types.keys.map do |key|
      [I18n.t("activerecord.attributes.flower_spot.fee_types.#{key}", default: key.to_s.humanize), key]
    end
  end
end
