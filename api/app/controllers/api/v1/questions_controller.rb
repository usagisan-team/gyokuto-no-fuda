class Api::V1::QuestionsController < ApplicationController
    def questions
        # Vueからのリクエストurl /api/v1/questions/:language の:language部分を取得
          # そのlanguageの問題９問をランダムに選出
          # 2枚x9問で18要素のデータをjson形式で返す
  
          # 形式：2x9要素がシャッフルされた状態
      #		{ questions:
      #			{'word': 'div', 'explain': 'divです'},
      #			{'word': 'span', 'explain': 'spanです'},
      #			{'word': 'div', 'explain': 'divです'},
      #			....
      #		}
      render json: {
        questions: {'word': 'div', 'explain': 'divです'}
      }
    end
end
