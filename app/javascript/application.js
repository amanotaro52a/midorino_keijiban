// Entry point for the build script in your package.json
import "@hotwired/turbo-rails"
import "./image_picker"
import "./controllers/application"
import * as bootstrap from "bootstrap"

document.addEventListener('turbo:load', initializeMasonry);

function initializeMasonry() {
  const grids = document.querySelectorAll('.row');
  grids.forEach(initializeGridMasonry);
}

function initializeGridMasonry(grid) {
  // 投稿カードが含まれている row のみを対象にする
  if (!grid.querySelector('[id^="post-id-"]')) return;
  if (typeof Masonry === 'undefined') return;

  // 既に Masonry が初期化されている場合は破棄してから再初期化
  grid.masonryInstance?.destroy();
  grid.masonryInstance = null;

  const images = grid.querySelectorAll('img');
  if (images.length === 0) {
    createMasonry(grid);
    return;
  }

  waitForImages(images, () => createMasonry(grid));
}

// 各画像の読み込みを監視し、すべて完了したら callback を実行する
function waitForImages(images, callback) {
  let loaded = 0;
  const onDone = () => { if (++loaded === images.length) callback(); };

  images.forEach(img => {
    if (img.complete) {
      onDone();
    } else {
      img.addEventListener('load',  onDone, { once: true });
      img.addEventListener('error', onDone, { once: true });
    }
  });
}

function createMasonry(grid) {
  grid.masonryInstance = new Masonry(grid, {
    itemSelector: '.col-6',
    percentPosition: true,
    gutter: 0
  });
}