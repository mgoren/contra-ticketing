class OrdersController < ApplicationController

  def new
    # redirect_to unavailable_path
    @idempotency_key = SecureRandom.uuid
    @order = Order.new
    @admission_cost = 30
    @admission_quantity = 1
  end

  def create
    @order = Order.new(order_params)
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

private
  def order_params
    params.require(:order).permit(:name, :email, :phone, :total, :admission_cost, :admission_quantity, :note, :stripe_token, :idempotency_key)
  end
end
