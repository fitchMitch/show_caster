module LoggingHelper
  def fatal_logging(message)
    separator = '%' * 15
    Rails.logger.fatal "#{separator} - START of FATAL: #{message} - #{separator}"
    yield if block_given?
    Rails.logger.fatal "#{separator} - END of FATAL - #{separator}"
  end

  def error_logging(message)
    separator = '=' * 15
    Rails.logger.error "#{separator} - START of ERROR: #{message} - #{separator}"
    yield if block_given?
    Rails.logger.error "#{separator} - END of ERROR - #{separator}"
  end

  def warn_logging(message)
    separator = '*' * 15
    Rails.logger.warn "#{separator} - START of WARN: #{message} - #{separator}"
    yield if block_given?
    Rails.logger.warn "#{separator} - END of WARN - #{separator}"
  end

  def info_logging(message)
    separator = '*' * 10
    Rails.logger.info "#{separator} - START of INFO: #{message} - #{separator}"
    yield if block_given?
    Rails.logger.info "#{separator} - END of INFO - #{separator}"
  end

  def debug_logging(message)
    separator = '*' * 5
    Rails.logger.debug "#{separator} - START of DEBUG: #{message} - #{separator}"
    yield if block_given?
    Rails.logger.debug "#{separator} - END of DEBUG - #{separator}"
  end
end
