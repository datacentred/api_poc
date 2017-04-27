module ApiRoutes
  module V1
    def self.extended(router)
      router.instance_exec do
        resources :users,    constraints: { format: 'json' }
        resources :projects, constraints: { format: 'json' }
        resources :roles,    constraints: { format: 'json' } do
          resources :users,
                    constraints: { format: 'json' },
                    as: :members,
                    except: [:show, :create],
                    controller: "roles_users"
        end
      end
    end
  end
end
