class Request < ActiveRecord::Base
  enum kind: [:visitor, :refresh]
end
