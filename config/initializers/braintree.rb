Braintree::Configuration.environment = :sandbox
Braintree::Configuration.merchant_id = "ngqtth9sn4fb8bqm"
Braintree::Configuration.public_key = "q6kxzpdrjhtvh427"
Braintree::Configuration.private_key = "bf860129963d86c6c7ee310530ca8ba6"

gateway = Braintree::Gateway.new(
  :environment => :sandbox,
  :merchant_id => 'ngqtth9sn4fb8bqm',
  :public_key => 'q6kxzpdrjhtvh427',
  :private_key => 'bf860129963d86c6c7ee310530ca8ba6',
)