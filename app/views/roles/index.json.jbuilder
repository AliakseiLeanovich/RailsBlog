json.array!(@roles) do |role|
  json.extract! role, :id, :title, :description, :create_ability, :read_ability, :update_ability, :delete_ability
  json.url role_url(role, format: :json)
end
