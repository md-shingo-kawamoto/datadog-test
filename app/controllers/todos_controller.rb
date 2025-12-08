class TodosController < ApplicationController
  before_action :set_todo, only: [:show, :edit, :update, :destroy, :toggle]

  def index
    @todos = Todo.recent
  end

  def show
  end

  def new
    @todo = Todo.new
  end

  def edit
  end

  def create
    @todo = Todo.new(todo_params)

    if @todo.save
      redirect_to todos_path, notice: 'TODOを作成しました。'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @todo.update(todo_params)
      redirect_to todos_path, notice: 'TODOを更新しました。'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @todo.destroy
    redirect_to todos_path, notice: 'TODOを削除しました。'
  end

  def toggle
    @todo.update(completed: !@todo.completed)
    redirect_to todos_path
  end

  private

  def set_todo
    @todo = Todo.find(params[:id])
  end

  def todo_params
    params.require(:todo).permit(:title, :description, :completed)
  end
end

