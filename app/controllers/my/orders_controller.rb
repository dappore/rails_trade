class My::OrdersController < My::BaseController
  before_action :set_buyer
  before_action :set_order, only: [:show, :edit, :update, :pay, :update_date, :destroy]


  def index
    @orders = @buyer.orders

    respond_to do |format|
      format.html
      format.json { render json: @orders }
    end
  end

  def new
    @order = Order.new

    respond_to do |format|
      format.html
      format.json { render json: @order }
    end
  end

  def create
    @order = @buyer.orders.build(good_id: params[:good_id])

    respond_to do |format|
      if @order.save
        format.html { redirect_to edit_my_order_url(@order), notice: 'Order was successfully created.' }
        format.json { render json: @order, status: :created, location: @order }
      else
        format.html { render action: "new" }
        format.json { render json: @order.errors, status: :unprocessable_entity }
      end
    end
  end

  def pay
    if @order.payment_status != 'all_paid'
      @order.create_payment
      redirect_to @order.approve_url
    else
      redirect_to my_orders_url
    end
  end

  def show

    respond_to do |format|
      format.html
      format.json { render json: @order }
    end
  end

  def edit
    @user = @buyer
  end

  def update

    respond_to do |format|
      if @order.update(order_params)
        format.html { redirect_to :action => 'edit', :notice => 'Order was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @order.errors, status: :unprocessable_entity }
      end
    end
  end

  def update_date

    respond_to do |format|
      if @order.update(date_params)
        format.html { redirect_to @order, notice: 'Order was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @order.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @order.destroy

    respond_to do |format|
      format.html { redirect_to orders_url }
      format.json { head :no_content }
    end
  end

  private
  def set_order
    @order = Order.find(params[:id])
  end

  def set_buyer
    @buyer = Buyer.first
  end

  def order_params
    params[:order].permit(:quantity)
  end

  def date_params
    params[:order].permit(:order_on, :order_at)
  end

end
