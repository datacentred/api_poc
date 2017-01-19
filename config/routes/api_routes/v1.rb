module ApiRoutes
  module V1
    def self.extended(router)
      router.instance_exec do
        resources :users
        resources :projects
        resources :status, only: [:index]
      end
    end
  end
end
