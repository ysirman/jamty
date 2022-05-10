# frozen_string_literal: true

class DeviseCreateUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :users do |t|
      # Omniauth用
      t.string :provider, :null => false, :default => "twitter"
      t.string :uid, :null => false, :default => ""
      t.string :name # twitterの@付きの名前
      t.string :nickname # twitterの@付いてない方の名前
      t.string :image
      t.string :description # 追加
      t.string :location # 追加

      ## Database authenticatable
      # devise-jwt は bypass_sign_in に対応していないのでダミー値として使用する
      t.string :email,              null: false, default: ""
      t.string :encrypted_password, null: false, default: ""

      ## Recoverable
      # t.string   :reset_password_token
      # t.datetime :reset_password_sent_at

      ## Rememberable
      # t.datetime :remember_created_at

      ## Trackable
      # JWTだと操作する度に更新される為、無効にしておく
      # t.integer  :sign_in_count, default: 0, null: false
      # t.datetime :current_sign_in_at
      # t.datetime :last_sign_in_at
      # t.string   :current_sign_in_ip
      # t.string   :last_sign_in_ip

      ## Confirmable
      # t.string   :confirmation_token
      # t.datetime :confirmed_at
      # t.datetime :confirmation_sent_at
      # t.string   :unconfirmed_email # Only if using reconfirmable

      # devise-jwt用のカラム
      t.string :jti, null: false

      ## Lockable
      # t.integer  :failed_attempts, default: 0, null: false # Only if lock strategy is :failed_attempts
      # t.string   :unlock_token # Only if unlock strategy is :email or :both
      t.datetime :locked_at


      t.timestamps null: false
    end

    add_index :users, :email,                unique: true
    # add_index :users, :reset_password_token, unique: true
    # add_index :users, :confirmation_token,   unique: true
    # add_index :users, :unlock_token,         unique: true
    add_index :users, [:uid, :provider],     unique: true
    add_index :users, :jti, unique: true
  end
end
