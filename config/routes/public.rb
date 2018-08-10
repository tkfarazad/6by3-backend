# frozen_string_literal: true

resources :coaches, only: %i[index show]
resources :video_categories, only: %i[index show]
