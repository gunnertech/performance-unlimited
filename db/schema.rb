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

ActiveRecord::Schema.define(:version => 20150307200048) do

  create_table "alerts", :force => true do |t|
    t.string   "alertable_type"
    t.integer  "alertable_id"
    t.string   "message"
    t.integer  "metric_id"
    t.float    "threshold_minimum"
    t.float    "threshold_maximum"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
  end

  add_index "alerts", ["alertable_id", "alertable_type"], :name => "index_alerts_on_alertable_id_and_alertable_type"
  add_index "alerts", ["metric_id"], :name => "index_alerts_on_metric_id"

  create_table "assigned_alerts", :force => true do |t|
    t.integer  "user_id"
    t.integer  "alert_id"
    t.integer  "recorded_metric_id"
    t.date     "date"
    t.boolean  "cleared"
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
  end

  add_index "assigned_alerts", ["alert_id"], :name => "index_assigned_alerts_on_alert_id"
  add_index "assigned_alerts", ["recorded_metric_id"], :name => "index_assigned_alerts_on_recorded_metric_id"
  add_index "assigned_alerts", ["user_id"], :name => "index_assigned_alerts_on_user_id"

  create_table "assigned_divisions", :force => true do |t|
    t.integer  "division_id"
    t.integer  "user_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "assigned_divisions", ["division_id"], :name => "index_assigned_divisions_on_division_id"
  add_index "assigned_divisions", ["user_id"], :name => "index_assigned_divisions_on_user_id"

  create_table "assigned_groups", :force => true do |t|
    t.integer  "group_id"
    t.integer  "user_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.integer  "position"
  end

  add_index "assigned_groups", ["group_id"], :name => "index_assigned_groups_on_group_id"
  add_index "assigned_groups", ["user_id"], :name => "index_assigned_groups_on_user_id"

  create_table "assigned_locales", :force => true do |t|
    t.integer  "locale_id"
    t.integer  "organization_id"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  add_index "assigned_locales", ["locale_id"], :name => "index_assigned_locales_on_locale_id"
  add_index "assigned_locales", ["organization_id"], :name => "index_assigned_locales_on_organization_id"

  create_table "assigned_question_sets", :force => true do |t|
    t.integer  "question_set_id"
    t.integer  "survey_id"
    t.integer  "position"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  add_index "assigned_question_sets", ["question_set_id"], :name => "index_assigned_question_sets_on_question_set_id"
  add_index "assigned_question_sets", ["survey_id"], :name => "index_assigned_question_sets_on_survey_id"

  create_table "assigned_questions", :force => true do |t|
    t.integer  "question_id"
    t.integer  "question_set_id"
    t.integer  "position"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  add_index "assigned_questions", ["question_id"], :name => "index_assigned_questions_on_question_id"
  add_index "assigned_questions", ["question_set_id"], :name => "index_assigned_questions_on_question_set_id"

  create_table "assigned_surveys", :force => true do |t|
    t.integer  "survey_id"
    t.integer  "division_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "assigned_surveys", ["division_id"], :name => "index_assigned_surveys_on_division_id"
  add_index "assigned_surveys", ["survey_id"], :name => "index_assigned_surveys_on_survey_id"

  create_table "authentications", :force => true do |t|
    t.string   "provider"
    t.string   "uid"
    t.string   "nickname"
    t.string   "token"
    t.string   "secret"
    t.string   "authenticationable_type"
    t.integer  "authenticationable_id"
    t.datetime "created_at",              :null => false
    t.datetime "updated_at",              :null => false
    t.string   "refresh_token"
  end

  add_index "authentications", ["authenticationable_id", "authenticationable_type"], :name => "a_id_and_a_type_on_authenticiations"
  add_index "authentications", ["authenticationable_type", "authenticationable_id"], :name => "a_type_and_a_id_on_authenticiations"

  create_table "comments", :force => true do |t|
    t.integer  "by_user_id"
    t.integer  "for_user_id"
    t.text     "body"
    t.integer  "metric_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "comments", ["by_user_id"], :name => "index_comments_on_by_user_id"
  add_index "comments", ["for_user_id"], :name => "index_comments_on_for_user_id"
  add_index "comments", ["metric_id"], :name => "index_comments_on_metric_id"

  create_table "completed_surveys", :force => true do |t|
    t.date     "date"
    t.integer  "user_id"
    t.integer  "survey_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.integer  "score"
  end

  add_index "completed_surveys", ["survey_id"], :name => "index_completed_surveys_on_survey_id"
  add_index "completed_surveys", ["user_id"], :name => "index_completed_surveys_on_user_id"

  create_table "data_files", :force => true do |t|
    t.string   "data_fileable_type"
    t.integer  "data_fileable_id"
    t.text     "file_contents"
    t.boolean  "processing",         :default => false
    t.datetime "created_at",                            :null => false
    t.datetime "updated_at",                            :null => false
  end

  add_index "data_files", ["data_fileable_type", "data_fileable_id"], :name => "index_data_files_on_data_fileable_type_and_data_fileable_id"

  create_table "delayed_jobs", :force => true do |t|
    t.integer  "priority",   :default => 0, :null => false
    t.integer  "attempts",   :default => 0, :null => false
    t.text     "handler",                   :null => false
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.string   "queue"
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
  end

  add_index "delayed_jobs", ["priority", "run_at"], :name => "delayed_jobs_priority"

  create_table "divisions", :force => true do |t|
    t.string   "name"
    t.integer  "organization_id"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
    t.string   "time_zone"
    t.text     "file_contents"
  end

  add_index "divisions", ["organization_id"], :name => "index_divisions_on_organization_id"

  create_table "groups", :force => true do |t|
    t.string   "name"
    t.integer  "division_id"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
    t.integer  "position"
    t.text     "file_contents"
  end

  add_index "groups", ["division_id"], :name => "index_groups_on_division_id"

  create_table "locales", :force => true do |t|
    t.string   "code"
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "mapped_domains", :force => true do |t|
    t.string   "domain"
    t.integer  "organization_id"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  add_index "mapped_domains", ["domain"], :name => "index_mapped_domains_on_domain"
  add_index "mapped_domains", ["organization_id"], :name => "index_mapped_domains_on_organization_id"

  create_table "metric_types", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "metrics", :force => true do |t|
    t.integer  "metric_type_id"
    t.integer  "organization_id"
    t.string   "name"
    t.integer  "decimal_places"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
    t.string   "note"
    t.integer  "position"
  end

  add_index "metrics", ["metric_type_id"], :name => "index_metrics_on_metric_type_id"
  add_index "metrics", ["organization_id"], :name => "index_metrics_on_organization_id"

  create_table "organizations", :force => true do |t|
    t.string   "name"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
    t.string   "logo_file_name"
    t.string   "logo_content_type"
    t.integer  "logo_file_size"
    t.datetime "logo_updated_at"
    t.text     "file_contents"
  end

  create_table "point_ranges", :force => true do |t|
    t.integer  "assigned_survey_id"
    t.integer  "low"
    t.integer  "high"
    t.text     "description"
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
    t.string   "name"
  end

  add_index "point_ranges", ["assigned_survey_id"], :name => "index_point_ranges_on_assigned_survey_id"
  add_index "point_ranges", ["name"], :name => "index_point_ranges_on_name"

  create_table "question_set_translations", :force => true do |t|
    t.integer  "question_set_id"
    t.string   "locale"
    t.string   "name"
    t.text     "description"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  add_index "question_set_translations", ["locale"], :name => "index_question_set_translations_on_locale"
  add_index "question_set_translations", ["question_set_id"], :name => "index_27164766fcab2655b2334a8cb601370f4fbbcec2"

  create_table "question_sets", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
    t.integer  "organization_id"
  end

  add_index "question_sets", ["organization_id"], :name => "index_question_sets_on_organization_id"

  create_table "question_translations", :force => true do |t|
    t.integer  "question_id"
    t.string   "locale"
    t.string   "short_text"
    t.text     "long_text"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "question_translations", ["locale"], :name => "index_question_translations_on_locale"
  add_index "question_translations", ["question_id"], :name => "index_question_translations_on_question_id"

  create_table "questions", :force => true do |t|
    t.string   "short_text"
    t.text     "long_text"
    t.datetime "created_at",                                  :null => false
    t.datetime "updated_at",                                  :null => false
    t.integer  "organization_id"
    t.boolean  "measures_dimension"
    t.boolean  "allow_free_form_response", :default => false, :null => false
  end

  add_index "questions", ["organization_id"], :name => "index_questions_on_organization_id"

  create_table "recorded_metrics", :force => true do |t|
    t.integer  "user_id"
    t.string   "value"
    t.date     "recorded_on"
    t.datetime "created_at",                                    :null => false
    t.datetime "updated_at",                                    :null => false
    t.integer  "metric_id"
    t.decimal  "numerical_value", :precision => 8, :scale => 2
  end

  add_index "recorded_metrics", ["metric_id"], :name => "index_recorded_metrics_on_metric_id"
  add_index "recorded_metrics", ["user_id"], :name => "index_recorded_metrics_on_user_id"

  create_table "response_translations", :force => true do |t|
    t.integer  "response_id"
    t.string   "locale"
    t.string   "short_text"
    t.text     "long_text"
    t.text     "suggestion"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "response_translations", ["locale"], :name => "index_response_translations_on_locale"
  add_index "response_translations", ["response_id"], :name => "index_response_translations_on_response_id"

  create_table "responses", :force => true do |t|
    t.integer  "question_id"
    t.string   "short_text"
    t.string   "long_text"
    t.integer  "points"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
    t.integer  "position"
    t.text     "suggestion"
    t.boolean  "alert"
  end

  add_index "responses", ["question_id"], :name => "index_responses_on_question_id"

  create_table "roles", :force => true do |t|
    t.string   "name"
    t.integer  "resource_id"
    t.string   "resource_type"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  add_index "roles", ["name", "resource_type", "resource_id"], :name => "index_roles_on_name_and_resource_type_and_resource_id"
  add_index "roles", ["name"], :name => "index_roles_on_name"

  create_table "selected_responses", :force => true do |t|
    t.integer  "user_id"
    t.integer  "response_id"
    t.datetime "created_at",          :null => false
    t.datetime "updated_at",          :null => false
    t.integer  "completed_survey_id"
    t.string   "free_form_value"
    t.integer  "question_id"
  end

  add_index "selected_responses", ["completed_survey_id"], :name => "index_selected_responses_on_completed_survey_id"
  add_index "selected_responses", ["question_id"], :name => "index_selected_responses_on_question_id"
  add_index "selected_responses", ["response_id"], :name => "index_selected_responses_on_response_id"
  add_index "selected_responses", ["user_id"], :name => "index_selected_responses_on_user_id"

  create_table "survey_translations", :force => true do |t|
    t.integer  "survey_id"
    t.string   "locale"
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "survey_translations", ["locale"], :name => "index_survey_translations_on_locale"
  add_index "survey_translations", ["survey_id"], :name => "index_survey_translations_on_survey_id"

  create_table "surveys", :force => true do |t|
    t.string   "name"
    t.datetime "created_at",                        :null => false
    t.datetime "updated_at",                        :null => false
    t.integer  "organization_id"
    t.boolean  "active",          :default => true, :null => false
  end

  add_index "surveys", ["organization_id"], :name => "index_surveys_on_organization_id"

  create_table "users", :force => true do |t|
    t.string   "email",                  :default => "",    :null => false
    t.string   "encrypted_password",     :default => "",    :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                                :null => false
    t.datetime "updated_at",                                :null => false
    t.string   "name"
    t.string   "first_name"
    t.string   "last_name"
    t.integer  "score"
    t.float    "average"
    t.boolean  "active",                 :default => true,  :null => false
    t.string   "language",               :default => "en",  :null => false
    t.integer  "division_id"
    t.string   "authentication_token"
    t.integer  "reminder_hour"
    t.boolean  "reminder_active",        :default => false
    t.string   "phone_number"
  end

  add_index "users", ["authentication_token"], :name => "index_users_on_authentication_token"
  add_index "users", ["email"], :name => "index_users_on_email"
  add_index "users", ["reminder_hour"], :name => "index_users_on_reminder_hour"
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

  create_table "users_roles", :id => false, :force => true do |t|
    t.integer "user_id"
    t.integer "role_id"
  end

  add_index "users_roles", ["user_id", "role_id"], :name => "index_users_roles_on_user_id_and_role_id"

  create_table "versions", :force => true do |t|
    t.string   "item_type",  :null => false
    t.integer  "item_id",    :null => false
    t.string   "event",      :null => false
    t.string   "whodunnit"
    t.text     "object"
    t.datetime "created_at"
  end

  add_index "versions", ["item_type", "item_id"], :name => "index_versions_on_item_type_and_item_id"

end
