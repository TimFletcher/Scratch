
module Scratch::Concerns::Nilify

  extend ActiveSupport::Concern

  module ClassMethods
    def nilify(options = {})
      options = HashWithIndifferentAccess.new options

      %w(except only).each do |key|
        options[key] = Array.wrap(options[key]).map &:to_s if options[key]
      end

      attributes = options[:only] || content_columns.map(&:name)
      attributes = attributes - options[:except] if options[:except]

      pred     = options[:pred]   || :blank?
      before   = options[:before] || :validation
      callback = "nilify_before_#{before}_if_#{pred}"

      instance_eval do
        define_method callback do
          attributes.each do |attribute|
            value = send(attribute)
            send("#{attribute}=", nil) if value.send(pred)
          end
        end

        send "before_#{before}", callback
      end
    end
  end

end

ActiveRecord::Base.send :include, Scratch::Concerns::Nilify
