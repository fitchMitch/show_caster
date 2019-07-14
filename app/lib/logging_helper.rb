# frozen_string_literal: true

module LoggingHelper
  module LogLevelMethods
    levels = %w[debug info warn error fatal]

    levels.each do |level|
      separator = '*' * 5

      define_method("#{level}_logging") do |message, &block|
        start_message = "#{separator} - START of #{level.to_s.upcase}" \
        ": #{message} - #{separator}"
        end_message = "#{separator} - END of #{level.to_s.upcase}" \
        " - #{separator}"
        eval 'Rails.logger.' + level + '("' + start_message + '")'
        instance_exec(&block) if block.present?
        eval 'Rails.logger.' + level + '("' + end_message + '")'
      end
    end
  end
  def self.included(klass)
    klass.extend LogLevelMethods
  end
end
