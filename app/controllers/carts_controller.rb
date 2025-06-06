class CartsController < ApplicationController
  before_action :set_cart

  def show
    @cart_items = @cart.cart_items.includes(:product)
    @subtotal_price = @cart.subtotal_price
    @total = @cart.total_price
  end

  def add
    sku = params.require(:sku)
    @cart.add_product_by_sku(sku)
    redirect_to products_path
  rescue ActiveRecord::RecordNotFound
    head :not_found
  end

  def remove
    sku = params.require(:sku)
    @cart.remove_product_by_sku(sku)
    redirect_to cart_path
  rescue ActiveRecord::RecordNotFound
    head :not_found
  end

  private

  def set_cart
    @cart = Cart.find_or_create_by(id: session[:cart_id])
    session[:cart_id] ||= @cart.id
  end
end
