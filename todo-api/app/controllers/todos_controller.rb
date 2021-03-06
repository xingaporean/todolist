class TodosController < ApplicationController
  def index
  	todos = Todo.order("created_at ASC")
  	render json: todos, include: :tags 
  end

  def create
  	todo = Todo.create(todo_params)
    todo.tags = tags_params.map{|tag| Tag.where(name: tag).first_or_create!(name: tag)}
  	if !todo.valid?
      render json: todo[:error], status: 422 and return
    end
    render json: todo
  end

  def show
    todo = Todo.find(params[:id])
    render json: todo, include: :tags
  end

  def update
  	todo = Todo.find(params[:id])
  	todo.update(todo_params)
    if !todo.tags.nil?
      todo.tags = tags_params.map{|tag| Tag.where(name: tag).first_or_create!(name: tag)}
    end
  	render json: todo, include: :tags
  end

  def destroy
  	todo = Todo.find(params[:id])
  	todo.destroy
  	head :no_content, status: :ok
  end

  private
  	def todo_params
  	  params.require(:todo).permit(:title, :done, :comment)
  	end
    def tags_params
      params['tags'].nil? || params['tags'].empty? ? [] : params.require(:tags)
    end

end
