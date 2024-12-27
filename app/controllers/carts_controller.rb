class CartsController < ApplicationController
  before_action :set_cart, only: %i[ show edit update destroy ]

  # GET /carts or /carts.json
  def index
    @carts = Cart.all
  end

  def add_product
    product_id = params[:product_id].to_i
    quantity = params[:quantity].to_i
  
    # Verificar que product_id y quantity no sean nulos o incorrectos
    if product_id <= 0 || quantity <= 0
      redirect_to root_path, alert: 'Producto o cantidad no válidos.'
      return
    end
  
    if user_signed_in?
      @cart = current_user.cart || current_user.create_cart
  
      # Si el carrito no existe, se crea uno nuevo
      cart_product = @cart.cart_products.find_or_initialize_by(product_id: product_id)
      cart_product.quantity ||= 0
      cart_product.quantity += quantity
  
      # Validar cantidad
      product = cart_product.product
      if cart_product.quantity > product.quantity
        redirect_to cart_path(product_id), alert: 'No hay suficiente stock de este producto.'
        return
      end
  
      if cart_product.save
        redirect_to cart_path, notice: 'Producto añadido al carrito.'
      else
        redirect_to cart_path(product_id), alert: 'No se pudo añadir el producto al carrito.'
      end
    else
      # Lógica para usuarios no autenticados
      session[:cart] ||= {}
      session[:cart][product_id.to_s] ||= 0
      session[:cart][product_id.to_s] += quantity
      redirect_to cart_path, notice: 'Producto añadido al carrito.'
    end
  end
  
  
  # Eliminar un producto del carrito
  def remove_product
    product_id = params[:product_id].to_i
  
    if user_signed_in?
      # Lógica para usuarios registrados
      @cart = current_user.cart || current_user.create_cart
      cart_product = @cart.cart_products.find_by(product_id: product_id)
  
      if cart_product
        cart_product.destroy
        redirect_to cart_path, notice: 'Producto eliminado del carrito.'
      else
        redirect_to cart_path, alert: 'El producto no estaba en tu carrito.'
      end
    else
      # Lógica para usuarios no autenticados, usando la sesión
      if session[:cart].present? && session[:cart][product_id.to_s].present?
        session[:cart].delete(product_id.to_s)
        redirect_to cart_path, notice: 'Producto eliminado del carrito.'
      else
        redirect_to cart_path, alert: 'No hay productos en el carrito para eliminar.'
      end
    end
  end

  def update_quantity
    product_id = params[:product_id].to_i
    new_quantity = params[:quantity].to_i
  
    if user_signed_in?
      # Carrito para usuario registrado
      cart_product = @cart.cart_products.find_by(product_id: product_id)
      if cart_product
        cart_product.update(quantity: new_quantity)
        redirect_to cart_path, notice: 'Cantidad actualizada correctamente.'
      else
        redirect_to cart_path, alert: 'Producto no encontrado en el carrito.'
      end
    else
      # Carrito basado en sesión
      session[:cart][product_id] = new_quantity
      redirect_to cart_path, notice: 'Cantidad actualizada correctamente.'
    end
  end

  def remove_product2
    product_id = params[:product_id].to_i
    if user_signed_in?
      @cart = current_user.cart || current_user.create_cart
      cart_product = @cart.cart_products.find_by(product_id: product_id)
      if cart_product
        cart_product.destroy
        redirect_to cart_path, notice: 'Producto eliminado del carrito.'
      else
        redirect_to cart_path, alert: 'El producto no estaba en tu carrito.'
      end
    else
      # Lógica para usuarios no autenticados
      if session[:cart].present? && session[:cart][product_id.to_s].present?
        session[:cart].delete(product_id.to_s)
        redirect_to cart_path, notice: 'Producto eliminado del carrito.'
      else
        redirect_to cart_path, alert: 'No hay productos en el carrito para eliminar.'
      end
    end
  end
  
  def update_quantity2
    product_id = params[:product_id].to_i
    new_quantity = params[:quantity].to_i
  
    if user_signed_in?
      @cart = current_user.cart || current_user.create_cart
      cart_product = @cart.cart_products.find_by(product_id: product_id)
      if cart_product
        cart_product.update(quantity: new_quantity)
        redirect_to cart_path, notice: 'Cantidad actualizada correctamente.'
      else
        redirect_to cart_path, alert: 'Producto no encontrado en el carrito.'
      end
    else
      # Carrito basado en sesión
      session[:cart][product_id] = new_quantity
      redirect_to cart_path, notice: 'Cantidad actualizada correctamente.'
    end
  end
  

  # GET /carts/1 or /carts/1.json
  
  def show
    @cart_items = session[:cart] || {}
    @products = Product.find(@cart_items.keys) # Asegúrate de que todos los productos existen
    
    # Calcular el total del carrito
    @total = @products.sum do |product|
      quantity = @cart_items[product.id.to_s] || 0
      product.price * quantity
    end
  end
  


  # GET /carts/new
  def new
    @cart = Cart.new
  end

  # GET /carts/1/edit
  def edit
  end

  # POST /carts or /carts.json
  def create
    @cart = Cart.new(cart_params)

    respond_to do |format|
      if @cart.save
        format.html { redirect_to @cart, notice: "Cart was successfully created." }
        format.json { render :show, status: :created, location: @cart }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @cart.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /carts/1 or /carts/1.json
  def update
    respond_to do |format|
      if @cart.update(cart_params)
        format.html { redirect_to @cart, notice: "Cart was successfully updated." }
        format.json { render :show, status: :ok, location: @cart }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @cart.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /carts/1 or /carts/1.json
  def destroy
    @cart.destroy

    respond_to do |format|
      format.html { redirect_to carts_path, status: :see_other, notice: "Cart was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_cart
      if user_signed_in?
        # Carrito para usuario registrado
        @cart = current_user.cart || current_user.create_cart
        @cart_items = @cart.cart_products
      else
        # Carrito basado en sesión para usuarios no autenticados
        session[:cart] ||= {}
        @cart = OpenStruct.new(cart_products: session[:cart].map do |product_id, quantity|
          product = Product.find(product_id)
          OpenStruct.new(product: product, quantity: quantity, subtotal: product.price * quantity)
        end)
      end
    end    
    
  
    def user_signed_in?
      # Usa el método de autenticación que estés utilizando (por ejemplo, Devise)
      current_user.present?
    end

    # Only allow a list of trusted parameters through.
    def cart_params
      params.require(:cart).permit(:user_id)
    end
end
