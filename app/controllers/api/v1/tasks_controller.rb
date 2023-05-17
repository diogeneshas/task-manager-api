class Api::V1::TasksController < ApplicationController
  def index
    tasks = current_user.tasks
    render json: { tasks: tasks }, status: 200
  end

  def show
    tasks = current_user.tasks.find(params[:id])
    render json: tasks, status: 200
  end
end
