module V1
  class CourseSessionsController < ApplicationController
    before_action :authenticate_v1_user!
    before_action do
      @attributes = %i[name starting_date ending_date student_min student_max]
      @allow_only_params_for = {
        create:  [:course_id, :creator_id, course_session: @attributes],
        destroy: %i[course_id id],
        index:   %i[course_id page page_size],
        show:    %i[course_id id],
        update:  [:course_id, :id, course_session: @attributes]
      }
      deny_all_unpermitted_parameters
    end
    before_action :find_course_session, only: %i[show update destroy]
    before_action :current_course, only: %i[create index]
    before_action :current_organization, only: %i[create]

    def index
      # authorize [:v1, current_organization]
      # render json: @current_organization.created_sessions
      # TO BE CHANGED
      @sessions = current_course.sessions.order(created_at: :asc).page(params[:page]).per(params[:page_size])
      render json: @sessions, meta: pagination_dict(@sessions)
    end

    def show
      render json: @course_session
      # render json: LessonSerializer.new(lesson).serializable_hash[:data][:attributes]
    end

    def create
      # Choose between oneof the 2 way to write instruction (create or update)
      # lesson = current_v1_user.created_lessons.create!(create_params)
      course_session = CourseSession.create!(create_params.merge(course: current_course,
                                                                 creator: current_organization))
      render json: course_session, status: :created
    end

    def update
      # authorize [:v1, @course_session]
      @course_session.update!(update_params)
      render json: @course_session
    end

    def destroy
      # authorize [:v1, @course_session]
      @course_session.destroy
      head :no_content
    end

    private

    def create_params
      params.require(:course_session).permit(@attributes)
    end
    alias_method :update_params, :create_params

    def current_course
      params.require(:course_id)
      Course.find(params[:course_id])
    end

    def find_course_session
      @course_session = CourseSession.find(params[:id])
    end

    def current_organization
      params.require(:creator_id)
      Organization.find(params[:creator_id])
    end
  end
end
