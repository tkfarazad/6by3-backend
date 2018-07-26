# frozen_string_literal: true

return if Rails.env.test?

if VideoCategory.empty?
  VideoCategory.multi_insert(
    [
      {name: 'Fusion Flow'},
      {name: 'Core 45'},
      {name: 'Follow The Yogi'},
      {name: 'Yin Fusion Flow'}
    ]
  )
end
