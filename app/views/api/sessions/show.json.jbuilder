json.success true
if @user.present?
  json.user do
    json.id @user.id
    json.email @user.email
    json.login @user.login
    json.created_at l @user.created_at.in_time_zone
    json.updated_at l @user.updated_at.in_time_zone
  end
else
  json.user nil
end
