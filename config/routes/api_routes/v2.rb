module ApiRoutes
  module V2
    def self.extended(router)
      router.instance_exec do
        resources :users
      end
    end
  end
end
