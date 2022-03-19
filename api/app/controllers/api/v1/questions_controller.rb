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
    language = params[:language]
    case language
      when "html" then
        search_keyword = "HTML"
      when "css" then
        search_keyword = "CSS"
      when "ruby" then
        search_keyword = "Ruby"
      when "java" then
        search_keyword = "Java"
      when "linux" then
        search_keyword = "Linux"
      when "javascript" then
        search_keyword = "JavaScript"
    end
    category_id = Category.find_by(language: search_keyword)
    choice = Question.where(category_id: category_id)
    conclude = choice.as_json(only: [:word ,:explain])
    pickup = conclude.shuffle.slice(0,9)
    render json: { questions: (pickup * 2).shuffle }
  end
end