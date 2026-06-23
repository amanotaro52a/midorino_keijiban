// 許可する画像形式
const ALLOWED_TYPES = ["image/jpeg", "image/png", "image/webp", "image/gif"];
const MAX_SIZE_MB   = 10;

// モジュールスコープに保持。Turboで body が差し替わっても消えない
let selectedFile = null;

function setupImagePicker() {
  const zone  = document.getElementById("imagePickerZone");
  const input = document.getElementById("imageFileInput");
  if (!zone || !input) return;

  const emptyState  = document.getElementById("pickerEmpty");
  const currentWrap = document.getElementById("pickerCurrent");
  const newPreview  = document.getElementById("pickerNewPreview");
  const newThumb    = document.getElementById("pickerNewThumb");
  const newName     = document.getElementById("pickerNewName");
  const newSize     = document.getElementById("pickerNewSize");
  const clearBtn    = document.getElementById("pickerClearBtn");
  const clearLabel  = document.getElementById("pickerClearLabel");
  const changeBtn   = zone.querySelector(".picker-change-btn");

  // hasCurrent は毎回 DOM から読み直す（再描画のたびに変わりうるため）
  const hasCurrent = input.dataset.hasCurrent === "true";

  // turbo:load と turbo:render の両方を listen するため、
  // 同じ DOM に対して二重登録しないようガードする
  if (zone.dataset.bound !== "true") {
    zone.dataset.bound = "true";

    // 「変更する」ボタン（編集時のみ存在）
    if (changeBtn) {
      changeBtn.addEventListener("click", (e) => {
        e.stopPropagation();
        input.click();
      });
    }

    // ゾーン全体クリック（新規投稿時のみ発火）
    zone.addEventListener("click", () => {
      if (!hasCurrent) input.click();
    });

    // キーボード操作（スペースキーのスクロール抑止）
    zone.addEventListener("keydown", (e) => {
      if (e.key === "Enter" || e.key === " ") {
        e.preventDefault();
        input.click();
      }
    });

    // ドラッグ＆ドロップ
    zone.addEventListener("dragover", (e) => {
      e.preventDefault();
      zone.classList.add("is-filled");
    });
    zone.addEventListener("dragleave", () => {
      if (!input.files.length) zone.classList.remove("is-filled");
    });
    zone.addEventListener("drop", (e) => {
      e.preventDefault();
      const file = e.dataTransfer.files[0];
      if (file) handleFileSelect(file);
    });

    // ファイル選択
    input.addEventListener("change", () => {
      const file = input.files[0];
      if (file) {
        handleFileSelect(file);
      }
    });

    // 選択解除ボタン
    clearBtn.addEventListener("click", (e) => {
      e.stopPropagation();
      clearSelection();
    });
  }

  // サーバー再描画で input.files は必ず空になるので、
  // 保持していた File があれば自動で復元する
  if (selectedFile && input.files.length === 0) {
    applyFile(selectedFile, true);
  }

  // ファイルのバリデーションを一元管理する
  function handleFileSelect(file, isRestore = false) {
    if (!ALLOWED_TYPES.includes(file.type)) {
      alert("JPEG・PNG・WebP・GIF形式の画像を選択してください。");
      if (!isRestore) input.value = "";
      return;
    }
    if (!isRestore && file.size > MAX_SIZE_MB * 1024 * 1024) {
      alert(`${MAX_SIZE_MB}MB以内の画像を選択してください。`);
      input.value = "";
      return;
    }
    applyFile(file, isRestore);
  }

  function applyFile(file, isRestore = false) {
    const dt = new DataTransfer();
    dt.items.add(file);
    input.files = dt.files;

    selectedFile = file; // 状態を保持

    // メモリーリーク防止：既存の Object URL を解放
    if (newThumb.dataset.objectUrl) {
      URL.revokeObjectURL(newThumb.dataset.objectUrl);
    }

    const objectUrl = URL.createObjectURL(file);
    newThumb.dataset.objectUrl = objectUrl;
    newThumb.src = objectUrl;

    // 画像読み込み失敗時のエラーハンドリング
    newThumb.onerror = () => {
      alert("画像の読み込みに失敗しました。ファイルが破損している可能性があります。");
      clearSelection();
    };

    newName.textContent    = file.name;
    newSize.textContent    = (file.size / 1024 / 1024).toFixed(2) + " MB";
    clearLabel.textContent = hasCurrent ? "元の画像に戻す" : "選択解除";

    // 表示切り替え
    emptyState.style.display         = "none";
    if (currentWrap) currentWrap.style.display = "none";
    newPreview.style.display         = "";
    zone.classList.add("is-filled");
  }

  function clearSelection() {
    // メモリーリーク防止：Object URL を解放
    if (newThumb.dataset.objectUrl) {
      URL.revokeObjectURL(newThumb.dataset.objectUrl);
      delete newThumb.dataset.objectUrl;
    }

    input.value  = "";
    selectedFile = null; // 保持していた状態もクリア
    newPreview.style.display = "none";

    if (hasCurrent) {
      // 編集：既存画像に戻す
      if (currentWrap) currentWrap.style.display = "";
    } else {
      // 新規：空状態に戻す
      emptyState.style.display = "";
      zone.classList.remove("is-filled");
    }
  }
}

document.addEventListener("turbo:load",   setupImagePicker);
document.addEventListener("turbo:render", setupImagePicker);