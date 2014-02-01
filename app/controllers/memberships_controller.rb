class MembershipsController < ApplicationController
  before_action :set_membership, only: [:show, :edit, :update, :destroy]

  # GET /memberships
  # GET /memberships.json
  def index
    @memberships = Membership.all
  end

  # GET /memberships/1
  # GET /memberships/1.json
  def show
  end

  # GET /memberships/new
  def new
    @membership = Membership.new
    @beer_clubs = BeerClub.all
  end

  # GET /memberships/1/edit
  def edit
  end

  # POST /memberships
  # POST /memberships.json
  def create

    club_to_join = BeerClub.find membership_params[:beer_club_id]
    already_member = current_user.beer_clubs.include?(club_to_join)

    @membership = Membership.new(beer_club_id:membership_params[:beer_club_id], user_id:current_user.id)

    if already_member
      @membership.errors.add(:beer_club_id, " cannot be joined, you are already a member of the #{club_to_join.name}")
    end

    respond_to do |format|
      if not already_member and @membership.save
        format.html { redirect_to @membership, notice: 'Membership was successfully created.' }
        format.json { render action: 'show', status: :created, location: @membership }
      else
        @beer_clubs = BeerClub.all
        format.html { render action: 'new' }
        format.json { render json: @membership.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /memberships/1
  # PATCH/PUT /memberships/1.json
  def update
    respond_to do |format|
      if @membership.update(membership_params)
        format.html { redirect_to @membership, notice: 'Membership was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @membership.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /memberships/1
  # DELETE /memberships/1.json
  def destroy
    @membership.destroy
    respond_to do |format|
      format.html { redirect_to memberships_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_membership
      @membership = Membership.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def membership_params
      params.require(:membership).permit(:beer_club_id, :user_id)
    end
end
