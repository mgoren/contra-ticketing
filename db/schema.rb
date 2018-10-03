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
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2018_09_28_203239) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "orders", force: :cascade do |t|
    t.string "email", limit: 255, null: false
    t.string "name", limit: 255, null: false
    t.string "phone", limit: 255, null: false
    t.integer "admission_quantity"
    t.integer "admission_cost"
    t.integer "tshirt_quantity"
    t.integer "tshirt_cost"
    t.string "tshirt_note", limit: 255
    t.string "charge_id"
    t.integer "total"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["charge_id"], name: "index_orders_on_charge_id", unique: true
  end

end
