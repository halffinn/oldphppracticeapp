class PlacesController < ApplicationController
  filter_resource_access
  filter_access_to [:show, :create, :update, :search, :user_places, :publish], :attribute_check => false
  skip_before_filter :verify_authenticity_token
  respond_to :xml, :json
  
  def initialize
    @fields = [
      :id, :title, :description, :num_bedrooms, :num_beds, 
      :num_bathrooms, :size, :size_sqm, :size_sqf, :size_unit, :max_guests, :photos, :city_id, :address_1, 
      :address_2, :zip, :lat, :lon, :directions, 
      :check_in_after, :check_out_before, :minimum_stay_days, 
      :maximum_stay_days, :house_rules, :cancellation_policy,
      :reviews_overall,:reviews_accuracy_avg,:reviews_cleanliness_avg,
      :reviews_checkin_avg,:reviews_communication_avg,:reviews_location_avg,
      :reviews_value_avg, :currency, :price_final_cleanup, 
      :price_security_deposit, :price_per_night, :price_per_week, :price_per_month,
      :published,
      :country_name, :country_code, :state_name, :city_name,
      :price_final_cleanup_usd, :price_security_deposit_usd, :price_per_night_usd, :price_per_week_usd, :price_per_month_usd
    ]
    
    @amenities = [
      :amenities_aircon,:amenities_breakfast,:amenities_buzzer_intercom,:amenities_cable_tv,
      :amenities_dryer,:amenities_doorman,:amenities_elevator,
      :amenities_family_friendly,:amenities_gym,:amenities_hot_tub,:amenities_kitchen,
      :amenities_handicap,:amenities_heating,:amenities_hot_water,
      :amenities_internet,:amenities_internet_wifi,:amenities_jacuzzi,:amenities_parking_included,
      :amenities_pets_allowed,:amenities_pool,:amenities_smoking_allowed,:amenities_suitable_events,
      :amenities_tennis,:amenities_tv,:amenities_washer  
    ]
    
    @search_fields = [
      :id, :title, :size_sqf, :size_sqm, :reviews_overall, :price_per_night_usd, :price_per_week_usd, :price_per_month_usd
    ]

    @fields = @fields + @amenities

    # Assosiations
    @user_fields = [:id, :first_name, :last_name, :avatar_file_name]
    @place_type_fields = [:id,:name]

  end

  # ==Description
  # Returns a list places matching the search parameters
  # ==Resource URL
  #   /places/search.format
  # ==Example
  #   GET https://backend-heypal.heroku.com/places/search.json q[country_code_eq]=AU&q[num_bedrooms_lt]=5&q[num_bedrooms_gt]=2&page=1[m]=and
  # === Matching options
  # [eq]
  #   Equal
  #     Ex: q[num_bedrooms_eq]=2
  # [not_eq]
  #   Not equal
  #     Ex: q[country_code_not_eq]=PH
  # [gt]
  #   Greater than
  #     Ex: q[num_bedrooms_gt]=4
  # [lt]
  #   Lower than
  #     Ex: q[num_bedrooms_lt]=2
  # [gteq]
  #   Greater than or equal
  #     Ex: q[num_bedrooms_gteq]=4
  # [lteq]
  #   Lower than or equal
  #     Ex: q[num_bedrooms_lteq]=4
  # [cont]
  #   Contains
  #     Ex: q[title_cont]=House
  # [true]
  #   True, 1 or 0
  #     Ex: q[amenities_washer_true]=1
  # [false]
  #   False, 1 or 0
  #     Ex: q[amenities_tv_false]=1
  # [present]
  #   Not empty, 1 or 0
  #     Ex: q[description_present]=1
  # [blank]
  #   Empty, 1 or 0
  #     Ex: q[description_present]=1
  # === Parameters
  # The search parameters are received as an array named "q", the paramater itself is composed by the name of the column and the matching option.
  # Do not use this search paramaters for published status.
  #   Ex: q[max_guests_eq]
  # [page]
  #   Page number
  #     Ex: page=2
  # [per_page]
  #   Results per page. Default is 20
  #     Ex: per_page=10
  # [m]
  #   Used to match all the parameters or any. Options: and, or.
  #     Ex: m=or
  # [status]
  #   Defaults to published, Options: published, not_published, all
  #     Ex: status=all
  # [sort]
  #   Sorting options: name, price_lowest, price_highest, price_size_lowest, price_size_highest, reviews
  #     Ex: sort=price_low
  # === Response
  # [results] Total number of results. Used for pagination
  # [current_page] Current page number. Used for pagination
  # [per_page] Results showed per page. Used for pagination
  # [total_pages] Total number of pages. Used for pagination
  # [places] Array containing the places
  # === Error codes
  # [115]           no results
  def search
    !params[:per_page].blank? ? per_page = params[:per_page] : per_page = Place.per_page

    if !params[:q].blank?

      case params[:status]
      when "all"
        @search = Place.search(params[:q])
      when "published"
        @search = Place.where(:published => true).search(params[:q])
      when "not_published"
        @search = Place.where(:published => false).search(params[:q])
      else
        @search = Place.where(:published => true).search(params[:q])
      end
      
      case params[:sort]
      when "name"
        sorting = ["title asc"]
      when "price_lowest"
        sorting = ["price_per_night_usd asc"]
      when "price_highest"
        sorting = ["price_per_night_usd desc"]
      when "price_size_lowest"
        sorting = ["price_sqf_usd asc"]
      when "price_size_highest"
        sorting = ["price_sqf_usd desc"]
      when "reviews_overall"
        sorting = ["reviews_overall desc"]
      end

      @search.sorts = sorting if sorting

      places = @search.result(:distinct => true)
      places_paginated = places.paginate(:page => params[:page], :per_page => per_page)

      if !places_paginated.blank?
        filtered_places = filter_fields(places_paginated, @search_fields, { :additional_fields => { 
          :user => @user_fields,
          :place_type => @place_type_fields }
        })
        response = {
          :places => filtered_places, 
          :results => places.count, 
          :per_page => per_page, 
          :current_page => params[:page], 
          :total_pages => (places.count/per_page.to_f).ceil
        }
      else
        response = {:err => {:places => [115]}}
      end
      return_message(200, :ok, response)
    else
      return_message(200, :ok, {:err => {:query => [101]}})
    end

  end

  # ==Description
  # Returns all the information about a place
  # ==Resource URL
  #   /places/:id.format
  # ==Example
  #   GET https://backend-heypal.heroku.com/places/id.json
  # === Parameters
  # [id] if of the place
  def show
    @place = Place.find(params[:id])
    place = filter_fields(@place, @fields, { :additional_fields => { 
      :user => @user_fields,
      :place_type => @place_type_fields } })
    return_message(200, :ok, {:place => place})
  end
  
  # == Description
  # Crates a new place with basic information
  # ==Resource URL
  #   /places.format
  # ==Example
  #   POST https://backend-heypal.heroku.com/places.json access_token=access_token&title=Joe's Apartment&type_id=2&num_bedrooms=3&max_guests=5&city_id=62
  # === Parameters
  # [access_token] Access token
  # [title]         Title for the place
  # [place_type_id] ID from the PlaceType model, Integer
  # [num_bedrooms]  Integer
  # [max_guests]    Integer
  # [city_id]       ID from the City model, Integer
  # === Response
  # [place] Array containing the recently created place
  # === Error codes
  # [101] can't be blank 
  # [103] is invalid
  # [105] invalid access token
  def create
    check_token
    place = { 
      :title         => params[:title],
      :place_type_id => params[:place_type_id],
      :num_bedrooms  => params[:num_bedrooms],
      :max_guests    => params[:max_guests],
      :city_id       => params[:city_id] }
    @place = current_user.places.new(place)
    if @place.save
      place_return = filter_fields(@place, [:id, :title,:num_bedrooms,:max_guests,:country_name, :country_code, :state_name, :city_name, :city_id], :additional_fields => {
          :user => @user_fields,
          :place_type => @place_type_fields
        })
      return_message(200, :ok, {:place => place_return})
    else
      return_message(200, :fail, {:err => format_errors(@place.errors.messages)})
    end
  end
  
  # == Description
  # Updates a place with additional information
  # ==Resource URL
  #   /places/:id.format
  # ==Example
  #   PUT https://backend-heypal.heroku.com/places/1.json access_token=access_token&num_beds=5&description=Nam luctus feugiat
  # === Parameters
  # [access_token] Access token
  # [title]         String,  title of the place
  # [description]   Text,    long description of the place
  # [place_type_id] Integer, ID from the PlaceType model
  # [num_bedrooms]  Integer, number of bedrooms
  # [num_beds]      Integer, number of beds
  # [num_bathrooms] Integer, number of bathrooms
  # [size]           Float,  square meters or square feet of the entire place
  # [size_unit]     String,  Size unit, feet or meters
  # [max_guests]    Integer, maximum number of guests the place can fit
  # [city_id]       Integer, ID from the Cities model
  # [address_1]     String,  text description of address
  # [address_2]     String
  # [zip]           String,  postal code
  # [lat]           Double,  latitude coordinates
  # [lon]           Double,  longitude coordinates
  # [directions]    Text,    description on how to find the place
  # [amenities_name]
  #   The following options are accepted (replace "name").
  #   aircon,breakfast,buzzer_intercom,cable_tv,dryer,doorman,elevator,
  #   family_friendly,gym,hot_tub,kitchen,handicap,heating,hot_water,
  #   internet,internet_wifi,jacuzzi,parking_included,pets_allowed,pool,
  #   smoking_allowed,suitable_events,tennis,tv,washer
  # [currency]               Currency ISO code, Ex. USD
  # [price_per_night]        Currency Units, not cents 1=$1, Integer
  # [price_per_week]         Currency Units, not cents 1=$1, Integer
  # [price_per_month]        Currency Units, not cents 1=$1, Integer
  # [price_final_cleanup]    Currency Units, not cents 1=$1, Integer
  # [price_security_deposit] Currency Units, not cents 1=$1, Integer
  # [check_in_after]         String, ie. 11:00 / 11:30 / 13:30
  # [check_out_before]       String, ie. 11:00 / 11:30 / 13:30
  # [minimum_stay_days]      Integer, 0 means no minimum
  # [maximum_stay_days]      Integer, 0 means no maximum
  # [house_rules]            Text, rules for the user to follow when staying at a place
  # [cancellation_policy]    Integer. Should align with frontend, 1=flexible, 2=moderate, 3=strict
  # 
  # === Response
  # [place] Array containing the recently created place
  # 
  # === Error codes
  # [101] can't be blank 
  # [103] is invalid
  # [105] invalid access token
  # [118] must be a number
  def update
    check_token
    @place = Place.find(params[:id])
    place = filter_params(params, @fields)
    if @place.update_attributes(place)
      place_return = filter_fields(@place,@fields, { :additional_fields => {
        :user => @user_fields,
        :place_type => @place_type_fields } })
      return_message(200, :ok, {:place => place_return})
    else
      return_message(200, :fail, {:err => format_errors(@place.errors.messages)})
    end
  end
  
  # == Description
  # Deletes a place
  # ==Resource URL
  #   /places/:id.format
  # ==Example
  #   DELETE https://backend-heypal.heroku.com/places/:id.json access_token=access_token
  # === Parameters
  # [access_token]
  def destroy
    check_token
    place = Place.find(params[:id])
    if place.destroy
      return_message(200, :ok)
    else
      return_message(200, :fail, {:err => format_errors(place.errors.messages)})
    end
  end
  
  # == Description
  # Shows a users places
  # ==Resource URL
  #   /users/:id/places.format
  # ==Example
  #   GET https://backend-heypal.heroku.com/users/:id/places.json access_token=access_token&published=0
  # === Parameters
  # [access_token]  Access token
  # [published]     Shows or hides unpublished places (shows published places by default), Boolean value
  # === Error codes
  # [115]           no results
  def user_places
    check_token
    @places = current_user.places
    @places = @places.where(:published => true) unless params[:published] == "0"
    if !@places.blank?
      places_return = filter_fields(@places,@fields, { :additional_fields => {
        :place_type => @place_type_fields}})
      return_message(200, :ok, {:places => places_return})
    else
      return_message(200, :ok, { :err => {:places => [115]}})
    end
  end

  # == Description
  # Changes a place status
  # ==Resource URL
  #   /places/:id/:status.format
  # ==Example
  #   GET https://backend-heypal.heroku.com/places/:id/publish.json access_token=access_token
  #   GET https://backend-heypal.heroku.com/places/:id/unpublish.json access_token=access_token
  # === Parameters
  # [access_token]  Access token
  # [status]        Publish status, options: publish, unpublish
  # === Error codes
  # [106] Record not found
  # [123] not enough pictures
  # [124] description is too short
  # [125] no availability
  # [126] no price
  # [127] no currency
  # [128] no security deposit
  def publish
    if params[:status] == "publish" or params[:status] == "unpublish"
      method = "#{params[:status]}!" 
    else
      raise ActionController::UnknownAction
    end
    @place = Place.find(params[:id])
      if method        
        if @place.send(method)
          place = filter_fields(@place,@fields, { 
            :additional_fields => {
              :place_type => @place_type_fields 
            } 
          })
          return_message(200, :ok, {:place => place})
        else
          return_message(200, :ok, { :err => format_errors(@place.errors.messages) })
        end
      else
        return_message(200, :ok, { :err => {:status => [103]} } )
      end
  end
end