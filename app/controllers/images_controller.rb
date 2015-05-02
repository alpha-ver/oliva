class ImagesController < ApplicationController
  before_action :set_image, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    @images = current_user.images
    #respond_with(@images)
    respond_to do |format|
      format.html  # index.html.erb
      format.json  { render :json => {:q=>params[:data][:q], :results=>@images.map{|i| {:id=>i.id, :text=>i.name} } } }
    end

  end

  def show
    respond_with(@image)
  end

  def new
    @image = Image.new
    respond_with(@image)
  end

  def edit
  end

  def create
    #@image = Image.new(image_params)
    #@image.save
    #respond_with(@image)

    hash = Digest::SHA256.new
    img  = {}
    #########################
    img[:name     ] = params[:file].original_filename.split(".")
    img[:directory] = "public/image/#{current_user.id}"
    unless  File.exist?(img[:directory])
      Dir.mkdir img[:directory]
    end
    img_file = params[:file].read
    img[:img_hash ] = hash.hexdigest img_file
    img[:path     ] = File.join(img[:directory], img[:img_hash]+"."+img[:name][-1])
    #########################
    File.open(img[:path], "wb") { |f| f.write(img_file) }
    image = Image.find_by(:img_hash => img[:img_hash], :user_id => current_user.id)

    if image.blank?
      image = Image.new( :name => img[:name][0], :img_hash => img[:img_hash], :user_id => current_user.id, :img_class => params[:img_class], :img_type=>img[:name][-1])
      image.save
      render :json => img
    else
      render :json => {:error => "Уже загруженно: #{image.name}"}, :status => "406"
    end


  end

  def update
    @image.update(image_params)
    respond_with(@image)
  end

  def destroy
    @image.destroy
    respond_with(@image)
  end

  private
    def set_image
      @image = Image.find(params[:id])
    end

    def image_params
      params.require(:image).permit(:name)
    end
end
