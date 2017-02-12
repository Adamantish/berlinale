class Request < ActiveRecord::Base
  enum kind: [:visitor, :refresh]
  default_scope { where.not(remote_ip: '109.45.1.55') }
end
