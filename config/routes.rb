Rails.application.routes.draw do
  namespace :v1 do
    devise_for :users, path: 'auth', only: :sessions, controllers: { sessions: 'v1/auth/sessions' }
  end

  if Rails.env.development?
    mount GraphiQL::Rails::Engine, at: "/graphiql", graphql_path: "/graphql"
  end
  post "/graphql", to: "graphql#execute"
end
