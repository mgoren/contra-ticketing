class OrdersController < ApplicationController

  def new
    @idempotency_key = SecureRandom.uuid
    @order = Order.new
    @admission_cost = 25
    @admission_quantity = 1
    @tshirt_quantity = 0
  end

  def create
    @order = Order.new(order_params)
    if @order.save
      render :create
    else
      @idempotency_key = SecureRandom.uuid
      @admission_cost = @order.admission_cost
      @admission_quantity = @order.admission_quantity
      @tshirt_quantity = @order.tshirt_quantity
      render :new
    end
  end

private
  def order_params
    params.require(:order).permit(:name, :email, :phone, :total, :admission_cost, :admission_quantity, :tshirt_quantity, :tshirt_note, :stripe_token, :idempotency_key).merge(tshirt_cost: 15)
  end
end
