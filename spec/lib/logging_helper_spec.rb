require 'rails_helper'
# require 'icons_helper'
RSpec.describe LoggingHelper do
  let(:a_block) { Proc.new { |x| x == 1 } }
  let(:a_logger) { double('logger') }
  describe '.warn_logging' do
    let!(:message) { 'warn message' }
    before do
      allow(Rails).to receive(:logger) { a_logger }
    end
    it 'it should execute a block when given' do
      allow(a_logger).to receive(:warn) { 'logging_done' }
      expect{ |b| MailchimpService.new.warn_logging('message', &b)}.to yield_control
    end
    it 'it should log the message' do
      allow(a_logger).to receive(:warn).with(
        "*************** - END of WARN - ***************"
      )
      expect(a_logger).to receive(:warn).with(
        "*************** - START of WARN: warn message - ***************"
      )
      MailchimpService.new.warn_logging(message)
    end
  end

  describe '.info_logging' do
    let!(:message) { 'info message' }
    before do
      allow(Rails).to receive(:logger) { a_logger }
    end
    it 'it should execute a block when given' do
      allow(a_logger).to receive(:info) { 'logging_done' }
      expect{ |b| MailchimpService.new.info_logging('message', &b)}.to yield_control
    end
    it 'it should log the message' do
      allow(a_logger).to receive(:info).with(
        "********** - END of INFO - **********"
      )
      expect(a_logger).to receive(:info).with(
        "********** - START of INFO: info message - **********"
      )
      MailchimpService.new.info_logging(message)
    end
  end

  describe '.debug_logging' do
    let!(:message) { 'debug message' }
    before do
      allow(Rails).to receive(:logger) { a_logger }
    end
    it 'it should execute a block when given' do
      allow(a_logger).to receive(:debug) { 'logging_done' }
      expect{ |b| MailchimpService.new.debug_logging('message', &b)}.to yield_control
    end
    it 'it should log the message' do
      allow(a_logger).to receive(:debug).with(
        "***** - END of DEBUG - *****"
      )
      expect(a_logger).to receive(:debug).with(
        "***** - START of DEBUG: debug message - *****"
      )
      MailchimpService.new.debug_logging(message)
    end
  end
end
