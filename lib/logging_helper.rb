module LoggingHelper
  def warn_logging(message, &block)
    separator = '*' * 15
    Rails.logger.warn "#{separator} - START of WARN: #{message} - #{separator}"
    block.call if block_given?
    Rails.logger.warn "#{separator} - END of WARN - #{separator}"
  end

  def info_logging(message, &block)
    separator = '*' * 10
    Rails.logger.info "#{separator} - START of INFO: #{message} - #{separator}"
    block.call if block_given?
    Rails.logger.info "#{separator} - END of INFO - #{separator}"
  end

  def debug_logging(message, &block)
    separator = '*' * 5
    Rails.logger.debug "#{separator} - START of DEBUG: #{message} - #{separator}"
    block.call if block_given?
    Rails.logger.debug "#{separator} - END of DEBUG - #{separator}"
  end
end
