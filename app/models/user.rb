# frozen_string_literal: true

class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  include DeviseTokenAuth::Concerns::User

  has_one :farm, dependent: :destroy
  has_many :items, through: :farm
  has_many :entities, through: :farm

  after_create :init_default_farm

  def init_default_farm 
    self.farm = Farm.create_initial_farm(self)
  end
end
