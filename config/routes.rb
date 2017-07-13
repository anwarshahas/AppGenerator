Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  	resources :apps do
	    collection do
	      post :new
	      post :build
	    end
  	end
end
