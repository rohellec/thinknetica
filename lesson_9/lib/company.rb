require_relative "accessors"

module Company
  extend Accessors

  attr_accessor_with_history :company
end
