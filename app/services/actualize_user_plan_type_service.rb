# frozen_string_literal: true

class ActualizeUserPlanTypeService
  def call(**params)
    subscription = params.fetch(:subscription)
    return if subscription.nil?

    if subscription.trialing?
      actualize_by_subscription(subscription)
    else
      actualize_by_plan(subscription)
    end
  end

  private

  def actualize_by_subscription(subscription)
    change_to_trial(subscription)
  end

  def actualize_by_plan(subscription)
    plan = subscription.plans.first

    if plan.free?
      change_to_free(subscription)
    else
      change_to_paid(subscription)
    end
  end

  def change_to_trial(subscription)
    change_plan(subscription, User::TRIAL_PLAN_TYPE)
  end

  def change_to_free(subscription)
    change_plan(subscription, User::FREE_PLAN_TYPE)
  end

  def change_to_paid(subscription)
    change_plan(subscription, User::PAID_PLAN_TYPE)
  end

  def change_plan(subscription, plan_type)
    subscription.user.update(plan_type: plan_type)
  end
end
