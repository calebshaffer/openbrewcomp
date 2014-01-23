# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 3) do

  create_table "awards", :force => true do |t|
    t.string  "name",            :limit => 60,                   :null => false
    t.boolean "point_qualifier",               :default => true, :null => false
    t.integer "position"
    t.integer "category_id",                                     :null => false
  end

  add_index "awards", ["category_id"], :name => "category_id"

  create_table "carbonation", :force => true do |t|
    t.string  "description", :limit => 40, :null => false
    t.integer "position",                  :null => false
  end

  create_table "categories", :force => true do |t|
    t.string  "name",      :limit => 60,                   :null => false
    t.boolean "is_public",               :default => true, :null => false
    t.integer "position"
  end

  create_table "category_preferences", :force => true do |t|
    t.integer "judge_id",    :null => false
    t.integer "category_id", :null => false
  end

  add_index "category_preferences", ["judge_id"], :name => "judge_id"
  add_index "category_preferences", ["category_id"], :name => "category_id"

  create_table "clubs", :force => true do |t|
    t.string "name", :limit => 80, :null => false
  end

  add_index "clubs", ["name"], :name => "index_clubs_on_name"

  create_table "competition_data", :force => true do |t|
    t.string   "name",                                                 :null => false
    t.boolean  "mcab",                              :default => false, :null => false
    t.string   "local_timezone",                    :default => "UTC", :null => false
    t.date     "competition_date"
    t.integer  "competition_number"
    t.datetime "competition_start_time_utc"
    t.datetime "entry_registration_start_time_utc"
    t.datetime "entry_registration_end_time_utc"
    t.datetime "judge_registration_start_time_utc"
    t.datetime "judge_registration_end_time_utc"
  end

  create_table "contacts", :force => true do |t|
    t.string   "role",       :limit => 40,  :null => false
    t.string   "name",       :limit => 80,  :null => false
    t.string   "email",      :limit => 100, :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "countries", :force => true do |t|
    t.string  "name",                 :limit => 80,                                                        :null => false
    t.string  "country_code",         :limit => 2,                                                         :null => false
    t.string  "postcode_pattern"
    t.string  "postcode_canonify"
    t.string  "address_format",                     :default => "%q{\"\#{name}\n\#{address}\n\#{city}\"}", :null => false
    t.string  "address_alignment",    :limit => 1,  :default => "l",                                       :null => false
    t.string  "region_name",          :limit => 40
    t.boolean "region_name_optional",               :default => false,                                     :null => false
    t.string  "country_address_name", :limit => 60
    t.boolean "is_selectable",                      :default => false,                                     :null => false
  end

  add_index "countries", ["country_code"], :name => "index_countries_on_country_code", :unique => true
  add_index "countries", ["is_selectable"], :name => "index_countries_on_is_selectable"

  create_table "entrants", :force => true do |t|
    t.string   "first_name",   :limit => 80,  :default => "",    :null => false
    t.string   "middle_name",  :limit => 80,  :default => "",    :null => false
    t.string   "last_name",    :limit => 80,  :default => "",    :null => false
    t.string   "team_name",    :limit => 80,  :default => "",    :null => false
    t.string   "address1",     :limit => 80,  :default => "",    :null => false
    t.string   "address2",     :limit => 80,  :default => "",    :null => false
    t.string   "address3",     :limit => 80,  :default => "",    :null => false
    t.string   "address4",     :limit => 80,  :default => "",    :null => false
    t.string   "city",         :limit => 80,  :default => "",    :null => false
    t.string   "team_members",                :default => "",    :null => false
    t.boolean  "is_team",                     :default => false, :null => false
    t.string   "postcode",     :limit => 20,  :default => "",    :null => false
    t.string   "email",        :limit => 100, :default => "",    :null => false
    t.string   "phone",        :limit => 40,  :default => "",    :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "region_id"
    t.integer  "country_id",                                     :null => false
    t.integer  "club_id",                                        :null => false
    t.integer  "user_id",                                        :null => false
  end

  add_index "entrants", ["region_id"], :name => "region_id"
  add_index "entrants", ["country_id"], :name => "country_id"
  add_index "entrants", ["club_id"], :name => "club_id"
  add_index "entrants", ["user_id"], :name => "user_id"

  create_table "entries", :force => true do |t|
    t.string   "name",              :limit => 80, :default => "",    :null => false
    t.text     "style_info"
    t.text     "competition_notes"
    t.boolean  "odd_bottle",                      :default => false, :null => false
    t.boolean  "second_round",                    :default => false, :null => false
    t.boolean  "mcab_qe",                         :default => false, :null => false
    t.integer  "bottle_code"
    t.integer  "place"
    t.integer  "bos_place"
    t.boolean  "send_award"
    t.boolean  "send_bos_award"
    t.boolean  "is_paid",                         :default => false, :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "base_style_id"
    t.integer  "carbonation_id"
    t.integer  "strength_id"
    t.integer  "sweetness_id"
    t.integer  "entrant_id",                                         :null => false
    t.integer  "user_id",                                            :null => false
    t.integer  "style_id",                                           :null => false
    t.string   "catnum_code",       :limit => 8
  end

  add_index "entries", ["base_style_id"], :name => "base_style_id"
  add_index "entries", ["carbonation_id"], :name => "carbonation_id"
  add_index "entries", ["strength_id"], :name => "strength_id"
  add_index "entries", ["sweetness_id"], :name => "sweetness_id"
  add_index "entries", ["entrant_id"], :name => "entrant_id"
  add_index "entries", ["user_id"], :name => "user_id"
  add_index "entries", ["style_id"], :name => "style_id"

  create_table "entries_flights", :id => false, :force => true do |t|
    t.integer "entry_id",  :null => false
    t.integer "flight_id", :null => false
  end

  add_index "entries_flights", ["flight_id"], :name => "flight_id"
  add_index "entries_flights", ["entry_id", "flight_id"], :name => "index_entries_flights_on_entry_id_and_flight_id"

  create_table "entries_orders", :id => false, :force => true do |t|
    t.integer "entry_id", :null => false
    t.integer "order_id", :null => false
  end

  add_index "entries_orders", ["order_id"], :name => "order_id"
  add_index "entries_orders", ["entry_id", "order_id"], :name => "index_entries_orders_on_entry_id_and_order_id"

  create_table "flights", :force => true do |t|
    t.string   "name",               :limit => 60,                    :null => false
    t.boolean  "assigned",                         :default => false, :null => false
    t.boolean  "completed",                        :default => false, :null => false
    t.datetime "assigned_at"
    t.datetime "completed_at"
    t.integer  "round_id",                                            :null => false
    t.integer  "award_id",                                            :null => false
    t.integer  "judging_session_id"
  end

  add_index "flights", ["round_id"], :name => "round_id"
  add_index "flights", ["award_id"], :name => "award_id"
  add_index "flights", ["judging_session_id"], :name => "judging_session_id"

  create_table "judge_ranks", :force => true do |t|
    t.string  "description", :limit => 40,                   :null => false
    t.boolean "bjcp",                      :default => true, :null => false
    t.integer "position",                                    :null => false
  end

  create_table "judges", :force => true do |t|
    t.string   "first_name",    :limit => 80,                                :default => "",    :null => false
    t.string   "middle_name",   :limit => 80,                                :default => "",    :null => false
    t.string   "last_name",     :limit => 80,                                :default => "",    :null => false
    t.string   "goes_by",       :limit => 80,                                :default => "",    :null => false
    t.string   "address1",      :limit => 80,                                :default => "",    :null => false
    t.string   "address2",      :limit => 80,                                :default => "",    :null => false
    t.string   "address3",      :limit => 80,                                :default => "",    :null => false
    t.string   "address4",      :limit => 80,                                :default => "",    :null => false
    t.string   "city",          :limit => 80,                                :default => "",    :null => false
    t.string   "postcode",      :limit => 20,                                :default => "",    :null => false
    t.string   "email",         :limit => 100,                               :default => "",    :null => false
    t.string   "phone",         :limit => 40,                                :default => "",    :null => false
    t.string   "judge_number",  :limit => 10
    t.text     "comments"
    t.decimal  "staff_points",                 :precision => 3, :scale => 1
    t.boolean  "confirmed"
    t.boolean  "checked_in",                                                 :default => false, :null => false
    t.boolean  "organizer",                                                  :default => false, :null => false
    t.string   "access_key",    :limit => 32,                                :default => "",    :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "region_id"
    t.integer  "country_id"
    t.integer  "club_id"
    t.integer  "judge_rank_id"
    t.integer  "user_id",                                                                       :null => false
  end

  add_index "judges", ["region_id"], :name => "region_id"
  add_index "judges", ["country_id"], :name => "country_id"
  add_index "judges", ["club_id"], :name => "club_id"
  add_index "judges", ["judge_rank_id"], :name => "judge_rank_id"
  add_index "judges", ["user_id"], :name => "user_id"

  create_table "judging_sessions", :force => true do |t|
    t.string   "description", :null => false
    t.date     "date",        :null => false
    t.integer  "position"
    t.datetime "start_time"
    t.datetime "end_time"
  end

  add_index "judging_sessions", ["start_time", "end_time"], :name => "index_judging_sessions_on_start_time_and_end_time"

  create_table "judgings", :force => true do |t|
    t.string  "role",      :limit => 1, :default => "", :null => false
    t.integer "flight_id",                              :null => false
    t.integer "judge_id",                               :null => false
  end

  add_index "judgings", ["flight_id"], :name => "flight_id"
  add_index "judgings", ["judge_id"], :name => "judge_id"

  create_table "news_items", :force => true do |t|
    t.string   "title",               :null => false
    t.text     "description_raw",     :null => false
    t.text     "description_encoded", :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "author_id",           :null => false
  end

  add_index "news_items", ["author_id"], :name => "author_id"

  create_table "open_id_authentication_associations", :force => true do |t|
    t.integer "issued"
    t.integer "lifetime"
    t.string  "handle"
    t.string  "assoc_type"
    t.binary  "server_url"
    t.binary  "secret"
  end

  create_table "open_id_authentication_nonces", :force => true do |t|
    t.integer "timestamp",  :null => false
    t.string  "server_url"
    t.string  "salt",       :null => false
  end

  create_table "orders", :force => true do |t|
    t.string  "paypal_transaction_id"
    t.string  "paypal_payer_id"
    t.string  "paypal_express_checkout_token"
    t.boolean "is_paid",                       :default => false, :null => false
    t.integer "entrant_id"
    t.integer "user_id"
  end

  add_index "orders", ["entrant_id"], :name => "entrant_id"
  add_index "orders", ["user_id"], :name => "user_id"
  add_index "orders", ["paypal_transaction_id"], :name => "index_orders_on_paypal_transaction_id"
  add_index "orders", ["paypal_payer_id"], :name => "index_orders_on_paypal_payer_id"
  add_index "orders", ["paypal_express_checkout_token"], :name => "index_orders_on_paypal_express_checkout_token"

  create_table "passwords", :force => true do |t|
    t.string   "reset_code"
    t.datetime "expires_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id",    :null => false
  end

  add_index "passwords", ["user_id"], :name => "user_id"

  create_table "point_allocations", :force => true do |t|
    t.integer "min_entries",                               :null => false
    t.integer "max_entries",                               :null => false
    t.decimal "organizer",   :precision => 3, :scale => 1, :null => false
    t.decimal "staff",       :precision => 3, :scale => 1, :null => false
    t.decimal "judge",       :precision => 3, :scale => 1, :null => false
  end

  create_table "regions", :force => true do |t|
    t.string  "name",        :limit => 80, :null => false
    t.string  "region_code", :limit => 6
    t.integer "country_id",                :null => false
  end

  add_index "regions", ["country_id", "region_code"], :name => "index_regions_on_country_id_and_region_code", :unique => true

  create_table "rights", :force => true do |t|
    t.string "name",        :limit => 60, :null => false
    t.string "description"
    t.string "controller",  :limit => 40, :null => false
    t.string "action",      :limit => 40, :null => false
  end

  create_table "rights_roles", :id => false, :force => true do |t|
    t.integer "right_id", :null => false
    t.integer "role_id",  :null => false
  end

  add_index "rights_roles", ["right_id"], :name => "right_id"
  add_index "rights_roles", ["role_id"], :name => "role_id"

  create_table "roles", :force => true do |t|
    t.string "name",        :limit => 60, :null => false
    t.string "description"
  end

  create_table "roles_users", :id => false, :force => true do |t|
    t.integer "role_id", :null => false
    t.integer "user_id", :null => false
  end

  add_index "roles_users", ["role_id"], :name => "role_id"
  add_index "roles_users", ["user_id"], :name => "user_id"

  create_table "rounds", :force => true do |t|
    t.string  "name",     :limit => 20, :null => false
    t.integer "position",               :null => false
  end

  add_index "rounds", ["position"], :name => "index_rounds_on_position"

  create_table "scores", :force => true do |t|
    t.decimal "score",     :precision => 4, :scale => 2, :null => false
    t.integer "entry_id",                                :null => false
    t.integer "judge_id",                                :null => false
    t.integer "flight_id",                               :null => false
  end

  add_index "scores", ["entry_id"], :name => "entry_id"
  add_index "scores", ["judge_id"], :name => "judge_id"
  add_index "scores", ["flight_id"], :name => "flight_id"

  create_table "sessions", :force => true do |t|
    t.string   "session_id", :null => false
    t.text     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sessions", ["session_id"], :name => "index_sessions_on_session_id"
  add_index "sessions", ["updated_at"], :name => "index_sessions_on_updated_at"

  create_table "strength", :force => true do |t|
    t.string  "description", :limit => 40, :null => false
    t.integer "position",                  :null => false
  end

  create_table "styles", :force => true do |t|
    t.string  "name",                   :limit => 60,                    :null => false
    t.integer "bjcp_category",                                           :null => false
    t.string  "bjcp_subcategory",       :limit => 1,  :default => "",    :null => false
    t.text    "description_url"
    t.boolean "mcab_style",                           :default => true,  :null => false
    t.boolean "point_qualifier",                      :default => true,  :null => false
    t.boolean "require_carbonation",                  :default => false, :null => false
    t.boolean "require_strength",                     :default => false, :null => false
    t.boolean "require_sweetness",                    :default => false, :null => false
    t.boolean "optional_classic_style",               :default => false, :null => false
    t.string  "styleinfo",              :limit => 1,  :default => "n",   :null => false
    t.integer "award_id",                                                :null => false
  end

  add_index "styles", ["bjcp_category", "bjcp_subcategory"], :name => "index_styles_on_bjcp_category_and_bjcp_subcategory", :unique => true
  add_index "styles", ["award_id"], :name => "award_id"

  create_table "sweetness", :force => true do |t|
    t.string  "description", :limit => 40, :null => false
    t.integer "position",                  :null => false
  end

  create_table "time_availabilities", :force => true do |t|
    t.datetime "start_time"
    t.datetime "end_time"
    t.integer  "judge_id",   :null => false
  end

  add_index "time_availabilities", ["judge_id"], :name => "judge_id"

  create_table "users", :force => true do |t|
    t.string   "login",                     :limit => 40,                     :null => false
    t.string   "identity_url"
    t.string   "crypted_password"
    t.string   "salt"
    t.string   "remember_token"
    t.string   "name",                      :limit => 80
    t.string   "email",                     :limit => 100
    t.boolean  "enabled",                                  :default => true,  :null => false
    t.boolean  "is_admin",                                 :default => false, :null => false
    t.boolean  "is_anonymous",                             :default => false, :null => false
    t.datetime "remember_token_expires_at"
    t.datetime "last_logon_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["login", "identity_url"], :name => "index_users_on_login_and_identity_url", :unique => true
  add_index "users", ["email", "identity_url"], :name => "index_users_on_email_and_identity_url", :unique => true
  add_index "users", ["identity_url"], :name => "index_users_on_identity_url", :unique => true
  add_index "users", ["login"], :name => "index_users_on_login"

  add_foreign_key "awards", ["category_id"], "categories", ["id"], :name => "awards_ibfk_1"

  add_foreign_key "category_preferences", ["judge_id"], "judges", ["id"], :name => "category_preferences_ibfk_1"
  add_foreign_key "category_preferences", ["category_id"], "categories", ["id"], :name => "category_preferences_ibfk_2"

  add_foreign_key "entrants", ["region_id"], "regions", ["id"], :name => "entrants_ibfk_1"
  add_foreign_key "entrants", ["country_id"], "countries", ["id"], :name => "entrants_ibfk_2"
  add_foreign_key "entrants", ["club_id"], "clubs", ["id"], :name => "entrants_ibfk_3"
  add_foreign_key "entrants", ["user_id"], "users", ["id"], :name => "entrants_ibfk_4"

  add_foreign_key "entries", ["base_style_id"], "styles", ["id"], :name => "entries_ibfk_1"
  add_foreign_key "entries", ["carbonation_id"], "carbonation", ["id"], :name => "entries_ibfk_2"
  add_foreign_key "entries", ["strength_id"], "strength", ["id"], :name => "entries_ibfk_3"
  add_foreign_key "entries", ["sweetness_id"], "sweetness", ["id"], :name => "entries_ibfk_4"
  add_foreign_key "entries", ["entrant_id"], "entrants", ["id"], :name => "entries_ibfk_5"
  add_foreign_key "entries", ["user_id"], "users", ["id"], :name => "entries_ibfk_6"
  add_foreign_key "entries", ["style_id"], "styles", ["id"], :name => "entries_ibfk_7"

  add_foreign_key "entries_flights", ["entry_id"], "entries", ["id"], :name => "entries_flights_ibfk_1"
  add_foreign_key "entries_flights", ["flight_id"], "flights", ["id"], :name => "entries_flights_ibfk_2"

  add_foreign_key "entries_orders", ["entry_id"], "entries", ["id"], :name => "entries_orders_ibfk_1"
  add_foreign_key "entries_orders", ["order_id"], "orders", ["id"], :name => "entries_orders_ibfk_2"

  add_foreign_key "flights", ["round_id"], "rounds", ["id"], :name => "flights_ibfk_1"
  add_foreign_key "flights", ["award_id"], "awards", ["id"], :name => "flights_ibfk_2"
  add_foreign_key "flights", ["judging_session_id"], "judging_sessions", ["id"], :name => "flights_ibfk_3"

  add_foreign_key "judges", ["region_id"], "regions", ["id"], :name => "judges_ibfk_1"
  add_foreign_key "judges", ["country_id"], "countries", ["id"], :name => "judges_ibfk_2"
  add_foreign_key "judges", ["club_id"], "clubs", ["id"], :name => "judges_ibfk_3"
  add_foreign_key "judges", ["judge_rank_id"], "judge_ranks", ["id"], :name => "judges_ibfk_4"
  add_foreign_key "judges", ["user_id"], "users", ["id"], :name => "judges_ibfk_5"

  add_foreign_key "judgings", ["flight_id"], "flights", ["id"], :name => "judgings_ibfk_1"
  add_foreign_key "judgings", ["judge_id"], "judges", ["id"], :name => "judgings_ibfk_2"

  add_foreign_key "news_items", ["author_id"], "users", ["id"], :name => "news_items_ibfk_1"

  add_foreign_key "orders", ["entrant_id"], "entrants", ["id"], :name => "orders_ibfk_1"
  add_foreign_key "orders", ["user_id"], "users", ["id"], :name => "orders_ibfk_2"

  add_foreign_key "passwords", ["user_id"], "users", ["id"], :name => "passwords_ibfk_1"

  add_foreign_key "regions", ["country_id"], "countries", ["id"], :name => "regions_ibfk_1"

  add_foreign_key "rights_roles", ["right_id"], "rights", ["id"], :name => "rights_roles_ibfk_1"
  add_foreign_key "rights_roles", ["role_id"], "roles", ["id"], :name => "rights_roles_ibfk_2"

  add_foreign_key "roles_users", ["role_id"], "roles", ["id"], :name => "roles_users_ibfk_1"
  add_foreign_key "roles_users", ["user_id"], "users", ["id"], :name => "roles_users_ibfk_2"

  add_foreign_key "scores", ["entry_id"], "entries", ["id"], :name => "scores_ibfk_1"
  add_foreign_key "scores", ["judge_id"], "judges", ["id"], :name => "scores_ibfk_2"
  add_foreign_key "scores", ["flight_id"], "flights", ["id"], :name => "scores_ibfk_3"

  add_foreign_key "styles", ["award_id"], "awards", ["id"], :name => "styles_ibfk_1"

  add_foreign_key "time_availabilities", ["judge_id"], "judges", ["id"], :name => "time_availabilities_ibfk_1"

end
