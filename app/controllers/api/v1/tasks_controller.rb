class Api::V1::TasksController < ApplicationController
  def index
    tasks = current_user.tasks
    render json: { tasks: tasks }, status: 200
  end

  def show
    tasks = current_user.tasks.find(params[:id])
    render json: tasks, status: 200
  end

  def create
    task = current_user.tasks.new(task_params)
    if task.save
      render json: task, status: 201
    else
      render json: {errors: task.errors }, status: 422
    end
  end

  private

  def task_params
    params.require(:task).permit(:title, :description, :deadline, :done)
  end
end
