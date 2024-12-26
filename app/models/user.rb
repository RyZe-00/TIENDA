class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :user_role
  has_many :roles, through: :user_role

  def administrador?
    roles.exists?(name: 'Administrador') # Asegúrate de que 'Administrador' sea el nombre correcto del rol
  end
end
