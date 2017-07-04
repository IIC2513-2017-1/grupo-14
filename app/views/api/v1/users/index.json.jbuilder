# frozen_string_literal: true

json.array! @users do |user|
    json.href api_v1_user_url(user)
    json.id user.id
    json.name user.name
    json.mail user.mail
end