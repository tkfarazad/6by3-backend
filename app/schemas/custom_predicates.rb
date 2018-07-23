# frozen_string_literal: true

module CustomPredicates
  include Dry::Logic::Predicates

  predicate(:email?) do |value|
    !/.*@.*/.match(value).nil?
  end

  predicate(:file?) do |value|
    value.instance_of?(ActionDispatch::Http::UploadedFile)
  end

  predicate(:image?) do |value|
    file?(value) && ::SixByThree::Constants::AVAILABLE_UPLOAD_IMAGE_CONTENT_TYPES.include?(value.content_type)
  end

  predicate(:video?) do |value|
    file?(value) && ::SixByThree::Constants::AVAILABLE_UPLOAD_VIDEO_CONTENT_TYPES.include?(value.content_type)
  end
end
