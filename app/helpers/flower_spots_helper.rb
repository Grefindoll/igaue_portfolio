module FlowerSpotsHelper
  def parking_options_for_select
    options = FlowerSpot.parkings.keys.map do |key|
      # I18n.t を使って日本語の表示名を取得します。
      [I18n.t("activerecord.attributes.flower_spot.parkings.#{key}", default: key.to_s.humanize), key]
    end
    # 先頭に「指定なし」の選択肢を追加
    [["指定なし", ""]] + options
  end

  def fee_type_options_for_select
    options = FlowerSpot.fee_types.keys.map do |key|
      # 同様に fee_type も修正します。
      [I18n.t("activerecord.attributes.flower_spot.fee_types.#{key}", default: key.to_s.humanize), key]
    end
    # 先頭に「指定なし」の選択肢を追加
    [["指定なし", ""]] + options
  end
end
