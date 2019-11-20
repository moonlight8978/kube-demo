class Calculating < ApplicationRecord
  has_one_attached :raw

  serialize :input, Array
end
