class StripePlanFetcher
  def self.store_locally
    Stripe::Plan.all.each do |plan|
      if local_plan = Plan.find_by(stripe_id: plan.id)
        local_plan.update(
          name: plan.nickname,
          amount: plan.amount,
        )
      else
        Plan.create(
          name: plan.nickname,
          amount: plan.amount,
          stripe_id: plan.id
        )
      end
    end
  end
end