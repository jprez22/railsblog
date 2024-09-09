class PostsController < ApplicationController
	#before_action :set_post, only: %i[ show edit update destroy ]
	before_action :authenticate_user!, except: [:index, :show]
	before_action :correct_user, only: [:edit, :update, :destroy]

	def index
		@posts = Post.all.order("created_at DESC")
	end

	def search
		@posts = Post.where(":title LIKE ?", "%" + params[:q] + "%")
	end

	def new
		#@post = Post.new
		@post = current_user.posts.build
	end

	def create
		#@post = Post.new(post_params)
		@post = current_user.posts.build(post_params)

		respond_to do |format|
	      	if @post.save
		        format.html { redirect_to post_path(@post), notice: "Post was successfully created." }
		        format.json { render :show, status: :created, location: @post }
	      	else
		        format.html { render :new, status: :unprocessable_entity }
		        format.json { render json: @post.errors, status: :unprocessable_entity }
      		end
    	end
	end

	def show
		@post = Post.find(params[:id])
	end

	def update

		respond_to do |format|
      		if @post.update(post_params)
        		format.html { redirect_to post_path(@post), notice: "Post was successfully updated." }
        		format.json { render :show, status: :ok, location: @post }
      		else
        		format.html { render :edit, status: :unprocessable_entity }
        		format.json { render json: @post.errors, status: :unprocessable_entity }
      		end
    	end

		#@post = Post.find(params[:id])

		#if @post.update(post_params)
			#redirect_to @post
		#else
			#render 'edit'
		#end

	end


	def edit
		@post = Post.find(params[:id])
	end

	def destroy
		@post = Post.find(params[:id])
		@post.destroy

		respond_to do |format|
      		format.html { redirect_to posts_path, notice: "Post was successfully destroyed." }
      		format.json { head :no_content }
		end
	end

	def correct_user
		@post = current_user.posts.find_by(id: params[:id])
		redirect_to posts_path, notice: "Not authorized to edit/delete this post" if @post.nil?
	end

	private
	
	def post_params
		params.require(:post).permit(:title, :content, :user_id)
	end

end
