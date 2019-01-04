require 'rails_helper'
# require 'icons_helper'
RSpec.describe LoggingHelper do
  # let(:a_block) { Proc.new { |x| x == 1 } }
  let(:a_logger) { double('logger') }
  subject(:an_instance) { MailchimpService }
  describe '#warn_logging' do
    let!(:message) { 'warn message' }
    before do
      allow(Rails).to receive(:logger) { a_logger }
    end
    it 'it should execute a block when given' do
      allow(a_logger).to receive(:warn) { 'logging_done' }
      expect{ |b| an_instance.warn_logging('message', &b)}.to yield_control
    end
    it 'it should log the message' do
      allow(a_logger).to receive(:warn).with(
        "***** - END of WARN - *****"
      )
      expect(a_logger).to receive(:warn).with(
        "***** - START of WARN: warn message - *****"
      )
      an_instance.warn_logging(message)
    end
  end

  describe '#info_logging' do
    let!(:message) { 'info message' }
    before do
      allow(Rails).to receive(:logger) { a_logger }
    end
    it 'it should execute a block when given' do
      allow(a_logger).to receive(:info) { 'logging_done' }
      expect{ |b| an_instance.info_logging('message', &b)}.to yield_control
    end
    it 'it should log the message' do
      allow(a_logger).to receive(:info).with(
        "***** - END of INFO - *****"
      )
      expect(a_logger).to receive(:info).with(
        "***** - START of INFO: info message - *****"
      )
      an_instance.info_logging(message)
    end
  end

  describe '#debug_logging' do
    let!(:message) { 'debug message' }
    before do
      allow(Rails).to receive(:logger) { a_logger }
    end
    it 'it should execute a block when given' do
      allow(a_logger).to receive(:debug) { 'logging_done' }
      expect{ |b| an_instance.debug_logging('message', &b)}.to yield_control
    end
    it 'it should log the message' do
      allow(a_logger).to receive(:debug).with(
        "***** - END of DEBUG - *****"
      )
      expect(a_logger).to receive(:debug).with(
        "***** - START of DEBUG: debug message - *****"
      )
      an_instance.debug_logging(message)
    end
  end

  describe '#fatal_logging' do
    let!(:message) { 'fatal message' }
    before do
      allow(Rails).to receive(:logger) { a_logger }
    end
    it 'it should execute a block when given' do
      allow(a_logger).to receive(:fatal) { 'logging_done' }
      expect { |b| an_instance.fatal_logging('message', &b) }.to yield_control
    end
    it 'it should log the message' do
      allow(a_logger).to receive(:fatal).with(
        "***** - END of FATAL - *****"
      )
      expect(a_logger).to receive(:fatal).with(
        "***** - START of FATAL: fatal message - *****"
      )
      an_instance.fatal_logging(message)
    end
  end

  describe '#error_logging' do
    let!(:message) { 'error message' }
    before do
      allow(Rails).to receive(:logger) { a_logger }
    end
    it 'it should execute a block when given' do
      allow(a_logger).to receive(:error) { 'logging_done' }
      expect { |b| an_instance.error_logging('message', &b) }.to yield_control
    end
    it 'it should log the message' do
      allow(a_logger).to receive(:error).with(
        '***** - END of ERROR - *****'
      )
      expect(a_logger).to receive(:error).with(
        '***** - START of ERROR: error message - *****'
      )
      an_instance.error_logging(message)
    end
  end
end
