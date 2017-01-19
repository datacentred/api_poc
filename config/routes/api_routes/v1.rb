module ApiRoutes
  module V1
    def self.extended(router)
      router.instance_exec do
        resources :users
        resources :projects
      end
    end
  end
end
