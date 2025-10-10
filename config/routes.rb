Rails.application.routes.draw do
  # Deviseのルーティングからログアウト(:sign_out)を一旦除外
  devise_for :users,
        controllers: {
          registrations: "users/registrations",
          sessions: "users/sessions"
        },
        path: "",
        path_names: {
          sign_in: "login",
          # sign_out: "logout", # ここをコメントアウトまたは削除
          registration: "signup"
        },
        defaults: { format: :json },
        # :sign_outをskip_helpersから削除し、sign_out_pathなどのヘルパーは使えるようにする
        skip: [ :passwords, :confirmations, :unlocks, :sessions ]

  # devise_scopeを使って、手動でセッションルートを定義
  devise_scope :user do
    post "login", to: "users/sessions#create"
    # authenticatedブロックを使い、認証済みの場合のみlogoutルートを有効にする
    authenticated :user do
      delete "logout", to: "users/sessions#destroy"
    end

    # 認証されていない場合のlogoutルートも定義し、401を返すようにする
    # これにより、トークンなしでDELETE /logoutにアクセスした場合のルートが確保される
    # 実際のリクエストは、上記のauthenticatedブロックで弾かれる
    unauthenticated do
      delete "logout", to: ->(env) { [401, {}, ['{"error":"Unauthorized"}']] }
    end
  end

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check
  get "/me", to: "users#me"

  # Defines the root path route ("/")
  # root "posts#index"

  namespace :api do
    namespace :v1 do
      # Auth.jsからのコールバックを受けるエンドポイント
      post "auth/callback", to: "auth_callbacks#create"
    end
  end
end