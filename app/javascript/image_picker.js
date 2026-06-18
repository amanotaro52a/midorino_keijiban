document.addEventListener("turbo:render", () => {
  const zone     = document.getElementById("imagePickerZone");
  const input    = document.getElementById("imageFileInput");
  if (!zone || !input) return;

  const hasCurrent  = input.dataset.hasCurrent === "true";
  const emptyState  = document.getElementById("pickerEmpty");
  const currentWrap = document.getElementById("pickerCurrent");
  const newPreview  = document.getElementById("pickerNewPreview");
  const newThumb    = document.getElementById("pickerNewThumb");
  const newName     = document.getElementById("pickerNewName");
  const newSize     = document.getElementById("pickerNewSize");
  const clearBtn    = document.getElementById("pickerClearBtn");
  const clearLabel  = document.getElementById("pickerClearLabel");
  const changeBtn   = zone.querySelector(".picker-change-btn");

  // 許可する画像形式
  const ALLOWED_TYPES = ["image/jpeg", "image/png", "image/webp", "image/gif"];
  const MAX_SIZE_MB   = 10;

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
    if (file && ALLOWED_TYPES.includes(file.type)) {
      applyFile(file);
    } else if (file) {
      alert("JPEG・PNG・WebP・GIF形式の画像を選択してください。");
    }
  });

  // ファイル選択
  input.addEventListener("change", () => {
    const file = input.files[0];
    if (file && ALLOWED_TYPES.includes(file.type)) {
      applyFile(file);
    } else if (file) {
      alert("JPEG・PNG・WebP・GIF形式の画像を選択してください。");
      input.value = "";
    }
  });

  // 選択解除ボタン
  clearBtn.addEventListener("click", (e) => {
    e.stopPropagation();
    clearSelection();
  });

  function applyFile(file) {
    const dt = new DataTransfer();
    dt.items.add(file);
    input.files = dt.files;

    // サイズチェック
    if (file.size > MAX_SIZE_MB * 1024 * 1024) {
      alert(`${MAX_SIZE_MB}MB以内の画像を選択してください。`);
      input.value = "";
      return;
    }

    // メモリリーク防止：既存のObject URLを解放
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
    emptyState.style.display  = "none";
    if (currentWrap) currentWrap.style.display = "none";
    newPreview.style.display  = "";
    zone.classList.add("is-filled");
  }

  function clearSelection() {
    // メモリリーク防止：Object URLを解放
    if (newThumb.dataset.objectUrl) {
      URL.revokeObjectURL(newThumb.dataset.objectUrl);
      delete newThumb.dataset.objectUrl;
    }

    input.value              = "";
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
});