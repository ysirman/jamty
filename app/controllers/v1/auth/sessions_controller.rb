class V1::Auth::SessionsController < Devise::SessionsController
  skip_before_action :verify_authenticity_token # CSRFは CORSの確認で対策するため、無効にしておく
  prepend_before_action :check_api_key # 自由にリクエストされた場合の防止策として、念の為、API_KEYを設定して照合しておく。prepend_before_action :verify_signed_out_user, only: :destroyよりも前に実行したいので、before_actionは使わない。

  respond_to :json

  def create
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

    def check_api_key
      return if params[:api_key] == ENV['API_KEY']

      request.headers[:authorization] = nil # Warden内で必ずrevoke_jwtが呼ばれてヘッダーのJWTのUserをログアウトさせてしまう。そのため、事前にヘッダー削除しておく。
      render json: { message: 'bad credentials' }, status: :unauthorized
    end

    def respond_to_on_destroy
      current_v1_user ? log_out_success : log_out_failure
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
