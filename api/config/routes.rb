# namespaceを使用することで、urlおよびファイル構成が、api/v1/~となる
# railsをapiとして使用する場合、後々のバージョンアップも踏まえてapi/v1/~とすることが多い（らしい）
Rails.application.routes.draw do
  namespace 'api' do
    namespace 'v1' do
      get 'questions/:language', to: 'questions#questions'
    end
  end
end
