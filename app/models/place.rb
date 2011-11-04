include GeneralHelper
require 'money/bank/google_currency'
Money.default_bank = Money::Bank::GoogleCurrency.new

class Place < ActiveRecord::Base
  serialize :photos

  validates_presence_of [:title, :place_type_id, :num_bedrooms, :max_guests, :city_id], :message => "101"
  validates_inclusion_of :size_unit, :in => ["meters", "feet"], :allow_nil => true, :if => :size?, :message => "129"

  validates_numericality_of [
    :num_bedrooms,
    :num_beds,
    :num_bathrooms,
    :size,
    :max_guests,
    :price_per_night,
    :price_per_week,
    :price_per_month,
    :price_final_cleanup,
    :price_security_deposit,
    :price_per_night_usd,
    :price_per_week_usd,
    :price_per_month_usd,
    :minimum_stay_days,
    :maximum_stay_days
  ], :allow_nil => true, :message => "118"

  attr_accessor :amenities, :location, :terms_of_offer
  attr_protected :published

  belongs_to :user
  belongs_to :place_type
  belongs_to :city
  belongs_to :state
  belongs_to :country

  has_many   :availabilities
  has_many   :comments

  before_create :update_location_fields
  before_update :save_amenities, 
                :convert_prices_in_usd_cents, 
                :convert_json_photos_to_array, 
                :update_location_fields, 
                :update_size_fields
  validate      :validate_publishing
  after_commit  :delete_cache

  def publish!
    self.published = true
    self.save
  end

  def unpublish!
    self.published = false
    self.save
  end

  private
  
  def delete_cache
    delete_caches([])
  end
  
  def convert_json_photos_to_array
    self.photos = ActiveSupport::JSON.decode(self.photos) if photos_changed?
  end
  
  def save_amenities
    amenities.each_pair{ |field,v| self["amenities_#{field}"] = v } if self.amenities
  end
  
  # Convert all price fields into USD cents
  def convert_prices_in_usd_cents
    self.price_per_night_usd        = money_to_usd_cents(self.price_per_night,currency)         if price_per_night_changed? or currency_changed?
    self.price_per_week_usd         = money_to_usd_cents(self.price_per_week,currency)          if price_per_week_changed? or currency_changed?
    self.price_per_month_usd        = money_to_usd_cents(self.price_per_month,currency)         if price_per_month_changed? or currency_changed?
    self.price_final_cleanup_usd    = money_to_usd_cents(self.price_final_cleanup,currency)     if price_final_cleanup_changed? or currency_changed?
    self.price_security_deposit_usd = money_to_usd_cents(self.price_security_deposit,currency)  if price_security_deposit_changed? or currency_changed?
  end
  
  # Convert currency/money into USD cents
  def money_to_usd_cents(money, currency)
    money.to_money(currency).exchange_to(:USD).cents if money && currency
  end
  
  def update_location_fields
    if self.city_id_changed?
      self.state_id = self.city.state.id
      self.country_id = self.city.country.id
    end
  end
  
  def update_size_fields
    if (self.size_changed? or self.size_unit_changed?) && !self.size.blank? && !self.size_unit.blank?
      case size_unit
      when "meters"
        self.size_sqm = size
        self.size_sqf = size * 10.7639104
      when "feet"
        self.size_sqf = size
        self.size_sqm = size * 0.09290304
      end
    elsif (self.size_changed? or self.size_unit_changed?) && (self.size.blank? or self.size_unit.blank?)
      self.size = nil
      self.size_sqm = nil
      self.size_sqf = nil
      self.size_unit = nil
    end
  end
  
  # Adds validation errors if published column is affected and the place doesn't meet the requirements
  def validate_publishing
    if published_changed? && published == true
      errors.add(:publish, "123") if self.photos.blank? or self.photos.count < 1 # 1 picture
      errors.add(:publish, "124") if self.description.blank? or self.description.split.size < 5 # 5 words
      errors.add(:publish, "125") if self.availabilities.blank? or self.availabilities.count < 1 # at least one date
      errors.add(:publish, "126") if self.price_per_night.blank? && self.price_per_week.blank? && self.price_per_month.blank?
      errors.add(:publish, "127") if self.currency.blank?
      errors.add(:publish, "128") if self.price_security_deposit.blank?
    end
  end

end