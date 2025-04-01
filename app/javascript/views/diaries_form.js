document.addEventListener("DOMContentLoaded", function() {
  document.querySelectorAll('.remove-growth-stage-btn').forEach(function(button) {
    button.addEventListener('click', function() {
      const growthStageItem = this.closest('.growth-stage-item');
      const destroyField = growthStageItem.querySelector('.destroy-hidden-field');
      destroyField.value = "true"; 
      growthStageItem.style.display = 'none'; 
    });
  });
  document.getElementById('add-growth-stage-content').addEventListener('click', function() {
    const container = document.getElementById('growth-stage-contents');
    const index = container.children.length;
    const newItem = document.createElement('div');
    newItem.classList.add('mb-3', 'growth-stage-item');

    newItem.innerHTML = `
      <label for="diary_growth_stages_attributes_${index}_growth_stage_contents"><%= t('activerecord.attributes.diary.growth_stage_contents') %></label>
      <textarea name="diary[growth_stages_attributes][${index}][growth_stage_contents]" class="form-control growth_stage_content" rows="4" placeholder="⚪︎月⚪︎日"></textarea>
      <input type="file" name="diary[growth_stages_attributes][${index}][image]" class="form-control" accept="image/*">

      <input type="hidden" name="diary[growth_stages_attributes][${index}][_destroy]" value="false" class="destroy-hidden-field">

      <button type="button" class="btn btn-danger remove-growth-stage-btn"><%= t('buttons.destroy') %></button>
    `;

    container.appendChild(newItem);

    newItem.querySelector('.remove-growth-stage-btn').addEventListener('click', function() {
      const destroyField = newItem.querySelector('.destroy-hidden-field');
      destroyField.value = "true"; 
      newItem.style.display = 'none'; 
    });
  });
});