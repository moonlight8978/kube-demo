class CalculatingsController < ApplicationController
  def index
    @calculatings = Calculating.all.with_attached_raw
    @calculating = Calculating.new
  end

  def create
    @calculating = Calculating.create(params.require(:calculating).permit(:raw))
    CalculatorWorker.perform_async(@calculating.id)
    redirect_to calculatings_path
  end
end
