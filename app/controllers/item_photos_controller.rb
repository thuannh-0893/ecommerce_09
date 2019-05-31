class ItemPhotosController < ApplicationController
  authorize_resource

  before_action :find_photo, only: :destroy

  def destroy
    if @item_photo.destroy
      respond_to do |format|
        format.html{redirect_back fallback_location: root_path}
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
