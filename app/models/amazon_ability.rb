class AmazonAbility
  include CanCan::Ability

  def initialize(user)
    can :manage, Spree::Amazon::Taxon
    can :manage, Spree::Amazon::Product
  end

end
