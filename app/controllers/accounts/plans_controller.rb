class Accounts::PlansController < Accounts::BaseController
  before_action :owner_required!
  skip_before_action :subscription_required!
  
  def choose
    @plans = Plan.order(:price)
    @client_token = Braintree::ClientToken.generate(
      customer_id: current_account.braintree_customer_id
    )
    render :choose
  end
  
  def chosen
    plan = Plan.find(params[:account][:plan_id])
    result = Braintree::Subscription.create(
      payment_method_nonce: params[:payment_method_nonce],
      plan_id: plan.braintree_id
    )
    if result.success?
      current_account.braintree_subscription_id = result.subscription.id
      current_account.braintree_subscription_status = result.subscription.status
      current_account.plan = plan
      current_account.save
      flash[:notice] = "Your account has been successfully created."
      redirect_to root_url(subdomain: current_account.subdomain)
    else
      flash[:alert] = "Subscription failed: #{result.message}"
      choose
    end
  end
  
  def cancel
    result = Braintree::Subscription.cancel(current_account.braintree_subscription_id)
    if result.success?
      current_account.update_column(
        :braintree_subscription_status,
        result.subscription.status
      )
      flash[:notice] = "Your subscription to Twist has been cancelled."
      redirect_to root_url(subdomain: nil)
    end
  end
  
  def switch
    plan = Plan.find(params[:plan_id])
    Braintree::Subscription.update(
      current_account.braintree_subscription_id,
      plan_id: plan.braintree_id
    )
    
    current_account.update_column(:plan_id, plan.id)
    
    flash[:notice] = "You have changed to the #{plan.name} plan."
    redirect_to root_url
  end
end
