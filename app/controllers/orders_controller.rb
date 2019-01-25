class OrdersController < ApplicationController

  def new
    @idempotency_key = SecureRandom.uuid
    @order = Order.new
    @admission_cost = 25
    @admission_quantity = 1
  end

  def create
    @order = Order.new(order_params)
    @order.tshirts.each do |tshirt|
      tshirt.cost = tshirt.style.include?('Long') ? 30 : 20
    end
    @order.tshirt_quantity = @order.tshirts.length # length instead of count cuz not yet saved
    if @order.save
      render :create
    else
      if @order.errors.messages[:duplicate].any?
        redirect_to root_path
      else
        @idempotency_key = SecureRandom.uuid
        @admission_cost = @order.admission_cost
        @admission_quantity = @order.admission_quantity
        render :new
      end
    end
  end

  def update
    binding.pry
  end

private
  def order_params
    params.require(:order).permit(:name, :email, :phone, :total, :admission_cost, :admission_quantity, :stripe_token, :idempotency_key, tshirts_attributes: [:id, :style, :color, :size])
  end
end
