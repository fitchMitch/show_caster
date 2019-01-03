require 'rails_helper'
# sidekiq
require 'sidekiq/testing'
Sidekiq::Testing.fake!  # by default it is fake

RSpec.describe ReminderMailJob, type: :job do
  include ActiveJob::TestHelper

  subject(:job) { described_class.perform_later(key) }
  let(:key) { 123 }

  it 'queues the job' do
    expect { job }.to have_enqueued_job(described_class)
      .with(key)
      .on_queue('mailers')
  end

  it 'is in mailers queue' do
    expect(ReminderMailJob.new.queue_name).to eq('mailers')
  end

  it 'executes perform' do
    expect(NotificationService).to receive(:poll_reminder_mailing).with(123)
    perform_enqueued_jobs { job }
  end

  after do
    clear_enqueued_jobs
    clear_performed_jobs
  end
end
