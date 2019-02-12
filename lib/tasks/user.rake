namespace :user do
  task set_user_type_for_existing_users: :environment do
    Domain.all.pluck(:domain).each do |dom|
      User.find_by(username: dom).update_attribute(:user_type, 1)
    end
  end

  task set_user_handle_for_existing_regular_users: :environment do
    User.by_non_domain.where(handle: nil).each do |user|
      user.set_user_handle
      user.save!
    end
  end
end
