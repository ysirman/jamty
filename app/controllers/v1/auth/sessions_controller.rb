class V1::Auth::SessionsController < Devise::SessionsController
  # CSRFは CORSの確認で対策するため、無効にしておく
  skip_before_action :verify_authenticity_token

  respond_to :json

  def create
    # 自由にリクエストされた場合の防止策として、念の為、API_KEYを設定して照合しておく
    return render json: { message: 'bad credentials' }, status: :unauthorized unless params[:api_key] == ENV['API_KEY']
    return render json: { message: 'bad credentials' }, status: :unauthorized if params[:uid].blank? || params[:provider].blank? || params[:name].blank?

    # Next-Authで取得した情報でそのままユーザー作成
    user = User.find_or_create_by!(uid: params[:uid], provider: params[:provider]) do |u|
      u.assign_attributes(user_params)
    end
    # 後々、管理側からのみ強制的にロックする機能を作った時に活用予定
    return render json: { message: 'account locked' }, status: :unauthorized if user.locked_at

    # Next-Authを使ってフロント側で認証済みなので bypass_sign_in(user) としたいが、レスポンスヘッダーにAuthorizationが付与されない為、フロント側から送信するダミーのemail/passwordでサインインする
    sign_in(resource_name, user)
    render json: user
  end

  private

    def respond_to_on_destroy
      current_user ? log_out_success : log_out_failure
    end

    def log_out_success
      render json: { message: "Logged out." }, status: :ok
    end

    def log_out_failure
      render json: { message: "Logged out failure." }, status: :unauthorized
    end

    def user_params
      params.permit(
        :provider,
        :uid,
        :name,
        :nickname,
        :image,
        :email,
        :password
      )
    end
end
