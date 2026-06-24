import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["plantName", "status", "suggestions", "identifyBtn"]

  // 「判別する」ボタンの click から呼ばれる
  async identify() {
    const fileInput = document.getElementById("imageFileInput")
    const file = fileInput?.files[0]

    if (!file) {
      this.#showError("先に画像を選択してください")
      return
    }

    await this.#requestIdentification(file)
  }

  // 候補チップをクリックしたときに植物名フィールドへ反映
  selectPlant(event) {
    const name = event.currentTarget.dataset.plantName
    this.plantNameTarget.value = name

    this.suggestionsTarget.querySelectorAll(".plant-candidate-chip").forEach(btn => {
      btn.classList.remove("btn-success", "active")
      btn.classList.add("btn-outline-success")
    })
    event.currentTarget.classList.remove("btn-outline-success")
    event.currentTarget.classList.add("btn-success", "active")
  }

  // ---------- private ----------

  async #requestIdentification(file) {
    this.#setLoading(true)

    const formData  = new FormData()
    const csrfToken = document.querySelector('meta[name="csrf-token"]')?.content
    formData.append("image", file)

    try {
      const response = await fetch("/plant_identifications", {
        method: "POST",
        headers: { "X-CSRF-Token": csrfToken },
        body: formData
      })

      const data = await response.json()

      if (!response.ok || data.error) {
        this.#showError(data.error || "識別に失敗しました")
        return
      }

      this.#showResults(data.results)
    } catch {
      this.#showError("通信エラーが発生しました")
    } finally {
      this.#setLoading(false)
    }
  }

  #setLoading(isLoading) {
    if (!this.hasIdentifyBtnTarget) return

    this.identifyBtnTarget.disabled  = isLoading
    this.identifyBtnTarget.innerHTML = isLoading
      ? `<span class="spinner-border spinner-border-sm me-1" role="status" aria-hidden="true"></span>判別中...`
      : `<i class="bi bi-search me-1" aria-hidden="true"></i>判別する`

    if (isLoading) {
      this.statusTarget.innerHTML      = ""
      this.suggestionsTarget.innerHTML = ""
    }
  }

  #showError(message) {
    this.statusTarget.innerHTML = `
      <div class="text-danger small">
        <i class="bi bi-exclamation-circle-fill me-1" aria-hidden="true"></i>${this.#escapeHtml(message)}
        ／植物名は手入力できます
      </div>`
  }

  #showResults(results) {
    if (!results?.length) {
      this.#showError("植物を識別できませんでした。手入力をお試しください")
      return
    }

    this.statusTarget.innerHTML = `
      <div class="text-success small">
        <i class="bi bi-stars me-1" aria-hidden="true"></i>候補をクリックして選択できます
      </div>`

    this.suggestionsTarget.innerHTML = results.map(r => {
      const pct             = Math.round(r.score * 100)
      const displayName     = this.#escapeHtml(r.display_name)
      const sciName         = this.#escapeHtml(r.scientific_name)
      const confidenceClass = pct >= 70 ? "bg-success" : pct >= 40 ? "bg-warning text-dark" : "bg-secondary"
      const isFallback      = r.display_name === r.scientific_name

      return `
        <button type="button"
                class="plant-candidate-chip btn btn-outline-success btn-sm d-inline-flex align-items-center gap-2"
                data-action="click->plant-identify#selectPlant"
                data-plant-name="${displayName}">
          <span>
            ${displayName}${isFallback ? '<span class="text-secondary fst-italic"> (学名)</span>' : ""}
          </span>
          <span class="badge ${confidenceClass}">${pct}%</span>
        </button>`
    }).join("")
  }

  #escapeHtml(str = "") {
    return str.replace(/[&<>"']/g, c =>
      ({ "&": "&amp;", "<": "&lt;", ">": "&gt;", '"': "&quot;", "'": "&#39;" }[c]))
  }
}