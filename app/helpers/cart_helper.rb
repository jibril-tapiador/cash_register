module CartHelper
  def cart_item_count(session_id)
    Cart.find_by(id: session_id)&.cart_items&.sum(:quantity) || 0
  end
end
