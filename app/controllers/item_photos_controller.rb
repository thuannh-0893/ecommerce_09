class ItemPhotosController < ApplicationController
  before_action :find_photo, only: :destroy
  def destroy
    item = @item_photo.product
    if @item_photo.destroy
      respond_to do |format|
        format.html{redirect_to edit_admin_product_url(item)}
      end
    else
      flash[:danger] = t "helpers.error[deleted_fail]"
      redirect_to root_url
    end
  end

  private

  def find_photo
    @item_photo = ItemPhoto.find_by id: params[:id]
    return if @item_photo
    flash[:danger] = t "helpers.error[item_not_found]"
    redirect_to root_url
  end
end
