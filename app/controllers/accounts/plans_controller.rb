class Accounts::PlansController < Accounts::BaseController
  skip_before_action :subscription_required!
  
  def choose
    @plans  = Plan.order(:amount)
  end
  
  def chosen
    customer = Stripe::Customer.retrieve(current_account.stripe_customer_id)
    customer.source = params[:token]
    customer.save
    plan = Plan.find(params[:account][:plan_id])
    subscription = customer.subscriptions.create(
      plan: plan.stripe_id
    )
    current_account.plan = plan
    current_account.stripe_subscription_id = subscription.id
    current_account.save
    flash[:notice] = "Your account has been created."
    redirect_to root_url(subdomain: current_account.subdomain)
  end
end
