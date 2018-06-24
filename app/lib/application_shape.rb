# frozen_string_literal: true

module ApplicationShape
  extend ActiveSupport::Concern

  module ClassMethods
    delegate :model_name, to: :superclass
    delegate :name, to: :superclass
  end
end
