class AppsController < ApplicationController

	def new
		if params[:selected_app].present? && params[:project_name].present?
			MobileApp.clone_app(params[:selected_app], params[:project_name])
			render json: {status: "Project created"}
		end
	end

	def build
		if params[:selected_app].present? && params[:project_name].present? && params[:pages].present?
			MobileApp.code_generation(params[:selected_app], params[:project_name], params[:pages])
			render json: {status: "Build Done"}
		end
	end
end