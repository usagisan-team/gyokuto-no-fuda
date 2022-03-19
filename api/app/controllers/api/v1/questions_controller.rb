class Api::V1::QuestionsController < ApplicationController
  def questions
    # Vueからのリクエストurl /api/v1/questions/:language の:language部分を取得
    # そのlanguageの問題９問をランダムに選出
    # 2枚x9問で18要素のデータをjson形式で返す
    # 形式：2x9要素がシャッフルされた状態
    #   { questions:
    #     {'word': 'div', 'explain': 'divです'},
    #     {'word': 'span', 'explain': 'spanです'},
    #     {'word': 'div', 'explain': 'divです'},
    #     ....
    #   }
    data = Question.all
    language = params[:language]
    case language
      when "html" then
        search_keyword = "HTML"
      when "css" then
        search_keyword = "CSS"
      when "ruby"
        search_keyword = "Ruby"
      when "java"
        search_keyword = "Java"
      when "linux"
        search_keyword = "Linux"
      when "javascript"
        search_keyword = "JavaScript"
    end
    category_id = Category.find_by(language: search_keyword)
    choice = data.where(category_id: category_id)
    conclude = choice.as_json(only: [:word ,:explain])
    shuffled_lists = conclude.shuffle
    n = 9
    pickup = shuffled_lists.slice(0,n)
    double = pickup * 2
    double_again = double.shuffle
    render json: { questions: double_again }
  end
end