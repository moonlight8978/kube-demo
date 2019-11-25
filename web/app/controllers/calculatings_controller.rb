class CalculatingsController < ApplicationController
  def index
    @calculating = Calculating.new
  end

  def create
    # @calculating = Calculating.create(params.require(:calculating).permit(:raw))
    binding.pry
    CalculatorWorker.perform_later(@calculating.id)

    redirect_to :index
  end
end
