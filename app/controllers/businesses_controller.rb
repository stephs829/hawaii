class BusinessesController < ApplicationController

  def sample_data 
    factual = Factual.new Factual::KEY, Factual::SECRET

    @locality_count = factual.facets("places-us").select("region").filters("locality" => "Hauula").columns
    @rows = factual.table("places-us").filters("$and" => [{"category_ids" => {"$eq" => 2}}, "locality" => "honolulu", "region" => "hi"])
    @yelp = factual.table("crosswalk").filters("factual_id" => "3b9e2b46-4961-4a31-b90a-b5e0aed2a45e", "namespace" => "yelp").rows
    @categories = factual.table("place-categories").offset(50).limit(50)
    @localities = factual.facets("world-geographies").select("name", "factual_id").filters("$and" => [{"parent" => {"$includes" => "Hawaii"}}, "country" => "US", "placetype" => "postcode"]).limit(50).rows
  end

  def index
    respond_to do |format|
      format.json {
        @businesses = Business.all.includes(:categories)
      }
      format.html {
        @business_count = Business.all.count
      }
    end
  end

  # def categories
  #   respond_to do |format|
  #     format.json {
  #       # @businesses = Business.all.includes(:categories)
  #     }
  #   end
  # end

  def create
    @business = Business.new(business_params)
  end

  def update
    @business.update(business_params)

    redirect_to businesses_path
  end

  private

  def business_params
    params.require(:business).permit(:name, :factual_id, :address, :address_extended, :locality, :postcode, :latitude, :longitude, :region, :country, :tel, :fax, :website, :email, :hours_display, :po_box, :post_town, :admin_region, :chain_id, :chain_name)
  end

end