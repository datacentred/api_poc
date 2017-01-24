module ApiRoutes
  module V1
    def self.extended(router)
      router.instance_exec do
        resources :users,    constraints: { format: 'json' }
        resources :projects, constraints: { format: 'json' }
        resources :status,   constraints: { format: 'json' }, only: [:index]
      end
    end
  end
end
