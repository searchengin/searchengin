namespace :user do
  task set_user_type_for_existing_users: :environment do
    Domain.all.pluck(:domain).each do |dom|
      User.find_by(username: dom).update_attribute(:user_type, 1)
    end
  end
end
