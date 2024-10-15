# config/schedule.rb

every 1.hour do
    runner "DeleteUnconfirmedUsersJob.perform_later"
  end
  