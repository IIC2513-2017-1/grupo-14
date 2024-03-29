class ChoicesController < ApplicationController
  include Secured
  before_action :logged_in?, only: %i[new create edit update destroy]
  before_action :set_choice, only: [:show, :edit, :update, :destroy]

  # GET /choices
  # GET /choices.json
  def index
    @choices = Choice.all
  end

  # GET /choices/1
  # GET /choices/1.json
  def show
  end

  # GET /choices/new
  def new
    @choice = Choice.new
  end

  # GET /choices/1/edit
  def edit
  end

  def create_1
    params[:choices].each do |choice_params|
      @choice = Choice.new(choice_params)
      if not @choice.save
        format.html { render :new, status: 422 }
        format.json { render json: @choice.errors, status: :unprocessable_entity }
      end
    end
  end

  # POST /choices
  # POST /choices.json
  def create
    @choice = Choice.new(choice_params)

    respond_to do |format|
      if @choice.save
        format.html { redirect_to @choice, notice: 'Choice was successfully created.' }
        format.json { render :show, status: :created, location: @choice }
      else
        format.html { render :new, status: 422 }
        format.json { render json: @choice.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /choices/1
  # PATCH/PUT /choices/1.json
  def update
    respond_to do |format|
      if @choice.update(choice_params)
        format.html { redirect_to @choice, notice: 'Choice was successfully updated.' }
        format.json { render :show, status: :ok, location: @choice }
      else
        format.html { render :edit }
        format.json { render json: @choice.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /choices/1
  # DELETE /choices/1.json
  def destroy
    @choice.destroy
    respond_to do |format|
      format.html { redirect_to choices_url, notice: 'Choice was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_choice
      @choice = Choice.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def choice_params
      params.require(:choice).permit(:value,:bet_id)
    end
end
