# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20111101162814) do

  create_table "addresses", :force => true do |t|
    t.string   "street"
    t.string   "city"
    t.string   "country"
    t.string   "zip"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "authentications", :force => true do |t|
    t.integer  "user_id"
    t.string   "provider"
    t.string   "uid"
    t.string   "token"
    t.string   "secret"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "authentications", ["provider"], :name => "index_authentications_on_provider"
  add_index "authentications", ["user_id"], :name => "index_authentications_on_user_id"

  create_table "availabilities", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "place_id"
    t.date     "date_start"
    t.date     "date_end"
    t.integer  "price_per_night"
    t.string   "comment"
  end

  add_index "availabilities", ["place_id"], :name => "index_availabilities_on_place_id"

  create_table "cities", :force => true do |t|
    t.integer "geo_id"
    t.string  "geo_name",            :limit => 200,  :default => "",  :null => false
    t.string  "geo_ansiname",        :limit => 200,  :default => "",  :null => false
    t.string  "geo_alternate_names", :limit => 2000, :default => "",  :null => false
    t.float   "geo_latitude",                        :default => 0.0, :null => false
    t.float   "geo_longitude",                       :default => 0.0, :null => false
    t.string  "geo_feature_class",   :limit => 1
    t.string  "geo_feature_code",    :limit => 10
    t.string  "geo_country_code",    :limit => 2
    t.string  "geo_country_code2",   :limit => 60
    t.string  "geo_admin1_code",     :limit => 20,   :default => ""
    t.string  "geo_admin2_code",     :limit => 80,   :default => ""
    t.string  "geo_admin3_code",     :limit => 20,   :default => ""
    t.string  "geo_admin4_code",     :limit => 20,   :default => ""
    t.integer "geo_population",      :limit => 8,    :default => 0
    t.integer "geo_elevation",                       :default => 0
    t.integer "geo_gtopo30",                         :default => 0
    t.string  "geo_timezone",        :limit => 40
    t.date    "geo_mod_date"
  end

  add_index "cities", ["geo_country_code"], :name => "index_cities_on_geo_country_code"
  add_index "cities", ["geo_feature_class"], :name => "index_cities_on_geo_feature_class"
  add_index "cities", ["geo_feature_code"], :name => "index_cities_on_geo_feature_code"
  add_index "cities", ["geo_id"], :name => "index_cities_on_geo_id"

  create_table "countries", :force => true do |t|
    t.string  "code_iso",             :limit => 2
    t.string  "code_iso3",            :limit => 3
    t.integer "code_iso_numeric",                    :default => 0
    t.string  "fips",                 :limit => 2
    t.string  "name",                 :limit => 200, :default => "", :null => false
    t.string  "capital",              :limit => 200, :default => "", :null => false
    t.integer "area",                 :limit => 8,   :default => 0
    t.integer "population",           :limit => 8,   :default => 0
    t.string  "continent",            :limit => 2
    t.string  "tld",                  :limit => 3
    t.string  "currency_code",        :limit => 3
    t.string  "currency_name",        :limit => 200
    t.string  "phone",                :limit => 80
    t.string  "postal_code_format",   :limit => 80
    t.string  "postal_code_regex",    :limit => 200
    t.string  "languages",            :limit => 200
    t.integer "geonameid"
    t.string  "neighbours",           :limit => 200
    t.string  "equivalent_fips_code", :limit => 2
  end

  add_index "countries", ["code_iso"], :name => "index_countries_on_code_iso"
  add_index "countries", ["code_iso3"], :name => "index_countries_on_code_iso3"
  add_index "countries", ["continent"], :name => "index_countries_on_continent"
  add_index "countries", ["geonameid"], :name => "index_countries_on_geonameid"

  create_table "place_types", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "places", :force => true do |t|
    t.integer  "user_id"
    t.boolean  "published",                  :default => false
    t.string   "title"
    t.text     "description"
    t.integer  "place_type_id"
    t.integer  "num_bedrooms"
    t.integer  "num_beds"
    t.integer  "num_bathrooms"
    t.float    "sqm"
    t.integer  "max_guests"
    t.text     "photos"
    t.integer  "city_id"
    t.integer  "state_id"
    t.integer  "country_id"
    t.string   "address_1"
    t.string   "address_2"
    t.string   "zip"
    t.float    "lat"
    t.float    "lon"
    t.text     "directions"
    t.boolean  "amenities_aircon",           :default => false
    t.boolean  "amenities_breakfast",        :default => false
    t.boolean  "amenities_buzzer_intercom",  :default => false
    t.boolean  "amenities_cable_tv",         :default => false
    t.boolean  "amenities_dryer",            :default => false
    t.boolean  "amenities_doorman",          :default => false
    t.boolean  "amenities_elevator",         :default => false
    t.boolean  "amenities_family_friendly",  :default => false
    t.boolean  "amenities_gym",              :default => false
    t.boolean  "amenities_hot_tub",          :default => false
    t.boolean  "amenities_kitchen",          :default => false
    t.boolean  "amenities_handicap",         :default => false
    t.boolean  "amenities_heating",          :default => false
    t.boolean  "amenities_hot_water",        :default => false
    t.boolean  "amenities_internet",         :default => false
    t.boolean  "amenities_internet_wifi",    :default => false
    t.boolean  "amenities_jacuzzi",          :default => false
    t.boolean  "amenities_parking_included", :default => false
    t.boolean  "amenities_pets_allowed",     :default => false
    t.boolean  "amenities_pool",             :default => false
    t.boolean  "amenities_smoking_allowed",  :default => false
    t.boolean  "amenities_suitable_events",  :default => false
    t.boolean  "amenities_tennis",           :default => false
    t.boolean  "amenities_tv",               :default => false
    t.boolean  "amenities_washer",           :default => false
    t.string   "currency"
    t.integer  "price_per_night"
    t.integer  "price_per_week"
    t.integer  "price_per_month"
    t.integer  "price_final_cleanup",        :default => 0
    t.integer  "price_security_deposit",     :default => 0
    t.integer  "price_per_night_usd"
    t.integer  "price_per_week_usd"
    t.integer  "price_per_month_usd"
    t.string   "check_in_after"
    t.string   "check_out_before"
    t.integer  "minimum_stay_days",          :default => 0
    t.integer  "maximum_stay_days",          :default => 0
    t.text     "house_rules"
    t.integer  "cancellation_policy",        :default => 1
    t.float    "reviews_overall",            :default => 0.0
    t.float    "reviews_accuracy_avg",       :default => 0.0
    t.float    "reviews_cleanliness_avg",    :default => 0.0
    t.float    "reviews_checkin_avg",        :default => 0.0
    t.float    "reviews_communication_avg",  :default => 0.0
    t.float    "reviews_location_avg",       :default => 0.0
    t.float    "reviews_value_avg",          :default => 0.0
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "price_final_cleanup_usd"
    t.integer  "price_security_deposit_usd"
  end

  add_index "places", ["amenities_aircon"], :name => "index_places_on_amenities_aircon"
  add_index "places", ["amenities_breakfast"], :name => "index_places_on_amenities_breakfast"
  add_index "places", ["amenities_buzzer_intercom"], :name => "index_places_on_amenities_buzzer_intercom"
  add_index "places", ["amenities_cable_tv"], :name => "index_places_on_amenities_cable_tv"
  add_index "places", ["amenities_doorman"], :name => "index_places_on_amenities_doorman"
  add_index "places", ["amenities_dryer"], :name => "index_places_on_amenities_dryer"
  add_index "places", ["amenities_elevator"], :name => "index_places_on_amenities_elevator"
  add_index "places", ["amenities_family_friendly"], :name => "index_places_on_amenities_family_friendly"
  add_index "places", ["amenities_gym"], :name => "index_places_on_amenities_gym"
  add_index "places", ["amenities_handicap"], :name => "index_places_on_amenities_handicap"
  add_index "places", ["amenities_heating"], :name => "index_places_on_amenities_heating"
  add_index "places", ["amenities_hot_tub"], :name => "index_places_on_amenities_hot_tub"
  add_index "places", ["amenities_hot_water"], :name => "index_places_on_amenities_hot_water"
  add_index "places", ["amenities_internet"], :name => "index_places_on_amenities_internet"
  add_index "places", ["amenities_internet_wifi"], :name => "index_places_on_amenities_internet_wifi"
  add_index "places", ["amenities_jacuzzi"], :name => "index_places_on_amenities_jacuzzi"
  add_index "places", ["amenities_kitchen"], :name => "index_places_on_amenities_kitchen"
  add_index "places", ["amenities_parking_included"], :name => "index_places_on_amenities_parking_included"
  add_index "places", ["amenities_pets_allowed"], :name => "index_places_on_amenities_pets_allowed"
  add_index "places", ["amenities_pool"], :name => "index_places_on_amenities_pool"
  add_index "places", ["amenities_smoking_allowed"], :name => "index_places_on_amenities_smoking_allowed"
  add_index "places", ["amenities_suitable_events"], :name => "index_places_on_amenities_suitable_events"
  add_index "places", ["amenities_tennis"], :name => "index_places_on_amenities_tennis"
  add_index "places", ["amenities_tv"], :name => "index_places_on_amenities_tv"
  add_index "places", ["amenities_washer"], :name => "index_places_on_amenities_washer"
  add_index "places", ["city_id"], :name => "index_places_on_city_id"
  add_index "places", ["country_id"], :name => "index_places_on_country_id"
  add_index "places", ["place_type_id"], :name => "index_places_on_place_type_id"
  add_index "places", ["state_id"], :name => "index_places_on_province_id"
  add_index "places", ["user_id"], :name => "index_places_on_user_id"

  create_table "states", :force => true do |t|
    t.integer "geo_id"
    t.string  "geo_name",            :limit => 200,  :default => "",  :null => false
    t.string  "geo_ansiname",        :limit => 200,  :default => "",  :null => false
    t.string  "geo_alternate_names", :limit => 2000, :default => "",  :null => false
    t.float   "geo_latitude",                        :default => 0.0, :null => false
    t.float   "geo_longitude",                       :default => 0.0, :null => false
    t.string  "geo_feature_class",   :limit => 1
    t.string  "geo_feature_code",    :limit => 10
    t.string  "geo_country_code",    :limit => 2
    t.string  "geo_country_code2",   :limit => 60
    t.string  "geo_admin1_code",     :limit => 20,   :default => ""
    t.string  "geo_admin2_code",     :limit => 80,   :default => ""
    t.string  "geo_admin3_code",     :limit => 20,   :default => ""
    t.string  "geo_admin4_code",     :limit => 20,   :default => ""
    t.integer "geo_population",      :limit => 8,    :default => 0
    t.integer "geo_elevation",                       :default => 0
    t.integer "geo_gtopo30",                         :default => 0
    t.string  "geo_timezone",        :limit => 40
    t.date    "geo_mod_date"
  end

  add_index "states", ["geo_country_code"], :name => "index_states_on_geo_country_code"
  add_index "states", ["geo_feature_class"], :name => "index_states_on_geo_feature_class"
  add_index "states", ["geo_feature_code"], :name => "index_states_on_geo_feature_code"
  add_index "states", ["geo_id"], :name => "index_states_on_geo_id"

  create_table "users", :force => true do |t|
    t.string   "email",                                 :default => "", :null => false
    t.string   "encrypted_password",     :limit => 128, :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.string   "remember_token"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                         :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "password_salt"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "authentication_token"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "gender"
    t.date     "birthdate"
    t.string   "timezone"
    t.string   "phone_home"
    t.string   "phone_mobile"
    t.string   "phone_work"
    t.string   "avatar_file_name"
    t.string   "avatar_content_type"
    t.integer  "avatar_file_size"
    t.datetime "avatar_updated_at"
    t.string   "first_name"
    t.string   "last_name"
  end

  add_index "users", ["authentication_token"], :name => "index_users_on_authentication_token", :unique => true
  add_index "users", ["confirmation_token"], :name => "index_users_on_confirmation_token", :unique => true
  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

end
