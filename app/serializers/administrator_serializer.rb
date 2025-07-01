class AdministratorSerializer
  include JSONAPI::Serializer
  attributes :id, :email, :first_name, :last_name, :phone_number, :role,  :is_active, :is_account_owner
end
