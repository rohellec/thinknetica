require_relative "accessors"

module Company
  include Accessors

  attr_accessor_with_history :company
end
