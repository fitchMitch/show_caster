class PollSecretBallotsController < PollOpinionsController
  before_action :set_poll, only: %i[show edit update destroy]
end
