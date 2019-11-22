class User < ApplicationRecord
  extend Enumerize

  enumerize :gender, in: { female: 0, male: 1 }, default: :male
end
