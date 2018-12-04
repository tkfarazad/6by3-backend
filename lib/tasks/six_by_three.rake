# frozen_string_literal: true

namespace :six_by_three do
  task set_duration_for_videos: :environment do
    Video.where(duration: nil).each do |video|
      video.update(
        duration: FFMPEG::Movie.new(video.content.url).duration
      )
    end
  end

  task actualize_user_plan_types: :environment do
    ActualizeUserPlanTypesJob.perform_later
  end

  namespace :customerio do
    task identify_users: :environment do
      Customerio::IdentifyUsersJob.perform_later
    end
  end
end
