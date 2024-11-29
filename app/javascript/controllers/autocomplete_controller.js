import { Controller } from "stimulus"
import { Autocomplete } from "stimulus-autocomplete"

export default class extends Controller {
  static targets = ["input"]

  connect() {
    new Autocomplete(this.inputTarget, {
      getData: (query) => {
        return fetch(`/diaries/search.json?q=${query}`)  // Ajaxリクエストでデータ取得
          .then(response => response.json())
          .then(data => data)  // サーバーから返されたデータ
      }
    })
  }
}
