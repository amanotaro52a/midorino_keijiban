// Entry point for the build script in your package.json
import "@hotwired/turbo-rails"
import "./image_picker"
import "./controllers/autocomplete_controller"
import * as bootstrap from "bootstrap"

document.addEventListener('turbo:load', function() {
  initializeMasonry();
});
 
function initializeMasonry() {
  // メイソンリーを適用する要素を取得
  const grids = document.querySelectorAll('.row');
 
  grids.forEach(grid => {
    // 投稿カードが含まれている row のみを対象にする
    const hasPostCards = grid.querySelector('[id^="post-id-"]');
    if (!hasPostCards) {
      return;
    }
 
    // 既に Masonry が初期化されている場合は破棄してから再初期化
    if (grid.masonryInstance) {
      grid.masonryInstance.destroy();
      grid.masonryInstance = null;
    }
 
    if (typeof Masonry === 'undefined') {
      return;
    }
 
    const images = grid.querySelectorAll('img');
    const totalImages = images.length;
 
    if (totalImages === 0) {
      // 画像がない場合はすぐに初期化
      createMasonry(grid);
      return;
    }
 
    let loadedImages = 0;
    const handleImageDone = () => {
      loadedImages++;
      if (loadedImages === totalImages) {
        createMasonry(grid);
      }
    };
 
    // 各画像の読み込みを監視（once: true で多重登録を防止）
    images.forEach(img => {
      if (img.complete) {
        handleImageDone();
      } else {
        img.addEventListener('load', handleImageDone, { once: true });
        img.addEventListener('error', handleImageDone, { once: true });
      }
    });
  });
}
 
function createMasonry(grid) {
  const masonryInstance = new Masonry(grid, {
    itemSelector: '.col-6',
    percentPosition: true,
    gutter: 0
  });
 
  // インスタンスを保存（再初期化時に破棄するため）
  grid.masonryInstance = masonryInstance;
}