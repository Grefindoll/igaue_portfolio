# ゲストユーザーのメールアドレスとパスワードを定義
GUEST_USER_EMAIL = "guest@example.com"
GUEST_USER_PASSWORD = "password123"

# ゲストユーザーを探すか、なければ作成する。同じゲストユーザーが何回も造られないようにする。
User.find_or_create_by!(email: GUEST_USER_EMAIL) do |user|
  user.password = GUEST_USER_PASSWORD
  user.password_confirmation = GUEST_USER_PASSWORD
  user.username = "ゲスト"
  user.introduction = "ゲストとしてサイトの機能を試しています。"
end

puts "ゲストユーザー (email: #{GUEST_USER_EMAIL}) を作成または確認しました。"
