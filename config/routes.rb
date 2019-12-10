Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html\
  get '/', to: 'welcome#index'

  get '/shelters', to: 'shelters#index'
  get '/shelters/new', to: 'shelters#new'
  post '/shelters', to: 'shelters#create'
  get '/shelters/:id', to: 'shelters#show'
  get '/shelters/:id/edit', to: 'shelters#edit'
  patch '/shelters/:id', to: 'shelters#update'
  delete '/shelters/:id', to: 'shelters#destroy'

  get '/pets', to: 'pets#index'
  get '/pets/:id', to: 'pets#show'
  get '/pets/:id/edit', to: 'pets#edit'
  patch '/pets/:id', to: 'pets#update'
  get 'shelters/:shelter_id/pets/new', to: 'pets#new'
  post 'shelters/:shelter_id/pets/', to: 'pets#create'
  delete '/pets/:id', to: 'pets#destroy'
  patch '/pets/:id/pending', to: 'pets#toggle_adoptable'
  
  get 'shelters/:shelter_id/pets', to: 'shelter_pets#index'
  
  get '/shelters/:shelter_id/shelter_reviews/new', to: 'shelter_reviews#new'
  patch '/shelters/:shelter_id/shelter_reviews/:shelter_review_id', to: 'shelter_reviews#update'
  post '/shelters/:shelter_id/shelter_reviews', to: 'shelter_reviews#create'
  get '/shelters/:shelter_id/shelter_reviews/:shelter_review_id/edit', to: 'shelter_reviews#edit'
  delete '/shelters/:shelter_id/shelter_reviews/:shelter_review_id', to: 'shelter_reviews#destroy'

  get '/favorites', to: 'favorites#index'
  get '/favorites/:pet_id', to: 'favorites#show'
  patch '/favorites/:pet_id', to: 'favorites#update'
  delete '/favorites/:pet_id', to: 'favorites#destroy'
  delete '/favorites', to: 'favorites#reset'

  get '/applications/new', to: 'applications#new'
  post '/applications', to: 'applications#create'
  get '/pets/:pet_id/applications', to: 'applications#index'
  get '/applications/:id', to: 'applications#show'
  
  patch '/pets/:pet_id/applications/:application_id', to: 'pet_applications#update'
end
