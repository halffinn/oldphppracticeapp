class GeoController < ApiController
  filter_access_to :all, :attribute_check => false
  respond_to :xml, :json
  
  # TODO: Check caching, it seems to be buggy

  # == Description
  # Returns a list of all the countries
  # ==Resource URL
  # /geo/countries.format
  # ==Example
  # GET https://backend-heypal.heroku.com/geo/countries.json
  # ==Response
  # id, code_iso and name
  def get_countries
    @countries = Rails.cache.fetch('geo_countries_list') {
      City.find_by_sql(["SELECT DISTINCT country, country_code FROM cities ORDER BY country"])
    }
    return_message(200, :ok, {:countries => @countries})
  end

  # == Description
  # Returns a list of all the states on a country, accepts country_code
  # ==Resource URL
  # /geo/states.format
  # ==Example
  # GET https://backend-heypal.heroku.com/geo/states.json country_code=PA
  # === Parameters
  # [country_code]
  # Error codes
  # [115] no results
  def get_states
    @states = Rails.cache.fetch('geo_states_' + params[:country_code].to_s) { 
      City.find_by_sql(["SELECT DISTINCT state FROM cities WHERE country_code = ? ORDER BY state", params[:country_code]])
    }
    if !@states.blank?
      return_message(200, :ok, { :states => @states })
    else
      return_message(200, :ok, { :err => {:states => [115]} })
    end
  end

  # == Description
  # Returns a list of all the cities on a state, accepts country_code
  # ==Resource URL
  # /geo/cities.format
  # ==Example
  # GET https://backend-heypal.heroku.com/geo/cities.json country_code=SG
  # === Parameters
  # [country_code]
  # [state]
  # [active]
  # === Error codes
  # [115] No results
  def get_cities
    country_code = params[:country_code] if params[:country_code]
    state = params[:state] if params[:state]
    @fields = [:id, :name, :country_code, :lat, :lon, :active]
    if country_code
      @cities = Rails.cache.fetch('geo_cities_' + country_code) { 
        City.select(@fields).where(:country_code => country_code).all
      }
    elsif state
      @cities = Rails.cache.fetch('geo_cities_' + country_code + '_' + state.parameterize) { 
        City.select(@fields).where(:state => state).all
      }
    elsif params[:active]
      @cities = Rails.cache.fetch('geo_cities_all_active') { 
        City.active.select(@fields).all
      }
    else
      @cities = Rails.cache.fetch('geo_cities_all') { 
        City.select(@fields).all
      }
    end
    if @cities && !@cities.blank?
      return_message(200, :ok, {:cities => filter_fields(@cities,@fields)})
    elsif @cities && @cities.blank?
      return_message(200, :ok, {:err => {:cities => [115]}})
    else
      return_message(200, :fail, {:err => {:country_code => [101]}})
    end
  end

  # == Description
  # Returns a city
  # ==Resource URL
  # /geo/cities/:id.format
  # ==Example
  # GET https://backend-heypal.heroku.com/geo/cities/1.json
  # === Parameters
  # [id]
  # === Error codes
  # [106] Record not found
  def get_city
    @fields = [:id, :name, :lat, :lon, :state, :country, :country_code]
    @city = Rails.cache.fetch('geo_cities_' + params[:id].parameterize) { 
      City.select(@fields).find(params[:id])
    }
    return_message(200, :ok, {:city => @city})
  end

  # == Description
  # Returns the city id and name containing state and country, used for ajax search
  # ==Resource URL
  # /geo/cities/search.format
  # ==Example
  # GET https://backend-heypal.heroku.com/geo/cities/search.json query=manil
  # === Parameters
  # [query]
  # === Error codes
  # [115] No results
  def city_search
    if !params[:query].blank?
      @cities = Rails.cache.fetch('city_search_' + params[:query].parameterize) {
        City.where(['name LIKE ?', "#{params[:query]}%"]).select("id as city_id, cached_complete_name as name").limit(10).all
      }
      return_message(200, :ok, {:cities => @cities}) if !@cities.empty?
    else
      return_message(200, :ok, {:err => {:cities => [115]}})
    end
  end

  # == Description
  # Shows a cities's max and min price
  # ==Resource URL
  #   /geo/cities/:id/price_range.format
  # ==Example
  #   GET https://backend-heypal.heroku.com/geo/cities/1/price_range.json
  # === Parameters
  # [currency]   ISO Code of the currency to return prices in. Optional
  # === Response
  # [min_price] Minimum price of published places. Default USD
  # [max_price] Maximum price of published places. Default USD
  # === Error codes
  # [115] no results
  def price_range
    max_price_usd = Place.where("published=1").where("city_id=#{params[:id]}").maximum('price_per_month_usd')
    min_price_usd = Place.where("published=1").where("city_id=#{params[:id]}").minimum('price_per_month_usd')

    if !max_price_usd.nil? && !min_price_usd.nil?
      if params[:currency] && valid_currency?(params[:currency])
        max_price = exchange_currency(max_price_usd/100, :USD, params[:currency]).ceil
        min_price = exchange_currency(min_price_usd/100, :USD, params[:currency]).floor
      else
        max_price = (max_price_usd/100).ceil
        min_price = (min_price_usd/100).floor
      end
      max_price = (max_price/100.0).ceil * 100
      min_price = (min_price/100.0).floor * 100
    else
      min_price = 0
      max_price = 0
    end
    
    if !max_price.blank?
      return_message(200, :ok, {:min_price => min_price, :max_price => max_price})
    else
      return_message(200, :ok, {:err => {:places => [115]}})
    end
  end

end