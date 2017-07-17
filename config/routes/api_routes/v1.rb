module ApiRoutes
  module V1
    def self.extended(router)
      router.instance_exec do
        resources :users,    constraints: { format: 'json' }
        resources :schemas,  constraints: { format: 'json' }, only: [:show]
        resources :projects, constraints: { format: 'json' } do
           resources :users,
                    constraints: { format: 'json' },
                    as: :members,
                    except: [:show, :create],
                    controller: "projects_users"         
        end
        resources :roles, constraints: { format: 'json' } do
          resources :users,
                    constraints: { format: 'json' },
                    as: :members,
                    except: [:show, :create],
                    controller: "roles_users"
        end
        get "/usage/:year/:month", :controller => 'usage', :action => 'show'
      end
    end
  end
end
