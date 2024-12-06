class Admin::PagesController < ApplicationController
  def edit
    @page = Page.find(params[:id])
  end

  def update
    @page = Page.find(params[:id])
    if @page.update(page_params)
      redirect_to admin_page_path(@page.title), notice: "Page updated successfully."
    else
      render :edit, alert: "Unable to update page."
    end
  end
end
