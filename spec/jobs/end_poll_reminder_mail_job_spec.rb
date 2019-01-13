require 'rails_helper'


RSpec.describe ReminderPollEndJob, type: :job do
  include ActiveJob::TestHelper

  subject(:job) { described_class.perform_later(key) }
  let(:key) { 123 }
  before :each do
    allow(Poll).to receive(:find_by) { key }
  end

  it 'queues the job' do
    expect { job }.to have_enqueued_job(described_class)
      .with(key)
      .on_queue('mailers')
  end

  it 'is in mailers queue' do
    expect(ReminderMailJob.new.queue_name).to eq('mailers')
  end

  it 'executes perform' do
    expect(NotificationFilter).to receive(:poll_end_reminder_mailing).with(123)
    perform_enqueued_jobs { job }
  end

  after do
    clear_enqueued_jobs
    clear_performed_jobs
  end
end
