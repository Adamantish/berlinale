class Request < ActiveRecord::Base
  IGNORE_IPS = ["79.192.212.131", "84.140.144.178", '109.45.1.55']

  enum kind: [:visitor, :refresh]
  default_scope { where.not(remote_ip: IGNORE_IPS) }
end
