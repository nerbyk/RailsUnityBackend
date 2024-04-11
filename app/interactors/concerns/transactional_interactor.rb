module TransactionalInteractor
  extend ActiveSupport::Concern

  included do
    include Interactor

    around do |interactor|
      ActiveRecord::Base.transaction { interactor.call }
    end
  end
end
