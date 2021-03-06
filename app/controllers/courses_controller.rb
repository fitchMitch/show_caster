# frozen_string_literal: true

class CoursesController < EventsController
  before_action :set_polymorphic_courseable_out_of_params,
                only: %i[create update]
  before_action :set_event,
                only: %i[show edit update destroy]

  def new
    authorize(Course)
    @event = Course.new( {
        duration: Course::COURSE_DURATION,
        event_date: next_course_day
    })
    @is_coach = false
    @is_autocoached = '1'
  end

  def next_course_day
    latest_course = Course.all
                          .order(event_date: :ASC)
                          .last
    if latest_course.try(:event_date).nil?
      Date.today
    else
      latest_course.event_date
                   .beginning_of_day
                   .advance(days: 7, hours: Course::COURSE_HOUR_START)

    end
  end

  def edit
    @selected_user_id = @event.courseable.id
    @is_coach = @event.courseable.is_a? Coach
    @is_autocoached = (@event.courseable.is_a? Coach) ? '0' : '1'
  end

  def index
    authorize(Course)
    @events = if params[:direction] == 'previous'
                Event.courses.passed_events.page params[:page]
              else
                Event.courses.future_events.page params[:page]
              end
  end

  def create
    @event = Course.new(event_params)
    authorize @event

    @event.user_id = current_user.id

    if @event.save
      NotificationService.course_creation(@event)
      redirect_to events_url(@event),
                  notice: I18n.t('performances.created')
    else
      respond_to do |format|
        format.html { render :new }
      end
    end
  end

  def set_polymorphic_courseable_out_of_params
    course = params.fetch(:course, nil)
    return if course.nil?

    if course.fetch(:is_autocoached, '1') == '1'
      params['course']['courseable_type'] = 'User'
      params['course']['courseable_id'] = course.fetch(:users_list, 0)
    else
      params['course']['courseable_type'] = 'Coach'
      params['course']['courseable_id'] = course.fetch(:coaches_list, 0)
    end
  end

  private

  def set_event
    @event = Event.unscoped.send(set_type.pluralize).find_by(id: params[:id])
    authorize @event
  end

  def event_params
    params
      .require(set_type.to_sym)
      .permit(
        :event_date,
        :title,
        :duration,
        :note,
        :user_id,
        :theater_id,
        :type,
        :courseable_type,
        :courseable_id,
        :private_event
      )
  end
end
